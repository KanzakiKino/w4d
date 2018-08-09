// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module imgbrowser.widget.page;
import imgbrowser.util.htmlimg;
import w4d, g4d;

class PageWidget : VerticalScrollPanelWidget
{
    protected ImgSearcher _searcher;
    protected bool        _needReload;

    this ( string url )
    {
        super();
        _searcher = new ImgSearcher( url );
        reload();
    }

    protected void reload ()
    {
        contents.removeAllChildren();

        while ( true )
        {
            auto url = _searcher.pop;
            if ( url == "" ) break;

            try {
                auto media = new MediaFile( url );
                auto bmp   = media.decodeNextImage();

                auto image = new ImageWidget;
                image.setImage( bmp );
                contents.addChild( image );

            } catch ( Exception e ) {
                continue;
            }
        }
    }
}
