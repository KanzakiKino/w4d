// Written without LICENSE in the D programming language.
// Copyright 2018 KanzakiKino
import w4d;

class TestRootWidget : PanelWidget
{
    this ()
    {
        super();
        setLayout!HorizontalSplitLayout;

        style.getColorSet(0).bgColor = vec4(1,1,1,0.2);
    }

    protected auto createBitmap ( string path )
    {
        import g4d;
        auto media = new MediaFile( path );
        return media.decodeNextImage();
    }

    void prepare ( string path )
    {
        auto fontface = new FontFace(new Font("/usr/share/fonts/TTF/Ricty-Regular.ttf"), vec2i(16,0));

        auto bmp  = createBitmap( path );
        auto size = vec2( bmp.width, bmp.rows );

        auto image = new ImageWidget;
        image.setLayout!GravityLayout(vec2(0.5,0.5));
        image.style.box.size = Size( Scalar(size.x,ScalarUnit.Pixel), Scalar(size.y,ScalarUnit.Pixel) );
        image.setImage( bmp );
        addChild( image );
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
