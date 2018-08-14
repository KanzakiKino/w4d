// Written in the D programming language.
/++
 + Authors: KanzakiKino
 + Copyright: KanzakiKino 2018
 + License: LGPL-3.0
++/
module w4d.widget.wrapper;
import w4d.layout.lineup,
       w4d.widget.base,
       w4d.exception;
import std.conv;

/// A widget that wraps other wraps.
class WrapperWidget : Widget
{
    protected Widget _child;

    ///
    override @property Widget[] children ()
    {
        return _child? [_child]: [];
    }
    /// Child widget that is wrapped.
    @property T child (T = Widget) ()
    {
        return _child.to!T;
    }

    ///
    this ()
    {
        super();
        setLayout!VerticalLineupLayout;

        _child = null;
    }

    /// Changes the child widget.
    Widget setChild ( Widget child )
    {
        enforce( child, "Null is not a valid child." );
        _child = child;
        requestLayout();
        return child;
    }
    /// Removes the child widget.
    void removeChild ()
    {
        _context.forget( _child );
        _child = null;
        requestLayout();
    }

    protected static template DisableModifyChild ()
    {
        import w4d.widget.base,
               w4d.exception;

        enum DisableModifyChild_ErrorMes = "Modifying a child is not allowed.";

        override Widget setChild ( Widget child )
        {
            throw new W4dException( DisableModifyChild_ErrorMes );
        }
        override void removeChild ()
        {
            throw new W4dException( DisableModifyChild_ErrorMes );
        }
    }

    ///
    override @property bool trackable () { return false; }
    ///
    override @property bool focusable () { return false; }
}
