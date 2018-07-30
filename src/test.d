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
        page1.setLayout!VerticalSplitLayout;

        auto line1 = new PanelWidget;
        line1.setLayout!HorizontalSplitLayout;
        line1.style.box.size.height = 13.mm;
        line1.style.box.margins = Rect( 1.mm );
        page1.addChild( line1 );

        auto input1 = new LineInputWidget;
        input1.style.box.size.width = 80.percent;
        input1.loadText( ""d, fontface );
        input1.setLayout!GravityLayout(vec2(0f,0.5f));
        line1.addChild( input1 );

        auto button1 = new ButtonWidget;
        button1.loadText( "Add", fontface );
        button1.style.box.margins = Rect( 2.mm );
        line1.addChild( button1 );

        auto list1 = new ListWidget;
        page1.addChild( list1 );

        button1.onButtonPressed = () {
            auto text1 = new ListTextItemWidget;
            text1.loadText( input1.text, fontface );
            text1.adjustSize();
            list1.addItem( list1.idMap.length.to!int+1, text1 );
        };

        auto tab = new TabHostWidget;
        tab.setFontFace( fontface );
        tab.addTab( 0, "Page1", page1 );
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
