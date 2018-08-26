// Written in the D programming language.
/++
 + Authors: KanzakiKino
 + Copyright: KanzakiKino 2018
 + License: LGPL-3.0
++/
module w4d.widget.list;
import w4d.layout.placer.lineup,
       w4d.layout.fill,
       w4d.parser.colorset,
       w4d.style.rect,
       w4d.style.scalar,
       w4d.style.widget,
       w4d.task.window,
       w4d.widget.base,
       w4d.widget.wrapper,
       w4d.event,
       w4d.exception;
import gl3n.linalg;
import std.algorithm,
       std.array,
       std.conv;

/// A handler that handles changing selection.
alias SelectChangeHandler = EventHandler!( void, ListItemWidget[] );

/// A widget of list.
class ListWidget : Widget
{
    protected ListItemWidget[] _items;
    /// Child items.
    @property items () { return _items; }

    /// All selected child items.
    @property selectedItems ()
    {
        ListItemWidget[] result;
        foreach ( item; items ) {
            if ( item.status.selected ) {
                result ~= item;
            }
            result ~= item.selectedItems;
        }
        return result;
    }
    ///
    override @property Widget[] children ()
    {
        return items.to!( Widget[] );
    }

    protected bool _multiselect;
    /// Whether the list widget is multi-selectable.
    @property multiselectable () { return _multiselect; }

    protected Widget _dragging;

    ///
    SelectChangeHandler onSelectChange;

    ///
    override bool handleMouseButton ( MouseButton btn, bool status, vec2 pos )
    {
        if ( super.handleMouseButton(btn,status,pos) ) return true;

        if ( btn == MouseButton.Left && status ) {
            if ( auto child = findChildAt( pos ) ) {
                _dragging = child;

                toggleItem( child.to!ListItemWidget );
                return true;
            }
        } else if ( btn == MouseButton.Left && !status ) {
            _dragging = null;
        }
        return false;
    }

    ///
    this ()
    {
        super();
        parseColorSetsFromFile!"colorset/list.yaml"( style );
        setLayout!( FillLayout, VerticalLineupPlacer );

        _multiselect = false;
    }

    /// Changes multi-selectable.
    void setMultiselectable ( bool b )
    {
        deselect();
        _multiselect = b;
    }

    /// Adds an item.
    void addItem ( ListItemWidget w )
    {
        enforce( w, "Null is invalid." );
        _items ~= w;
        w.setParent( this );
    }
    /// Removes an item.
    void removeItem ( ListItemWidget w )
    {
        _items = _items.remove!( x => x is w );
    }
    /// Removes all items.
    void removeAllItems ()
    {
        _items = [];
    }

    /// Unselects all items.
    void deselect ()
    {
        foreach ( i; items ) {
            unselectItem( i );
            i.deselect();
        }
    }

    /// Selects the item.
    void selectItem ( ListItemWidget w )
    {
        if ( w.status.selected ) return;
        if ( !multiselectable ) deselect();

        w.status.selected = true;
        onSelectChange.call( selectedItems );
    }
    /// Unselects the item.
    void unselectItem ( ListItemWidget w )
    {
        if ( !w.status.selected ) return;

        w.status.selected = false;
        onSelectChange.call( selectedItems );
    }
    /// Toggles selected state of the item.
    void toggleItem ( ListItemWidget w )
    {
        if ( w.status.selected ) {
            unselectItem( w );
        } else {
            selectItem( w );
        }
    }

    ///
    override @property bool trackable () { return false; }
    ///
    override @property bool focusable () { return true; }
}

/// A widget of list item.
class ListItemWidget : WrapperWidget
{
    ///
    this ()
    {
        super();

        parseColorSetsFromFile!"colorset/listitem.yaml"( style );
        style.box.size.width = Scalar.Auto;
        style.box.paddings   = Rect( 1.mm );
    }

    /// Selected child items. (for tree item widget).
    @property ListItemWidget[] selectedItems ()
    {
        return [];
    }

    /// Changes the parent list widget.
    void setParent ( ListWidget ) { }
    /// Unselects all child items. (for tree item widget).
    void deselect () { }

    ///
    override @property bool trackable () { return false; }
    ///
    override @property bool focusable () { return false; }
}
