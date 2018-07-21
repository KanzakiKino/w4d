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

        auto scroll = new ScrollPanelWidget!false;
        scroll.style.box.size.height = Scalar(50,ScalarUnit.Percent);
        addChild( scroll );

        auto image = new ImageWidget;
        image.style.box.size.height = Scalar(500,ScalarUnit.Percent);
        image.setImage( createBitmap( path ) );
        scroll.contents.addChild( image );
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
