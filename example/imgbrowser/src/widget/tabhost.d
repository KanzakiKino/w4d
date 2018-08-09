// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module imgbrowser.widget.tabhost;
import imgbrowser.widget.page,
       imgbrowser.context;
import w4d;
import std.algorithm,
       std.conv;

class MainTabHostWidget : TabHostWidget, MainTabHost
{
    protected int _lastId;

    this ( FontFace face )
    {
        ImgBrowser.setMainTabHost( this );
        super();
        setFontFace( face );

        _lastId = 0;

        addTab( _lastId++, "About"d, createAbout( face ) );
    }

    protected Widget createAbout ( FontFace face )
    {
        auto panel = new PanelWidget;
        panel.setLayout!VerticalLineupLayout;
        panel.style.box.size.width  = Scalar.Auto;
        panel.style.box.size.height = Scalar.Auto;
        panel.style.box.paddings    = Rect(2.mm);

        auto title = new TextWidget;
        title.loadText( ImgBrowser.title, face );
        panel.addChild( title );

        auto copyright = new TextWidget;
        copyright.loadText( ImgBrowser.copyright, face );
        panel.addChild( copyright );

        return panel;
    }

    void openNewPage ( string url = "" )
    {
        auto title = url[0 .. min(10,url.length)].to!dstring;
        addTab( _lastId, title, new PageWidget( url ) );
        activateTab( findTabWithId(_lastId++) );
    }
}
