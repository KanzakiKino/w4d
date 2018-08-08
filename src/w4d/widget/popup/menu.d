// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module w4d.widget.popup.menu;
import w4d.layout.lineup,
       w4d.parser.theme,
       w4d.style.rect,
       w4d.style.scalar,
       w4d.task.window,
       w4d.widget.popup.base,
       w4d.widget.wrapper,
       w4d.event;
import g4d.ft.font,
       g4d.math.vector;

class PopupMenuWidget : PopupWidget
{
    override bool handleMouseButton ( MouseButton b, bool status, vec2 pos )
    {
        if ( super.handleMouseButton(b,status,pos) ) return true;

        if ( status && !style.isPointInside( pos ) ) {
            close();
            return true;
        }
        return false;
    }

    this ()
    {
        super();
        setLayout!VerticalLineupLayout;

        style.box.borderWidth = Rect(1.pixel);
    }
    mixin DisableModifyChildren;

    void addItem ( MenuItemWidget i )
    {
        i._parentMenu = this;
        super.addChild( i );
    }
    void removeItem ( MenuItemWidget i )
    {
        super.removeChild( i );
    }
    void removeAllItems ()
    {
        super.removeAllChildren();
    }
}

alias PressHandler = EventHandler!( bool );

class MenuItemWidget : WrapperWidget
{
    protected PopupMenuWidget _parentMenu;

    PressHandler onPress;

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

    this ()
    {
        super();
        setLayout!HorizontalLineupLayout;

        _parentMenu = null;

        style.box.paddings = Rect(1.mm);
    }
}
