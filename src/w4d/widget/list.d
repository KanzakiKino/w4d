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
       w4d.exception;
import g4d.math.vector;
import std.algorithm;

class ListWidget : VerticalScrollPanelWidget
{
    protected class CustomPanelWidget : // FIXME: dirty codes.
        typeof(super).CustomPanelWidget
    {
        protected Widget _draggingItem;

        override bool handleMouseMove ( vec2 pos )
        {
            if ( swapOrder && isTracked && _draggingItem ) {
                if ( auto child = findChildAt( pos ) ) {
                    swapChild( _draggingItem, child );
                }
            }
            return false;
        }
        override bool handleMouseButton ( MouseButton btn, bool status, vec2 pos )
        {
            if ( btn == MouseButton.Left && status ) {
                if ( auto child = findChildAt( pos ) ) {
                    _draggingItem = child;
                    toggleItem( retrieveIdFromWidget( child ) );
                    track();
                    return true;
                }
            } else if ( btn == MouseButton.Left && !status ) {
                _draggingItem = null;
                refuseTrack();
            }
            return false;
        }
        this ()
        {
            super();
            _draggingItem = null;
        }
        override void track ()
        {
            enforce( _context, "WindowContext is null." );
            _context.setTracked( this );
        }
    }

    protected override typeof(super).CustomPanelWidget createCustomPanel ()
    {
        return new CustomPanelWidget;
    }

    protected Widget[int] _idMap;
    const @property idMap () { return _idMap; }

    protected int[] _selected;
    const @property selected () { return _selected; }

    protected bool _multiselect;
    const @property multiselectable () { return _multiselect; }

    protected bool _swapOrder;
    const @property swapOrder () { return _swapOrder; }

    this ()
    {
        super();
        _idMap.clear();
        _selected = [];

        _multiselect = false;
        _swapOrder   = false;
    }

    void setMultiselectable ( bool b )
    {
        if ( !b && _selected.length ) {
            _selected.length = 1;
        }
        _multiselect = b;
    }
    void setSwapOrder ( bool b )
    {
        _swapOrder = b;
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
        contents.addChild( w );
    }
    void removeItem ( int id )
    {
        enforce( id in _idMap, "Id is unknown." );
        auto w = _idMap[id];
        removeChild( w );
    }

    void deselect ()
    {
        auto copy = _selected.dup;
        foreach ( id; copy ) {
            unselectItem( id );
        }
    }
    void selectAll ()
    {
        if ( multiselectable ) {
            _selected = _idMap.keys;
        }
    }

    const bool isSelected ( int id )
    {
        return _selected.canFind!"a==b"( id );
    }
    void selectItem ( int id )
    {
        enforce( id in _idMap, "Id is unknown." );
        if ( isSelected( id ) ) return;

        auto w = _idMap[id];
        w.enableState( WidgetState.Selected );

        if ( multiselectable ) {
            _selected ~= id;
        } else {
            deselect();
            _selected = [id];
        }
    }
    void unselectItem ( int id )
    {
        enforce( id in _idMap, "Id is unknown." );
        if ( !isSelected( id ) ) return;

        auto w = _idMap[id];
        w.disableState( WidgetState.Selected );

        if ( multiselectable ) {
            _selected = _selected.remove!( x => x==id );

        } else if ( _selected.length ) {
            _selected = [];
        }
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
