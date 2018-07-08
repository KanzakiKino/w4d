// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module w4d.widget.base;
import w4d.element.box,
       w4d.layout.base,
       w4d.layout.fill,
       w4d.style.widget,
       w4d.task.window,
       w4d.exception;
import g4d.math.vector;
import std.algorithm;

class Widget : WindowContent
{
    protected WidgetStyle   _style;
    protected Layout        _layout;
    protected BoxElement    _box;
    protected WindowContext _context;

    @property style () { return _style; }
    @property Widget[] children () { return []; }

    protected Widget findChildAt ( vec2 pt )
    {
        foreach ( c; children ) {
            if ( c.style.isPointInside(pt) ) {
                return c;
            }
        }
        return null;
    }

    override bool handleMouseEnter ( bool entered, vec2 pos )
    {
        //throw new W4dException( "NotImplemented" );
        return true;
    }
    override bool handleMouseMove ( vec2 pos )
    {
        if ( _context.tracked && _context.tracked !is this ) {
            return _context.tracked.handleMouseMove( pos );
        } else if ( auto target = findChildAt(pos) ) {
            return target.handleMouseMove( pos );
        } else {
            return true;
        }
    }
    override bool handleMouseButton ( MouseButton btn, bool status, vec2 pos )
    {
        if ( _context.tracked && _context.tracked !is this ) {
            return _context.tracked.handleMouseButton( btn, status, pos );
        } else if ( auto target = findChildAt(pos) ) {
            return target.handleMouseButton( btn, status, pos );
        } else {
            return true;
        }
    }
    override bool handleMouseScroll ( vec2 amount, vec2 pos )
    {
        if ( _context.tracked && _context.tracked !is this ) {
            return _context.tracked.handleMouseScroll( amount, pos );
        } else if ( auto target = findChildAt(pos) ) {
            return target.handleMouseScroll( amount, pos );
        } else {
            return true;
        }
    }

    override bool handleKey ( Key key, KeyState status )
    {
        return false;
    }
    override bool handleTextInput ( dchar c )
    {
        return false;
    }

    this ()
    {
        _style = new WidgetStyle;

        setLayout!FillLayout();
    }

    void setLayout (L) ()
    {
        _layout = new L(style);
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
    }

    override void draw ( Window win )
    {
        auto shader = win.shaders.fill3;

        shader.use();
        shader.setVectors( vec3(_style.translate,0) );
        _box.draw( shader );

        children.each!(x => x.draw(win));
    }
}

class WindowContext
{
    Widget tracked;
    Widget focused;

    this ()
    {
        tracked = null;
        focused = null;
    }
}
