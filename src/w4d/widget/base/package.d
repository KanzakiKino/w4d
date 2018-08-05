// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module w4d.widget.base;
import w4d.element.box,
       w4d.layout.base,
       w4d.layout.fill,
       w4d.parser.theme,
       w4d.style.widget,
       w4d.task.window,
       w4d.widget.base.context,
       w4d.widget.base.keyboard,
       w4d.widget.base.mouse,
       w4d.exception;
import g4d.math.vector,
       g4d.shader.base;
import std.algorithm,
       std.conv;

mixin Context;

class Widget : WindowContent, Layoutable
{
    protected uint _status;
    const @property status () { return _status; }

    protected WindowContext _context;

    protected WidgetStyle _style;
    @property WidgetStyle style    () { return _style; }
    @property ref         colorset () { return style.getColorSet(_status); }

    protected Layout        _layout;
    protected BoxElement    _box;

    protected bool _needLayout;

    protected Widget findChildAt ( vec2 pt )
    {
        // Use reversed foreach to match the order with drawing.
        foreach_reverse ( c; children ) {
            if ( c.style.isPointInside(pt) ) {
                return c;
            }
        }
        return null;
    }

    mixin Mouse;
    mixin Keyboard;

    void handlePopup ( bool, WindowContext )
    {
    }

    this ()
    {
        _status = WidgetState.None;
        _style  = new WidgetStyle;

        _context = null;
        _box     = new BoxElement;

        _needLayout = true;

        setLayout!FillLayout();
        parseThemeFromFile!"theme/normal.yaml"( style );
    }

    @property vec2 wantedSize ()
    {
        return vec2(-1,-1);
    }
    @property Widget[] children ()
    {
        return [];
    }
    @property Layoutable[] childLayoutables ()
    {
        return children.to!( Layoutable[] );
    }

    protected void infectWindowContext ()
    {
        enforce( _context, "WindowContext is null." );
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
    {
        layout( vec2(0,0), vec2(size) );
    }
    vec2 layout ( vec2 pos, vec2 size )
    {
        infectWindowContext();

        enforce( _layout, "Layout is null." );
        _layout.place( pos, size );
        _needLayout = false;

        _box.resize( _style.box );
        requestRedraw();

        return style.box.collisionSize;
    }
    void shiftChildren ( vec2 size )
    {
        foreach ( c; children ) {
            c.style.shift( size );
            c.shiftChildren( size );
        }
        requestRedraw();
    }

    @property bool needRedraw ()
    {
        return _context && _context.needRedraw;
    }
    void requestRedraw ()
    {
        if ( _context ) {
            _context.requestRedraw();
        }
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
    void draw ( Window win )
    {
        drawBox( win );
        drawChildren( win );
        _context.setNoNeedRedraw();
    }
}
