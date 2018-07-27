// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
import calc.widget.root;
import w4d;

int main( string[] args )
{
    auto app    = new App( args );
    auto widget = new RootWidget;
    auto window = new Window( widget, vec2i(300,350), "calc" );

    app.addTask( window );
    widget.prepare();
    window.show();

    return app.exec();
}
