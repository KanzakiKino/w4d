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

    void prepare ( string path )
    {
        auto fontface = new FontFace(new Font("/usr/share/fonts/TTF/Ricty-Regular.ttf"), vec2i(16,0));

        auto text = new TextWidget;
        text.setText( "none"d, fontface );
        text.style.box.size.height = Scalar(20,ScalarUnit.Pixel);
        addChild( text );

        auto scroll = new ScrollBarWidget!false;
        scroll.style.box.size.width = Scalar(20,ScalarUnit.Pixel);
        scroll.setBarLength( 0.1 );
        scroll.setValue( 0.5 );
        scroll.onScroll = delegate ( float v )
        {
            text.setText( v.to!dstring );
        };
        addChild( scroll );
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
