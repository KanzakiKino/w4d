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

        auto fontface = new FontFace(new Font("/usr/share/fonts/TTF/Ricty-Regular.ttf"), vec2i(16,16));

        auto page1 = new PanelWidget;
        page1.setLayout!HorizontalMonospacedSplitLayout;

        auto input1 = new LineInputWidget;
        input1.loadText( "default"d, fontface );
        input1.style.box.margins = Rect( Scalar(5,ScalarUnit.Pixel) );
        page1.addChild( input1 );

        auto input2 = new LineInputWidget;
        input2.loadText( "locked"d, fontface );
        input2.lock();
        input2.style.box.margins = Rect( Scalar(5,ScalarUnit.Pixel) );
        page1.addChild( input2 );

        auto page2 = new PanelWidget;

        auto tab = new TabHostWidget;
        tab.setFontFace( fontface );
        tab.addTab( 0, "Page1", page1 );
        tab.addTab( 1, "Page2", page2 );
        addChild( tab );
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
