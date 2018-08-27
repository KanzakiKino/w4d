// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module demo.widget.root;
import w4d;
import std.conv,
       std.format;

class DemoRootWidget : RootWidget
{
    this ()
    {
        super();

        auto font = new Font( "/usr/share/fonts/TTF/Ricty-Regular.ttf" );
        auto face = new FontFace( font, vec2i(16,16) );

        auto tabhost = new TabHostWidget;
        tabhost.setFontFace( face );
        addChild( tabhost );

        tabhost.addTab( 0, "Input", createInputPage( face ) );
        tabhost.addTab( 1, "List" , createListPage ( face ) );
    }

    protected Widget createInputPage ( FontFace face )
    {
        auto scroll = new VerticalScrollPanelWidget;

        auto page = scroll.contents;

        foreach ( c; 0..30 ) {
            {
                auto line = new PanelWidget;
                line.setLayout!( FillLayout, HorizontalLineupPlacer );
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
                line.setLayout!( FillLayout, HorizontalMonospacedPlacer );
                page.addChild( line );

                auto input1 = new LineInputWidget;
                input1.style.box.margins = Rect(1.mm); // TODO
                input1.loadText( "normal - LineInputWidget"d, face );
                line.addChild( input1 );

                auto input2 = new LineInputWidget;
                input2.style.box.margins = Rect(1.mm); // TODO
                input2.loadText( "locked - LineInputWidget"d, face );
                input2.status.locked = true;
                line.addChild( input2 );
            }
            {
                auto line = new PanelWidget;
                line.setLayout!( FillLayout, HorizontalMonospacedPlacer );
                page.addChild( line );

                auto input1 = new LineInputWidget;
                input1.style.box.margins = Rect(1.mm); // TODO
                input1.loadText( "password - LineInputWidget"d, face );
                input1.changePasswordChar( '*' );
                line.addChild( input1 );

                auto input2 = new LineInputWidget;
                input2.style.box.margins = Rect(1.mm); // TODO
                input2.loadText( input1.text, face );
                input2.status.locked = true;
                line.addChild( input2 );

                input1.onTextChange = ((input2) => (dstring text) { input2.loadText(text); })(input2);
            }
            {
                auto line = new PanelWidget;
                line.setLayout!( FillLayout, HorizontalSplitPlacer );
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

    protected Widget createListPage ( FontFace face )
    {
        auto scroll = new VerticalScrollPanelWidget;
        auto page   = scroll.contents;

        auto list = new ListWidget;
        page.addChild( list );

        foreach ( i; 0..50 ) {
            auto item = new ListItemWidget;
            list.addItem( item );
            auto text = new TextWidget;
            item.setChild( text );

            text.loadText( i.to!dstring~": ListItemWidget"d, face );
        }
        return scroll;
    }
}
