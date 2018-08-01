// Written without LICENSE in the D programming language.
// Copyright 2018 KanzakiKino
import w4d;
import std.conv;

class TestRootWidget : PanelWidget
{
    this ()
    {
        super();
        setLayout!VerticalLineupLayout;
        style.getColorSet(0).bgColor = vec4(0.1,0.1,0.1,1);

        auto fontface = new FontFace(new Font("/usr/share/fonts/TTF/Ricty-Regular.ttf"), vec2i(16,16));

        auto list1 = new ListWidget;
        list1.setMultiselectable( true );
        addChild( list1 );

        foreach ( i; 0..20 ) {
            auto widget1 = new ListItemWidget(i);

            auto text1 = new TextWidget;
            text1.loadText( i.to!dstring~"fuck you."d, fontface );
            widget1.addChild( text1 );

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
