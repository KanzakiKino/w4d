// Written without LICENSE in the D programming language.
// Copyright 2018 KanzakiKino
import w4d;
import std.conv;

class TestRootWidget : RootWidget
{
    protected PopupTooltipWidget _tooltip;
    protected PopupMenuWidget    _menu;

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

        _menu = new PopupMenuWidget;
        foreach ( i; 0..5 ) {
            auto item1 = new MenuItemWidget;
            item1.onPress = () {
                return true;
            };
            auto text1 = new TextWidget;
            text1.loadText( "menuitem"d, fontface );
            item1.setChild( text1 );
            _menu.addItem( item1 );
        }

        auto select1 = new SelectInputWidget;
        addChild( select1 );
        foreach ( i; 0..5 ) {
            auto item1 = new MenuItemWidget;
            select1.addItem( item1 );

            auto text1 = new TextWidget;
            text1.loadText( i.to!dstring~":item to be selected"d, fontface );
            item1.setChild( text1 );

            if ( i == 0 ) select1.select( item1 );
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
