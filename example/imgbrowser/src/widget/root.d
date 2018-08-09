// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module imgbrowser.widget.root;
import imgbrowser.widget.addressbar,
       imgbrowser.widget.tabhost,
       imgbrowser.context;
import w4d;

class ImgBrowserRootWidget : RootWidget
{
    protected FontFace _face;

    this ()
    {
        super();
        setLayout!VerticalSplitLayout();

        auto font = new Font( ImgBrowser.fontPath );
        _face = new FontFace( font, vec2i(16,16) );

        addChild( new AddressBarWidget ( _face ) );
        addChild( new MainTabHostWidget( _face ) );
    }
}
