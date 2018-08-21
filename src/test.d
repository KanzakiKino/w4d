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
        btn.style.box.size.width = Scalar.None;
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
        auto page = new PanelWidget;
        page.style.box.size.width  = Scalar.Auto;
        page.style.box.size.height = Scalar.Auto;

        auto panel = new PanelWidget;
        import w4d.style.widget;
        panel.setLayout!( GravityLayout, HorizontalLineupPlacer )( vec2(0.5,0.5) );
        page.addChild( panel );

        auto text1 = new TextWidget;
        text1.loadText( "input: ", face );
        panel.addChild( text1 );

        auto input1 = new LineInputWidget;
        input1.loadText( "hogehoge", face );
        input1.style.box.size.width = 50.percent;
        panel.addChild( input1 );

        auto text2 = new TextWidget;
        text2.loadText( "hoge", face );
        page.addChild( text2 );

        return page;
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
