// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module w4d.widget.base;
import w4d.element.box,
       w4d.layout.base,
       w4d.layout.fill,
       w4d.parser.theme,
       w4d.style.widget,
       w4d.task.window,
       w4d.exception;
import g4d.math.vector,
       g4d.shader.base;
import std.algorithm,
       std.conv;

class Widget : WindowContent, Layoutable
{
    protected uint _status;
    const @property status () { return _status; }

    protected WidgetStyle _style;
    @property WidgetStyle style    () { return _style; }
    @property ref         colorset () { return style.getColorSet(_status); }

    protected Layout        _layout;
    protected BoxElement    _box;
    protected WindowContext _context;

    protected Widget _hovered;
    @property Widget[] children () { return []; }

    @property Layoutable[] childLayoutables ()
    {
        return children.to!( Layoutable[] );
    }

    protected bool _needRedraw;
    protected bool _needLayout;

    protected Widget findChildAt ( vec2 pt )
    {
        foreach ( c; children ) {
            if ( c.style.isPointInside(pt) ) {
                return c;
            }
        }
        return null;
    }
    protected void setHovered ( Widget child, vec2 pos )
    {
        auto temp = _hovered;
        _hovered = child;

        if ( child !is temp ) {
            if ( temp  ) temp .handleMouseEnter( false, pos );
            if ( child ) child.handleMouseEnter(  true, pos );
        }
    }

    override bool handleMouseEnter ( bool entered, vec2 pos )
    {
        if ( _context.tracked && !isTracked ) {
            return true;
        }

        if ( entered ) {
            enableState( WidgetState.Hovered );
        } else {
            setHovered( null, pos );
            disableState( WidgetState.Hovered );
        }
        return false;
    }
    override bool handleMouseMove ( vec2 pos )
    {
        if ( !isTracked ) {
            if ( _context.tracked ) {
                return _context.tracked.handleMouseMove( pos );
            } else if ( auto target = findChildAt(pos) ) {
                setHovered( target, pos );
                if ( target.handleMouseMove( pos ) ) {
                    return true;
                }
            } else {
                setHovered( null, pos );
            }
        }
        return false;
    }
    override bool handleMouseButton ( MouseButton btn, bool status, vec2 pos )
    {

        if ( !isTracked ) {
            if ( _context.tracked ) {
                return _context.tracked.handleMouseButton( btn, status, pos );
            } else if ( auto target = findChildAt(pos) ) {
                if ( target.handleMouseButton( btn, status, pos ) ) {
                    return true;
                }
                if ( _context.tracked ) {
                    return true;
                }
            }
        }

        if ( btn == MouseButton.Left && status ) {
            enableState( WidgetState.Pressed );
            track();
        } else if ( btn == MouseButton.Left && !status ) {
            if ( isTracked ) refuseTrack();
            disableState( WidgetState.Pressed );
        }
        return false;
    }
    override bool handleMouseScroll ( vec2 amount, vec2 pos )
    {
        if ( !isTracked ) {
            if ( _context.tracked ) {
                return _context.tracked.handleMouseScroll( amount, pos );
            } else if ( auto target = findChildAt(pos) ) {
                if ( target.handleMouseScroll( amount, pos ) ) {
                    return true;
                }
            }
        }
        return false;
    }

    override bool handleKey ( Key key, KeyState status )
    {
        if ( !isFocused ) {
            if ( _context.focused ) {
                return _context.focused.handleKey( key, status );
            } else if ( children.canFind!(x => x.handleKey( key, status )) ) {
                return true;
            }
        }
        return false;
    }
    override bool handleTextInput ( dchar c )
    {
        if ( _context.focused && !isFocused ) {
            return _context.focused.handleTextInput( c );
        }
        return false;
    }

    void handleTracked ( bool a )
    {
        (a? &enableState: &disableState)( WidgetState.Tracked );
    }
    void handleFocused ( bool a )
    {
        (a? &enableState: &disableState)( WidgetState.Focused );
    }

    this ()
    {
        _status = WidgetState.None;
        _style  = new WidgetStyle;

        _context = null;
        _box     = new BoxElement;

        setLayout!FillLayout();
        parseThemeFromFile!"theme/normal.yaml"( style );
    }

    protected void infectWindowContext ()
    {
        if ( !_context ) {
            _context = new WindowContext;
        }
        children.each!( x => x._context = _context );
    }

    void enableState ( WidgetState state )
    {
        _status |= state;
        requestRedraw();
    }
    void disableState ( WidgetState state )
    {
        _status &= ~state;
        requestRedraw();
    }

    @property isTracked ()
    {
        return _context && _context.tracked is this;
    }
    @property bool trackable () { return true; }
    void track ()
    {
        if ( trackable ) {
            enforce( _context, "WindowContext is null." );
            _context.setTracked( this );
        }
    }
    void refuseTrack ()
    {
        enforce( isTracked, "The widget has not been tracked." );
        _context.setTracked( null );
    }

    @property isFocused ()
    {
        return _context && _context.focused is this;
    }
    @property bool focusable () { return true; }
    void focus ()
    {
        if ( focusable ) {
            enforce( _context, "WindowContext is null." );
            _context.setFocused( this );
        }
    }
    void dropFocus ()
    {
        enforce( isFocused, "The widget has not been focused." );
        _context.setFocused( null );
    }

    void setLayout (L,Args...) ( Args args )
    {
        _layout = new L(this,args);
    }
    @property bool needLayout ()
    {
        return _needLayout || children.canFind!"a.needLayout" || !style.isCalced;
    }
    void requestLayout ()
    {
        _needLayout = true;
    }
    void layout ( vec2i size )
    { // Called only by Window.
        layout( vec2(0,0), vec2(size) );
    }
    vec2 layout ( vec2 pos, vec2 size )
    {
        enforce( _layout, "Layout is null." );
        _layout.place( pos, size );

        infectWindowContext();
        _box.resize( _style.box );
        requestRedraw();

        return style.box.collisionSize;
    }

    protected void shiftChildren ( vec2 a )
    {
        foreach ( c; children ) {
            c.style.x.alter( c.style.x.calced+a.x );
            c.style.y.alter( c.style.y.calced+a.y );
            c.shiftChildren( a );
        }
        requestRedraw();
    }

    override @property bool needRedraw ()
    {
        return _needRedraw || children.canFind!"a.needRedraw" || needLayout;
    }
    void requestRedraw ()
    {
        _needRedraw = true;
    }

    protected void drawBox ( Window win )
    {
        auto shader = win.shaders.fill3;
        auto saver  = ShaderStateSaver( shader );

        shader.use( false );
        shader.setVectors( vec3(style.translate,0) );

        _box.setColor( colorset );
        _box.draw( shader );
    }
    protected void drawChildren ( Window win )
    {
        children.each!(x => x.draw(win));
    }
    override void draw ( Window win )
    {
        drawBox( win );
        drawChildren( win );
        _needRedraw = false;
    }
}

class WindowContext
{
    protected Widget _tracked;
    @property tracked () { return _tracked; }
    protected Widget _focused;
    @property focused () { return _focused; }

    this ()
    {
        _tracked = null;
        _focused = null;
    }

    void setTracked ( Widget w )
    {
        auto temp = _tracked;
        _tracked = w;

        if ( w !is temp ) {
            if ( temp ) temp.handleTracked( false );
            if ( w    ) w   .handleTracked( true  );
        }
    }

    void setFocused ( Widget w )
    {
        auto temp = _focused;
        _focused = w;

        if ( w !is temp ) {
            if ( temp ) temp.handleFocused( false );
            if ( w    ) w   .handleFocused( true  );
        }
    }
}
