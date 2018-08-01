// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module w4d.widget.list;
import w4d.layout.lineup,
       w4d.parser.theme,
       w4d.style.rect,
       w4d.style.scalar,
       w4d.style.widget,
       w4d.task.window,
       w4d.widget.base,
       w4d.widget.panel,
       w4d.event,
       w4d.exception;
import g4d.math.vector;
import std.algorithm,
       std.array,
       std.conv;

alias SelectChangeHandler = EventHandler!( void, ListItemWidget[] );

class ListWidget : Widget
{
    protected ListItemWidget[] _items;
    @property items () { return _items; }

    @property selectedItems ()
    {
        ListItemWidget[] result;
        foreach ( item; items ) {
            if ( item.isSelected ) {
                result ~= item;
            }
            result ~= item.selectedItems;
        }
        return result;
    }
    override @property Widget[] children ()
    {
        return items.to!( Widget[] );
    }

    protected bool _multiselect;
    const @property multiselectable () { return _multiselect; }

    protected Widget _dragging;

    SelectChangeHandler onSelectChange;

    override bool handleMouseButton ( MouseButton btn, bool status, vec2 pos )
    {
        if ( super.handleMouseButton(btn,status,pos) ) return true;

        if ( btn == MouseButton.Left && status ) {
            if ( auto child = findChildAt( pos ) ) {
                _dragging = child;
                _dragging.enableState( WidgetState.Pressed );

                toggleItem( child.to!ListItemWidget );
                return true;
            }
        } else if ( btn == MouseButton.Left && !status ) {
            if ( _dragging ) {
                _dragging.disableState( WidgetState.Pressed );
                _dragging = null;
            }
        }
        return false;
    }

    this ()
    {
        super();
        setLayout!VerticalLineupLayout;

        _multiselect = false;
    }

    void setMultiselectable ( bool b )
    {
        deselect();
        _multiselect = b;
    }

    void addItem ( ListItemWidget w )
    {
        enforce( w, "Null is invalid." );
        _items ~= w;
        w.setParent( this );
    }
    void removeItem ( ListItemWidget w )
    {
        _items = _items.remove!( x => x is w );
    }

    void deselect ()
    {
        foreach ( i; items ) {
            unselectItem( i );
            i.deselect();
        }
    }

    void selectItem ( ListItemWidget w )
    {
        if ( w.isSelected ) return;
        if ( !multiselectable ) deselect();

        w.enableState( WidgetState.Selected );
        onSelectChange.call( selectedItems );
    }
    void unselectItem ( ListItemWidget w )
    {
        if ( !w.isSelected ) return;

        w.disableState( WidgetState.Selected );
        onSelectChange.call( selectedItems );
    }
    void toggleItem ( ListItemWidget w )
    {
        if ( w.isSelected ) {
            unselectItem( w );
        } else {
            selectItem( w );
        }
    }
}

class ListItemWidget : PanelWidget
{
    protected int _id;
    const @property id () { return _id; }

    protected string _idStr;
    const @property idStr () { return _idStr; }

    this ( int id, string idStr = "" )
    {
        super();
        _id    = id;
        _idStr = idStr;

        parseThemeFromFile!"theme/listitem.yaml"( style );

        style.box.size.width = Scalar.Auto;
        style.box.paddings   = Rect( 1.mm );
    }

    @property bool isSelected ()
    {
        return !!(status & WidgetState.Selected);
    }
    @property ListItemWidget[] selectedItems ()
    {
        return [];
    }

    void setParent ( ListWidget ) { }
    void deselect  ()             { }
}
