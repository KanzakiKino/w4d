// Written without LICENSE in the D programming language.
// Copyright 2018 KanzakiKino
import w4d;
import std.conv;

class TestRootWidget : RootWidget
{
    protected PopupTooltipWidget _tooltip;
    protected MenuPopupWidget    _menu;

    override bool handleMouseButton ( MouseButton btn, bool status, vec2 pos )
    {
        if ( super.handleMouseButton(btn,status,pos) ) return true;

        if ( btn == MouseButton.Middle && status ) {
            _context.setPopup( _tooltip );
            _tooltip.move( pos+vec2(0,20) );
            requestRedraw();
            return true;

        } else if ( btn == MouseButton.Right && status ) {
            _context.setPopup( _menu );
            _menu.move( pos, vec2(200,0) );
            requestRedraw();
            return true;
        }
        return false;
    }

    this ()
    {
        super();
        setLayout!VerticalLineupLayout;
        style.getColorSet(0).bgColor = vec4(0.1,0.1,0.1,1);

        auto fontface = new FontFace(new Font("/usr/share/fonts/TTF/Ricty-Regular.ttf"), vec2i(16,16));

        _tooltip = new PopupTooltipWidget;
        _tooltip.loadText( "Right click to open tree."d, fontface );

        auto dialog = new PopupTextDialogWidget;
        dialog.loadText( "Hello, World"d, fontface );
        dialog.setButtons( [DialogButton.Ok] );
        _context.setPopup( dialog );

        _menu = new MenuPopupWidget;
        foreach ( i; 0..5 ) {
            auto item1 = new MenuItemWidget;
            item1.loadText( "menuitem"d, fontface );
            item1.onPress = () {
                return true;
            };
            _menu.addItem( item1 );
        }

        auto scroll1 = new VerticalScrollPanelWidget;
        addChild( scroll1 );

        auto list1 = new ListWidget;
//        list1.setMultiselectable( true );
        scroll1.contents.addChild( list1 );

        foreach ( i; 0..20 ) {
            auto widget1 = new TreeListItemWidget(i);

            auto text1 = new TextWidget;
            text1.loadText( i.to!dstring~"deep1"d, fontface );
            widget1.contents.addChild( text1 );

            foreach ( j; 0..5 ) {
                auto widget2 = new ListItemWidget(j);

                auto text2 = new TextWidget;
                text2.loadText( j.to!dstring~"deep2"d, fontface );
                widget2.addChild( text2 );

                widget1.list.addItem( widget2 );
            }

            list1.addItem( widget1 );
        }
    }
}

int main ( string[] args )
{
    auto app = new App( args );

    auto win = new Window( vec2i(640,480), "TEST", WindowHint.Resizable );
    win.setContent( new TestRootWidget );
    app.addTask( win );

    win.show();
    return app.exec();
}
