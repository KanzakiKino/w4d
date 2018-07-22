// Written without LICENSE in the D programming language.
// Copyright 2018 KanzakiKino
import w4d;
import std.conv;

class TestRootWidget : PanelWidget
{
    this ()
    {
        super();
        setLayout!VerticalSplitLayout;

        style.getColorSet(0).bgColor = vec4(0.1,0.1,0.1,1);
    }

    auto createBitmap ( string path )
    {
        import g4d.file.media;
        auto media = new MediaFile( path );
        return media.decodeNextImage();
    }

    void prepare ( string path )
    {
        auto fontface = new FontFace(new Font("/usr/share/fonts/TTF/Ricty-Regular.ttf"), vec2i(16,0));

        auto image = new ImageWidget;
        image.setImage( createBitmap(path) );

        auto tabhost = new TabHostWidget;
        tabhost.setFontFace( fontface );
        tabhost.addTab( 0, "hoge1"d, image );
        tabhost.addTab( 1, "hoge2"d, new Widget );
        addChild( tabhost );
    }
}

int main ( string[] args )
{
    assert( args.length == 2 );

    auto app = new App( args );
    auto widget = new TestRootWidget;

    auto win = new Window( widget, vec2i(640,480), "TEST", WindowHint.Resizable );
    app.addTask( win );
    widget.prepare( args[1] );

    win.show();
    return app.exec();
}
