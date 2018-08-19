// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module imgbrowser.widget.addressbar;
import imgbrowser.context;
import w4d;
import std.conv;

class AddressBarWidget : PanelWidget
{
    this ( FontFace face )
    {
        super();
        setLayout!( FillLayout, HorizontalSplitPlacer );

        auto input = new LineInputWidget;
        input.loadText( "", face );
        input.style.box.size.width = 85.percent;
        addChild( input );

        auto openbtn = new ButtonWidget;
        openbtn.loadText( "Open", face );
        openbtn.style.box.paddings   = Rect(0.5.mm,1.mm);
        openbtn.style.box.size.width = Scalar.None;
        addChild( openbtn );

        input.chainButton( openbtn );
        openbtn.onButtonPress = ()
        {
            auto url = input.text.to!string;
            ImgBrowser.mainTabs.openNewPage( url );
            input.loadText( "" );
        };
    }
}
