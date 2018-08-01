// Written without LICENSE in the D programming language.
// Copyright 2018 KanzakiKino
import w4d;
import std.conv;

class TestRootWidget : RootWidget
{
    this ()
    {
        super();
        setLayout!VerticalLineupLayout;
        style.getColorSet(0).bgColor = vec4(0.1,0.1,0.1,1);

        auto fontface = new FontFace(new Font("/usr/share/fonts/TTF/Ricty-Regular.ttf"), vec2i(16,16));

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
