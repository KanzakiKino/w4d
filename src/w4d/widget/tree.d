// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module w4d.widget.tree;
import w4d.layout.lineup,
       w4d.style.scalar,
       w4d.task.window,
       w4d.widget.base,
       w4d.widget.list,
       w4d.widget.panel;
import g4d.math.vector;

class TreeListItemWidget : ListItemWidget
{
    protected class ContentsWidget : PanelWidget
    {
        override bool handleMouseButton ( MouseButton btn, bool status, vec2 pos )
        {
            if ( super.handleMouseButton(btn,status,pos) ) return true;

            if ( btn == MouseButton.Right && status ) {
                (_opened? &close: &open)();
                return true;
            }
            return false;
        }
        this ()
        {
            super();
            style.box.size.width = Scalar.Auto;
        }
    }
    protected class TreeListWidget : ListWidget
    {
        override void selectItem ( ListItemWidget w )
        {
            _parent.selectItem( w );
        }
        override void unselectItem ( ListItemWidget w )
        {
            _parent.unselectItem( w );
        }
        this ()
        {
            super();
            style.box.paddings.left = 5.mm;
        }
    }
    protected class CustomPanelWidget : PanelWidget
    {
        override @property Widget[] children ()
        {
            if ( _opened ) {
                return [_contents, _childList];
            } else {
                return [_contents];
            }
        }
        this ()
        {
            super();
        }
    }

    protected ListWidget _parent;
    protected bool       _opened;

    @property opened () { return _opened; }

    protected ContentsWidget _contents;
    protected TreeListWidget _childList;

    @property contents () { return _contents; }
    @property list     () { return _childList; }

    this ()
    {
        super();

        _parent = null;
        _opened = false;

        _contents  = new ContentsWidget;
        _childList = new TreeListWidget;

        super.setChild( new CustomPanelWidget );

        setLayout!VerticalLineupLayout;
    }
    mixin DisableModifyChild;

    override @property ListItemWidget[] selectedItems ()
    {
        return list.selectedItems;
    }

    override void setParent ( ListWidget w )
    {
        _parent = w;
    }
    override void deselect ()
    {
        return list.deselect();
    }

    void open ()
    {
        _opened = true;
        requestLayout();
    }
    void close ()
    {
        _opened = false;
        requestLayout();
    }
}
