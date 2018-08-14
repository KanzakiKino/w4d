// Written in the D programming language.
/++
 + Authors: KanzakiKino
 + Copyright: KanzakiKino 2018
 + License: LGPL-3.0
++/
module w4d.widget.panel;
import w4d.layout.lineup,
       w4d.widget.base,
       w4d.exception;
import gl3n.linalg;
import std.algorithm;

/// A widget of panel.
/// PanelWidget can have children.
class PanelWidget : Widget
{
    protected Widget[] _children;
    ///
    override @property Widget[] children ()
    {
        return _children.dup;
    }

    ///
    this ()
    {
        super();
        setLayout!VerticalLineupLayout;
    }

    /// Adds the child.
    Widget addChild ( Widget child )
    {
        enforce( child, "Append child is null." );
        _children ~= child;
        requestLayout();
        return child;
    }
    /// Swaps the children.
    void swapChild ( Widget c1, Widget c2 )
    {
        auto i1 = _children.countUntil!"a is b"(c1);
        auto i2 = _children.countUntil!"a is b"(c2);
        enforce( i1 >= 0 && i2 >= 0, "The children are unknown." );
        _children.swapAt( i1, i2 );
        requestLayout();
    }
    /// Removes all children.
    void removeAllChildren ()
    {
        _children.each!( x => _context.forget(x) );
        _children = [];
        requestLayout();
    }
    /// Removes the child.
    void removeChild ( Widget child )
    {
        _context.forget( child );
        _children = _children.remove!( x => x is child );
        requestLayout();
    }

    protected static template DisableModifyChildren ()
    {
        import w4d.widget.base: Widget;
        import w4d.exception: W4dException;

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

    ///
    override @property bool trackable () { return false; }
    ///
    override @property bool focusable () { return false; }
}
