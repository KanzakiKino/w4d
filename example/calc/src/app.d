// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
import calc.widget.root;
import w4d;

int main( string[] args )
{
    auto app    = new App( args );

    auto window = new Window( vec2i(300,350), "calc" );
    window.setContent( new CalcRootWidget );
    app.addTask( window );

    window.show();

    return app.exec();
}
