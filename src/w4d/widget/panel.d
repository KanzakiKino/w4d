// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module w4d.widget.panel;
import w4d.layout.lineup,
       w4d.widget.base,
       w4d.exception;
import g4d.math.vector;

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
        setLayout!VerticalLayout;
    }

    Widget addChild ( Widget child )
    {
        enforce( child, "Append child is null." );
        _children ~= child;
        return child;
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
