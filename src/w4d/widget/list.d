// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module w4d.widget.list;
import w4d.parser.theme,
       w4d.style.rect,
       w4d.style.scalar,
       w4d.style.widget,
       w4d.task.window,
       w4d.widget.base,
       w4d.widget.scroll,
       w4d.widget.text,
       w4d.event,
       w4d.exception;
import g4d.math.vector;
import std.algorithm;

alias SelectChangeHandler = EventHandler!( void, int[] );

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

                    toggleItem( retrieveIdFromWidget( child ) );
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

    protected Widget[int] _idMap;
    const @property idMap () { return _idMap; }

    protected bool _multiselect;
    const @property multiselectable () { return _multiselect; }

    protected bool _editable;
    @property ref editable () { return _editable; }

    SelectChangeHandler onSelectChange;

    this ()
    {
        super();
        _idMap.clear();

        _multiselect = false;
        _editable    = false;
    }

    void setMultiselectable ( bool b )
    {
        deselect();
        _multiselect = b;
    }

    protected int retrieveIdFromWidget ( Widget w )
    {
        auto index = _idMap.values.countUntil!"a is b"( w );
        enforce( index >= 0, "The widget is unknown." );
        return _idMap.keys[index];
    }

    void addItem ( int id, Widget w )
    {
        enforce( id !in _idMap, "Id is already used." );
        _idMap[id] = w;
        super.contents.addChild( w );
    }
    void removeItem ( int id )
    {
        enforce( id in _idMap, "Id is unknown." );
        auto w = _idMap[id];
        super.contents.removeChild( w );
    }

    void deselect ()
    {
        foreach ( id; _idMap.keys ) {
            unselectItem( id );
        }
    }
    void selectAll ()
    {
        foreach ( id; _idMap.keys ) {
            selectItem( id );
        }
    }

    bool isSelected ( int id )
    {
        enforce( id in _idMap, "Id is unknown." );
        return isSelected( _idMap[id] );
    }
    bool isSelected ( Widget w )
    {
        return !!(w.status & WidgetState.Selected);
    }
    void selectItem ( int id )
    {
        if ( isSelected( id ) ) return;
        if ( !multiselectable ) deselect();

        auto w = _idMap[id];
        w.enableState( WidgetState.Selected );
        onSelectChange.call( retrieveSelectedIds() );
    }
    void unselectItem ( int id )
    {
        if ( !isSelected( id ) ) return;
        auto w = _idMap[id];
        w.disableState( WidgetState.Selected );
        onSelectChange.call( retrieveSelectedIds() );
    }
    void toggleItem ( int id )
    {
        enforce( id in _idMap, "Id is unknown." );

        if ( isSelected( id ) ) {
            unselectItem( id );
        } else {
            selectItem( id );
        }
    }

    int[] retrieveSelectedIds ()
    {
        int[] result;
        foreach ( w; super.contents.children ) {
            if ( isSelected( w ) ) {
                result ~= retrieveIdFromWidget( w );
            }
        }
        return result;
    }
}

class ListTextItemWidget : TextWidget
{
    this ()
    {
        super();
        parseThemeFromFile!"theme/listitem.yaml"( style );

        style.box.paddings = Rect( 1.mm );
    }
    override void adjustSize ()
    {
        super.adjustSize();
        style.box.size.width = Scalar(0); // none
    }
}

class ListPanelItemWidget : TextWidget
{
    this ()
    {
        super();
        parseThemeFromFile!"theme/listitem.yaml"( style );

        style.box.paddings = Rect( 1.mm );
    }
}
