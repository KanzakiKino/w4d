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
    void removeAllChildren ()
    {
        _children.each!( x => _context.forget(x) );
        _children = [];
        requestLayout();
    }
    void removeChild ( Widget child )
    {
        _context.forget( child );
        _children = _children.remove!( x => x is child );
        requestLayout();
    }

    protected static template DisableModifyChildren ()
    {
        import w4d.widget.base,
               w4d.exception;

        enum DisableModifyChildren_ErrorMes = "Modifying children is not allowed.";

        override Widget addChild ( Widget )
        {
            throw new W4dException( DisableModifyChildren_ErrorMes );
        }
        override void swapChild ( Widget, Widget )
        {
            throw new W4dException( DisableModifyChildren_ErrorMes );
        }
        override void removeChild ( Widget )
        {
            throw new W4dException( DisableModifyChildren_ErrorMes );
        }
        override void removeAllChildren ()
        {
            throw new W4dException( DisableModifyChildren_ErrorMes );
        }
    }

    override @property bool trackable () { return false; }
    override @property bool focusable () { return false; }
}
