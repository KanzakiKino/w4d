// Written in the D programming language.
/++
 + Authors: KanzakiKino
 + Copyright: KanzakiKino 2018
 + License: LGPL-3.0
++/
module w4d.widget.base;
import w4d.element.box,
       w4d.layout.placer.base,
       w4d.layout.placer.lineup,
       w4d.layout.base,
       w4d.layout.fill,
       w4d.parser.colorset,
       w4d.style.color,
       w4d.style.widget,
       w4d.task.window,
       w4d.widget.base.context,
       w4d.widget.base.keyboard,
       w4d.widget.base.mouse,
       w4d.exception;
import g4d.glfw.cursor,
       g4d.shader.base;
import gl3n.linalg;
import std.algorithm,
       std.array,
       std.conv;

mixin Context;

/// An empty widget.
class Widget : WindowContent, Layoutable
{
    protected uint _status;
    /// Current status.
    const @property status () { return _status; }

    protected WindowContext _context;

    protected WidgetStyle _style;
    /// Style of the widget.
    inout @property inout(WidgetStyle) style () { return _style; }

    protected ColorSet _colorset;
    /// Current colorset.
    const @property colorset () { return _colorset; }

    protected Layout _layout;
    /// Layout object.
    inout @property inout(Layout) layoutObject () { return _layout; }

    protected bool _needLayout;

    protected BoxElement _box;

    protected Widget findChildAt ( vec2 pt )
    {
        // Use reversed foreach to match the order with drawing.
        foreach_reverse ( c; calcedChildren ) {
            if ( c.style.isPointInside(pt) ) {
                return c;
            }
        }
        return null;
    }

    mixin Mouse;
    mixin Keyboard;

    ///
    void handlePopup ( bool, WindowContext )
    {
    }

    ///
    this ()
    {
        _status   = WidgetState.None;
        _style    = new WidgetStyle;
        _colorset = new ColorSet;

        _context = null;
        _box     = new BoxElement;

        _needLayout = true;

        parseColorSetsFromFile!"colorset/widget.yaml"( style );
        setLayout!( FillLayout, HorizontalLineupPlacer )();
    }

    ///
    @property vec2 wantedSize ()
    {
        return vec2(-1,-1);
    }
    /// Child widgets.
    @property Widget[] children ()
    {
        return [];
    }
    /// Child widgets that have no uncalculated style properties.
    @property Widget[] calcedChildren ()
    {
        return children.filter!"a.style.isCalced".array;
    }
    /// Child widgets that are casted to PlacerOwner.
    @property PlacerOwner[] childPlacerOwners ()
    {
        return children.to!( PlacerOwner[] );
    }
    /// Child widgets that are casted to Layoutable.
    @property Layoutable[] childLayoutables ()
    {
        return children.to!( Layoutable[] );
    }

    protected void infectWindowContext ()
    {
        enforce( _context, "WindowContext is null." );
        children.each!( x => x._context = _context );
    }

    /// Enables the state.
    void enableState ( WidgetState state )
    {
        _status |= state;
        if ( state in style.colorsets ) {
            requestRedraw();
        }
    }
    /// Disables the state.
    void disableState ( WidgetState state )
    {
        _status &= ~state;
        if ( state in style.colorsets ) {
            requestRedraw();
        }
    }

    /// Changes Layout object.
    void setLayout (L,P,Args...) ( Args args )
    {
        _layout = new L( new P( this ), this, args );
    }
    /// Checks if the widget needs re-layout.
    bool checkNeedLayout ( bool recursively )
    {
        if ( recursively ) {
            return _needLayout ||
                   children.canFind!"a.needLayout" ||
                   !style.isCalced;
        }
        return _needLayout;
    }
    /// Checks if the widget needs re-layout.
    @property bool needLayout ()
    {
        return checkNeedLayout( true );
    }
    /// Set needLayout true.
    void requestLayout ()
    {
        _needLayout = true;
    }
    /// Re-layouts the widget.
    /// Be called only by Window.
    void layout ( vec2i size )
    {
        layout( vec2(0,0), vec2(size) );
    }
    /// Re-layouts the widget.
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
    ///
    void shift ( vec2 size )
    {
        _layout.shift( size );
        requestRedraw();
    }

    /// Checks if the widget needs redrawing.
    @property bool needRedraw ()
    {
        return _context && _context.needRedraw;
    }
    /// Sets needRedraw true.
    void requestRedraw ()
    {
        if ( _context ) {
            _context.requestRedraw();
        }
    }
    protected void drawBox ( Window win )
    {
        auto  shader = win.shaders.fill3;
        const saver  = ShaderStateSaver( shader );

        shader.use();
        shader.matrix.late = vec3(
                style.clientLeftTop + style.box.clientSize/2, 0 );

        _box.setColor( colorset );
        _box.draw( shader );
    }
    protected void drawChildren ( Window win )
    {
        //children.each!( x => x.draw(win,colorset) );
        foreach ( child; children ) {
            child.draw( win, _colorset );
        }
    }
    /// Draws the widget.
    /// Be called only by Window.
    void draw ( Window win )
    {
        draw( win, null );
    }
    /// Draws the widget.
    void draw ( Window win, in ColorSet parent )
    {
        _colorset.clear();
        style.inheritColorSet( _colorset, status );
        if ( parent ) {
            _colorset.inherit( parent );
        }

        drawBox( win );
        drawChildren( win );
        _context.setNoNeedRedraw();
    }
}
