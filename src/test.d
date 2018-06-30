// Written without LICENSE in the D programming language.
// Copyright 2018 KanzakiKino
import w4d;

int main ( string[] args )
{
    auto app = new App( args );

    auto widget = new Widget;

    auto win = new Window( widget, vec2i(640,480), "TEST" );
    app.addTask( win );

    win.show();
    return app.exec();
}
