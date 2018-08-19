// Written in the D programming language.
/++
 + Authors: KanzakiKino
 + Copyright: KanzakiKino 2018
 + License: LGPL-3.0
++/
module w4d.widget.popup.menu;
import w4d.layout.placer.lineup,
       w4d.layout.fill,
       w4d.parser.colorset,
       w4d.style.rect,
       w4d.style.scalar,
       w4d.task.window,
       w4d.widget.popup.base,
       w4d.widget.wrapper,
       w4d.event;
import g4d.ft.font;
import gl3n.linalg;

/// A widget of popup menu.
class PopupMenuWidget : PopupWidget
{
    ///
    override bool handleMouseButton ( MouseButton b, bool status, vec2 pos )
    {
        if ( super.handleMouseButton(b,status,pos) ) return true;

        if ( status && !style.isPointInside( pos ) ) {
            close();
            return true;
        }
        return false;
    }

    ///
    this ()
    {
        super();

        parseColorSetsFromFile!"colorset/menu.yaml"( style );
        setLayout!( FillLayout, VerticalLineupPlacer );
        style.box.borderWidth = Rect(1.pixel);
    }
    mixin DisableModifyChildren;

    /// Adds the item.
    void addItem ( MenuItemWidget i )
    {
        i._parentMenu = this;
        super.addChild( i );
    }
    /// Removes the item.
    void removeItem ( MenuItemWidget i )
    {
        super.removeChild( i );
    }
    /// Removes all items.
    void removeAllItems ()
    {
        super.removeAllChildren();
    }
}

/// A handler that handles pressing menu items.
alias PressHandler = EventHandler!( bool );

/// A widget of menu item.
class MenuItemWidget : WrapperWidget
{
    protected PopupMenuWidget _parentMenu;

    ///
    PressHandler onPress;

    ///
    override bool handleMouseButton ( MouseButton btn, bool status, vec2 pos )
    {
        if ( super.handleMouseButton(btn,status,pos) ) return true;

        if ( !style.isPointInside( pos ) ) return false;
        if ( btn == MouseButton.Left && !status ) {
            if ( onPress.call() ) {
                _parentMenu.close();
            }
            return true;
        }
        return false;
    }

    ///
    this ()
    {
        super();

        _parentMenu = null;

        parseColorSetsFromFile!"colorset/menuitem.yaml"( style );
        setLayout!( FillLayout, HorizontalLineupPlacer );
        style.box.paddings = Rect(1.mm);
    }
}
