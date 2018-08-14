// Written in the D programming language.
/++
 + Authors: KanzakiKino
 + Copyright: KanzakiKino 2018
 + License: LGPL-3.0
++/
module w4d.widget.tree;
import w4d.layout.lineup,
       w4d.style.scalar,
       w4d.task.window,
       w4d.widget.base,
       w4d.widget.list,
       w4d.widget.panel;
import gl3n.linalg;

/// A widget of tree list item.
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

        override @property bool trackable () { return false; }
        override @property bool focusable () { return false; }
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

    /// Whether the tree item is expanded.
    @property opened () { return _opened; }

    protected ContentsWidget _contents;
    protected TreeListWidget _childList;

    /// Contents panel of the tree item.
    @property contents () { return _contents; }
    /// Children list of the tree item.
    @property list () { return _childList; }

    ///
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

    ///
    override @property ListItemWidget[] selectedItems ()
    {
        return list.selectedItems;
    }

    ///
    override void setParent ( ListWidget w )
    {
        _parent = w;
    }
    ///
    override void deselect ()
    {
        return list.deselect();
    }

    /// Expands and reveals the children list.
    void open ()
    {
        _opened = true;
        requestLayout();
    }
    /// Closes and hides the children list.
    void close ()
    {
        _opened = false;
        requestLayout();
    }
}
