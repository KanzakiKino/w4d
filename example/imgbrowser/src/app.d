// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
import imgbrowser.widget.root,
       imgbrowser.context;
import w4d;

int main( string[] args )
{
    auto app = new App( args );
    new AppContext;

    auto win = new Window( vec2i(600,500), ImgBrowser.title,
            WindowHint.Resizable );
    win.setContent( new ImgBrowserRootWidget );

    app.addTask( win );
    win.show();
    return app.exec();
}
