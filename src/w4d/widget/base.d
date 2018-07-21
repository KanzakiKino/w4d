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
import std.algorithm;

class Widget : WindowContent
{
    protected uint        _status;
    protected WidgetStyle _style;
    @property     style    () { return _style; }
    @property ref colorset () { return style.getColorSet(_status); }

    protected Layout        _layout;
    protected BoxElement    _box;
    protected WindowContext _context;

    protected Widget _hovered;
    @property Widget[] children     () { return []; }

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

        setLayout!FillLayout();
        parseThemeFromFile!"theme/normal.yaml"( style );
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

    void setLayout (L,Args...) ( Args args )
    {
        _layout = new L(style,args);
    }

    @property isTracked ()
    {
        return _context && _context.tracked is this;
    }
    void track ()
    {
        enforce( _context, "WindowContext is null." );
        _context.setTracked( this );
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
    void focus ()
    {
        enforce( _context, "WindowContext is null." );
        _context.setFocused( this );
    }
    void dropFocus ()
    {
        enforce( isFocused, "The widget has not been focused." );
        _context.setFocused( null );
    }

    @property bool needLayout ()
    {
        return _needLayout || children.canFind!"a.needLayout" || !style.isCalced;
    }
    void requestLayout ()
    {
        _needLayout = true;
    }
    override void resize ( vec2i newsz )
    {
        enforce( _layout, "Layout is null." );

        _layout.move( vec2(0,0), vec2(newsz) );
        layout();
    }
    void layout ()
    {
        enforce( _layout, "Layout is null." );

        if ( !_context ) {
            _context = new WindowContext;
        }

        foreach ( c; children ) {
            c._context = _context;
            _layout.push( c._layout );
        }
        _layout.fix();

        children.each!q{a.layout()};

        if ( !_box ) {
            _box = new BoxElement;
        }
        _box.resize( _style.box );

        _needLayout = false;
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
    override void draw ( Window win )
    {
        if ( needLayout ) {
            layout();
        }

        auto shader = win.shaders.fill3;
        auto saver  = ShaderStateSaver( shader );

        shader.use( false );
        shader.setVectors( vec3(style.translate,0) );

        _box.setColor( colorset );
        _box.draw( shader );

        children.each!(x => x.draw(win));

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
