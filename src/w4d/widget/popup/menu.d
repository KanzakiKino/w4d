// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module w4d.widget.popup.menu;
import w4d.layout.lineup,
       w4d.parser.theme,
       w4d.style.rect,
       w4d.style.scalar,
       w4d.task.window,
       w4d.widget.popup.base,
       w4d.widget.panel,
       w4d.widget.text,
       w4d.event;
import g4d.ft.font,
       g4d.math.vector;

class MenuPopupWidget : PopupWidget
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

        parseThemeFromFile!"theme/tooltip.yaml"( style );
        style.box.borderWidth = Rect(1.pixel);
    }

    void addItem ( MenuItemWidget i )
    {
        i._parentMenu = this;
        addChild( i );
    }
}

alias PressHandler = EventHandler!( bool );

class MenuItemWidget : PanelWidget
{
    protected MenuPopupWidget _parentMenu;
    protected TextWidget      _text;

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

        _text = new TextWidget;
        addChild( _text );

        parseThemeFromFile!"theme/menuitem.yaml"( style );
        style.box.paddings = Rect(1.mm);
    }

    void loadText ( dstring v, FontFace face = null )
    {
        _text.loadText( v, face );
    }
}
