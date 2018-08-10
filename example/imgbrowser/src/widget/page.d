// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module imgbrowser.widget.page;
import imgbrowser.util.htmlimg,
       imgbrowser.task.decode,
       imgbrowser.task.download,
       imgbrowser.context;
import w4d, g4d;

class PageWidget : VerticalScrollPanelWidget
{
    protected ImgSearcher _searcher;
    protected Task[]      _taskStack;

    this ( string url )
    {
        super();

        auto task = new DownloadTask( url );
        task.onFinish = ( char[] src ) {
            _searcher = new ImgSearcher( url );
            reload();
        };
        ImgBrowser.app.addTask( task );
    }

    protected void addImage ( BitmapRGBA bmp )
    {
        if ( !bmp ) return;

        auto image = new ImageWidget;
        image.setImage( bmp );
        contents.addChild( image );
        bmp.dispose();
    }

    protected void reload ()
    {
        contents.removeAllChildren();

        string[] urls;
        while ( true ) {
            auto url = _searcher.pop;
            if ( url == "" ) break;

            urls ~= url;
        }
        auto task = new DecodeTask( urls );
        task.onDecode = &addImage;
        ImgBrowser.app.addTask( task );
    }
}
