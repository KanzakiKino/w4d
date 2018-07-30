// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module w4d.widget.panel;
import w4d.layout.lineup,
       w4d.widget.base,
       w4d.exception;
import g4d.math.vector;
import std.algorithm;

class PanelWidget : Widget
{
    protected static template DisableModifyChildren ()
    {
        import w4d.widget.base,
               w4d.exception;
        override Widget addChild ( Widget )
        {
            throw new W4dException( "Modifying children is not allowed." );
        }
    }

    protected Widget[] _children;
    override @property Widget[] children ()
    {
        return _children.dup;
    }

    this ()
    {
        super();
        setLayout!VerticalLineupLayout;
    }

    Widget addChild ( Widget child )
    {
        enforce( child, "Append child is null." );
        _children ~= child;
        requestRedraw();
        return child;
    }
    void swapChild ( Widget c1, Widget c2 )
    {
        auto i1 = _children.countUntil!"a is b"(c1);
        auto i2 = _children.countUntil!"a is b"(c2);
        enforce( i1 >= 0 && i2 >= 0, "The children are unknown." );
        _children.swapAt( i1, i2 );
        requestRedraw();
    }
    void removeChild ( Widget child )
    {
        if ( _context.tracked is child ) {
            _context.setTracked( null );
        }
        if ( _context.focused is child ) {
            _context.setFocused( null );
        }
        if ( _hovered is child ) {
            _hovered = null;
        }
        _children = _children.remove!( x => x is child );
        requestRedraw();
    }

    override void track ()
    {
        // PanelWidget can't be tracked.
    }
    override void focus ()
    {
        // PanelWidget can't be focused.
    }
}
