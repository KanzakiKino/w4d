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

    protected auto createBitmap ( vec2 sz )
    {
        import g4d.util.bitmap, std.conv;
        auto bmp = new BitmapRGB( vec2i(sz) );

        auto ptr = bmp.ptr;
        auto len = bmp.width*bmp.rows*bmp.lengthPerPixel;
        for ( auto i = 0; i < len; ) {
            auto n   = i*1f/len;
            ptr[i++] = (ubyte.max*n).to!ubyte;
            ptr[i++] = (ubyte.max*n).to!ubyte;
            ptr[i++] = (ubyte.max*n).to!ubyte;
        }
        return bmp;
    }

    void prepare ()
    {
        auto fontface = new FontFace(new Font("/usr/share/fonts/TTF/Ricty-Regular.ttf"), vec2i(16,0));

        enum imageSize = vec2(300,300);

        auto image = new ImageWidget;
        image.setLayout!GravityLayout(vec2(0.5,0.5));
        image.style.box.size = Size( Scalar(imageSize.x,ScalarUnit.Pixel), Scalar(imageSize.y,ScalarUnit.Pixel) );
        image.style.getColorSet(0).bgColor = vec4(0,0,0,1);
        image.setImage( createBitmap( imageSize ) );
        addChild( image );
    }
}

int main ( string[] args )
{
    auto app = new App( args );

    auto widget = new TestRootWidget;

    auto win = new Window( widget, vec2i(640,480), "TEST", WindowHint.Resizable );
    app.addTask( win );
    widget.prepare();

    win.show();
    return app.exec();
}
