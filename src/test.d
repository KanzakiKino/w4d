// Written without LICENSE in the D programming language.
// Copyright 2018 KanzakiKino
import w4d;
import std.conv,
       std.format;

class TestRootWidget : RootWidget
{
    this ()
    {
        super();
        setLayout!( FillLayout, VerticalSplitPlacer );

        auto fontface = new FontFace(new Font("/usr/share/fonts/TTF/Ricty-Regular.ttf"), vec2i(16,16));

        auto btn = new ButtonWidget;
        btn.loadText( "add"d, fontface );
        btn.text.style.box.size.width = Scalar.None;
        addChild( btn );

        auto host = new MdiHostWidget;
        host.style.box.size.height = 100.percent;
        addChild( host );

        btn.onButtonPress = () {
            auto cli1 = new MdiClientWidget;
            cli1.limitSize( vec2(400,400), vec2(600,600) );
            cli1.resize( vec2(500,500) );
            cli1.loadText( "Client1 - MdiClientWidget"d, fontface );
            cli1.contents.addChild( createInputPage( fontface ) );
            host.addClient( cli1 );
        };
    }

    protected Widget createInputPage ( FontFace face )
    {
        auto panel = new PanelWidget;
        panel.style.box.size.width  = Scalar.Auto;
        panel.style.box.size.height = Scalar.Auto;
        panel.setLayout!( FillLayout, VerticalLineupPlacer );

        auto button1 = new ButtonWidget;
        button1.loadText( "ButtonWidget - normal", face );
        panel.addChild( button1 );

        auto button2 = new ButtonWidget;
        button2.loadText( "ButtonWidget - locked", face );
        button2.status.locked = true;
        panel.addChild( button2 );

        auto button3 = new ButtonWidget;
        button3.loadText( "ButtonWidget - disabled", face );
        button3.status.disabled = true;
        panel.addChild( button3 );

        return panel;
    }
}

int main ( string[] args )
{
    auto app = new App( args );
    app.sleepDuration = 5;

    auto win = new Window( vec2i(640,480), "TEST", WindowHint.Resizable );
    win.setContent( new TestRootWidget );
    app.addTask( win );

    win.show();
    return app.exec();
}
