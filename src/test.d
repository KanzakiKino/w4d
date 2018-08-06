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

        auto host = new MdiHostWidget;
        addChild( host );

        foreach ( i; 0..5 ) {
            auto cli1 = new MdiClientWidget;
            cli1.limitSize( vec2(200,200), vec2(400,400) );
            cli1.loadText( "Client1 - MdiClientWidget"d, fontface );
            host.addClient( cli1 );
        }
    }
}

int main ( string[] args )
{
    auto app = new App( args );
    app.sleepDuration = 1;

    auto win = new Window( vec2i(640,480), "TEST", WindowHint.Resizable );
    win.setContent( new TestRootWidget );
    app.addTask( win );

    win.show();
    return app.exec();
}
