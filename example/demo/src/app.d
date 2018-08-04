// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
import demo.widget.root,
       demo.context;
import w4d;

int main( string[] args )
{
    auto app = new App( args );

    auto win = new Window( vec2i(640,480), "w4d demo" );
    app.addTask( win );

    new AppContext;
    auto widget = new DemoRootWidget;
    win.setContent( widget );

    win.show();
    return app.exec();
}
