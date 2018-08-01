// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module w4d.widget.list;
import w4d.parser.theme,
       w4d.style.rect,
       w4d.style.scalar,
       w4d.style.widget,
       w4d.task.window,
       w4d.widget.base,
       w4d.widget.panel,
       w4d.widget.scroll,
       w4d.widget.text,
       w4d.event,
       w4d.exception;
import g4d.math.vector;
import std.algorithm,
       std.array,
       std.conv;

alias SelectChangeHandler = EventHandler!( void, ListItemWidget[] );

class ListWidget : VerticalScrollPanelWidget
{
    protected class CustomPanelWidget :
        typeof(super).CustomPanelWidget
    {
        protected Widget _dragging;

        override bool handleMouseMove ( vec2 pos )
        {
            if ( super.handleMouseMove( pos ) ) return true;

            if ( editable && isTracked && _dragging ) {
                if ( auto child = findChildAt(pos) ) {
                    swapChild( child, _dragging );
                    return true;
                }
            }
            return false;
        }
        override bool handleMouseButton ( MouseButton btn, bool status, vec2 pos )
        {
            if ( super.handleMouseButton( btn, status, pos ) ) return true;

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
            _dragging = null;
        }
        override @property bool trackable () { return true; }
    }

    protected override typeof(super).CustomPanelWidget createCustomPanel ()
    {
        return new CustomPanelWidget;
    }
    override @property typeof(super).CustomPanelWidget contents ()
    {
        throw new W4dException( "Modifying contents is not allowed." );
    }

    protected bool _multiselect;
    const @property multiselectable () { return _multiselect; }

    protected bool _editable;
    @property ref editable () { return _editable; }

    SelectChangeHandler onSelectChange;

    @property ListItemWidget[] childItems ()
    {
        return super.contents.children.to!(ListItemWidget[]);
    }
    @property ListItemWidget[] selectedItems ()
    {
        return childItems.filter!"a.isSelected".array;
    }

    this ()
    {
        super();

        _multiselect = false;
        _editable    = false;
    }

    void setMultiselectable ( bool b )
    {
        deselect();
        _multiselect = b;
    }

    void addItem ( ListItemWidget w )
    {
        enforce( w, "Null is invalid." );
        w.setParentList( this );
        super.contents.addChild( w );
    }
    void removeItem ( ListItemWidget w )
    {
        enforce( w, "Null is invalid." );
        super.contents.removeChild( w );
    }

    void deselect ()
    {
        foreach ( i; childItems ) {
            unselectItem( i );
        }
    }
    void selectAll ()
    {
        foreach ( i; childItems ) {
            selectItem( i );
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
    protected ListWidget _parentList;

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

    void setParentList ( ListWidget w )
    {
        enforce( w, "Null is invalid." );
        enforce( !_parentList, "Parent is already defined." );

        _parentList = w;
    }
}
