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
        auto fontface = new FontFace(new Font("/usr/share/fonts/TTF/Ricty-Regular.ttf"), vec2i(16,16));

        auto panel = new PanelWidget;
        panel.setLayout!VerticalLineupLayout;

        auto input1 = new LineInputWidget;
        input1.loadText( "default"d, fontface );
        panel.addChild( input1 );

        auto input2 = new LineInputWidget;
        input2.loadText( "locked"d, fontface );
        input2.lock();
        panel.addChild( input2 );

        addChild( panel );
    }
}

int main ( string[] args )
{
    auto app = new App( args );
    auto widget = new TestRootWidget;

    auto win = new Window( widget, vec2i(640,480), "TEST", WindowHint.Resizable );
    app.addTask( win );
    widget.prepare( /*args[1]*/"" );

    win.show();
    return app.exec();
}
