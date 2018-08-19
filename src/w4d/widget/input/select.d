// Written in the D programming language.
/++
 + Authors: KanzakiKino
 + Copyright: KanzakiKino 2018
 + License: LGPL-3.0
++/
module w4d.widget.input.select;
import w4d.parser.colorset,
       w4d.style.rect,
       w4d.style.scalar,
       w4d.task.window,
       w4d.widget.popup.menu,
       w4d.widget.base,
       w4d.widget.panel,
       w4d.event,
       w4d.exception;
import g4d.glfw.cursor;
import gl3n.linalg;

/// A handler that handles changing selection.
alias SelectChanged = EventHandler!( void, int );

/// A widget of select input.
class SelectInputWidget : PanelWidget
{
    protected class CustomPopupMenuWidget : PopupMenuWidget
    {
        this ()
        {
            super();
        }
    }

    protected CustomPopupMenuWidget _menu;
    protected Widget                _selected;

    ///
    override @property Widget[] children ()
    {
        return _selected? [_selected]: [];
    }

    ///
    override bool handleMouseButton ( MouseButton btn, bool status, vec2 pos )
    {
        if ( super.handleMouseButton(btn,status,pos) ) return true;

        if ( !style.isPointInside( pos ) ) return false;
        if ( btn == MouseButton.Left && !status ) {
            openMenu();
            return true;
        }
        return false;
    }

    ///
    override @property const(Cursor) cursor ()
    {
        return Cursor.Hand;
    }

    ///
    this ()
    {
        super();
        _menu     = new CustomPopupMenuWidget;
        _selected = null;

        parseColorSetsFromFile!"colorset/selectinput.yaml"( style );
        style.box.borderWidth = Rect(1.pixel);
        style.box.paddings    = Rect(1.mm);
        style.box.margins     = Rect(1.mm);
    }

    /// Changes selection.
    void select ( MenuItemWidget s )
    {
        _selected = s.child;
        requestLayout();
    }
    /// Opens select menu.
    void openMenu ()
    {
        enforce( _context, "WindowContext is null." );

        auto size = style.box.borderInsideSize;
        auto late = style.box.borderInsideLeftTop;
        late.y   += size.y;
        late     += style.translate;

        _context.setPopup( _menu );
        _menu.move( late, vec2( size.x, 0 ) );
    }

    /// Adds an itme.
    void addItem ( MenuItemWidget i )
    {
        i.onPress = () {
            select( i );
            return true;
        };
        _menu.addItem( i );
    }
    /// Removes an item.
    void removeItem ( MenuItemWidget i )
    {
        _menu.removeItem( i );
    }
    /// Removes all items.
    void removeAllItems ()
    {
        _menu.removeAllItems();
    }

    ///
    override @property bool trackable () { return true; }
    ///
    override @property bool focusable () { return true; }
}
