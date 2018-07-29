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
        input1.style.box.margins = Rect( 5.pixel );
        page1.addChild( input1 );

        auto input2 = new LineInputWidget;
        input2.loadText( "locked"d, fontface );
        input2.lock();
        input2.style.box.margins = Rect( 5.pixel );
        page1.addChild( input2 );

        auto page2 = new PanelWidget;
        page2.setLayout!VerticalLineupLayout;

        auto line1 = new PanelWidget;
        line1.setLayout!HorizontalSplitLayout;
        line1.style.box.size.height = 40.pixel;
        page2.addChild( line1 );

        auto text1 = new TextWidget;
        text1.loadText( "x.xxxxx"d, fontface );
        text1.adjustSize();
        text1.colorset.fgColor = vec4(1,1,1,1);
        line1.addChild( text1 );

        auto slider1 = new HorizontalSliderWidget;
        slider1.onValueChange = delegate ( float v ) {
            text1.loadText( v.to!dstring );
        };
        line1.addChild( slider1 );

        auto checkbox1 = new CheckBoxWidget;
        checkbox1.loadText( "lock the slider"d, fontface );
        checkbox1.adjustSize();
        checkbox1.onCheck = delegate ( bool b ) {
            if ( b ) slider1.lock();
            else slider1.unlock();
        };
        page2.addChild( checkbox1 );

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
