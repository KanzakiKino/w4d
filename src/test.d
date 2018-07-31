// Written without LICENSE in the D programming language.
// Copyright 2018 KanzakiKino
import w4d;
import std.conv;

class TestRootWidget : PanelWidget
{
    this ()
    {
        super();
        setLayout!VerticalLineupLayout;
        style.getColorSet(0).bgColor = vec4(0.1,0.1,0.1,1);

        auto fontface = new FontFace(new Font("/usr/share/fonts/TTF/Ricty-Regular.ttf"), vec2i(16,16));

        auto check1 = new CheckBoxWidget;
        check1.loadText( "hoge"d, fontface );
        addChild( check1 );

        auto text1 = new TextWidget;
        text1.loadText( "hoge"d, fontface );
        addChild( text1 );

        check1.onCheck = ( bool b ) {
            text1.loadText( b? "fuck you"d: "FUCK YOU"d, fontface );
        };
    }
}

int main ( string[] args )
{
    auto app = new App( args );

    auto win = new Window( vec2i(640,480), "TEST", WindowHint.Resizable );
    win.setContent( new TestRootWidget );
    app.addTask( win );

    win.show();
    return app.exec();
}
