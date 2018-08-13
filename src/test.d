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
        setLayout!VerticalSplitLayout;

        auto fontface = new FontFace(new Font("/usr/share/fonts/TTF/Ricty-Regular.ttf"), vec2i(16,16));

        auto btn = new ButtonWidget;
        btn.loadText( "add"d, fontface );
        btn.style.box.size.width = Scalar.None;
        addChild( btn );

        auto host = new MdiHostWidget;
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
        auto scroll = new VerticalScrollPanelWidget;

        auto page = scroll.contents;

        foreach ( c; 0..30 ) {
            {
                auto line = new PanelWidget;
                line.setLayout!HorizontalLineupLayout;
                page.addChild( line );

                auto checkbox1 = new CheckBoxWidget;
                checkbox1.style.box.margins = Rect(1.mm); // TODO
                checkbox1.loadText( "CheckBoxWidget"d, face );
                line.addChild( checkbox1 );

                auto checkbox2 = new CheckBoxWidget;
                checkbox2.style.box.margins = Rect(1.mm); // TODO
                checkbox2.loadText( "CheckBoxWidget"d, face );
                line.addChild( checkbox2 );
            }
            {
                auto line = new PanelWidget;
                line.setLayout!HorizontalMonospacedSplitLayout;
                page.addChild( line );

                auto input1 = new LineInputWidget;
                input1.style.box.margins = Rect(1.mm); // TODO
                input1.loadText( "normal - LineInputWidget"d, face );
                line.addChild( input1 );

                auto input2 = new LineInputWidget;
                input2.style.box.margins = Rect(1.mm); // TODO
                input2.loadText( "locked - LineInputWidget"d, face );
                input2.lock();
                line.addChild( input2 );
            }
            {
                auto line = new PanelWidget;
                line.setLayout!HorizontalSplitLayout;
                page.addChild( line );

                auto select = new SelectInputWidget;
                foreach ( i; 0..5 ) {
                    auto item = new MenuItemWidget;
                    select.addItem( item );
                    auto text = new TextWidget;
                    item.setChild( text );

                    if ( i == 0 ) {
                        select.select( item );
                    }
                    text.loadText( "item to be selected (%d)"d.format(i), face );
                }
                line.addChild( select );

                auto slider = new HorizontalSliderWidget;
                line.addChild( slider );
            }
        }
        return scroll;
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
