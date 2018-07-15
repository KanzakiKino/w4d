// Written without LICENSE in the D programming language.
// Copyright 2018 KanzakiKino
import w4d;

class TestRootWidget : PanelWidget
{
    this ()
    {
        super();
        setLayout!HorizontalSplitLayout;
        auto fontface = new FontFace(new Font("/usr/share/fonts/TTF/Ricty-Regular.ttf"), vec2i(16,0));

        style.getColorSet(0).bgColor = vec4(1,1,1,0.2);

        auto button = new ButtonWidget;
        button.setLayout!GravityLayout(vec2(0.5,0.5));
        button.setText( "PRESS ME!!"d, fontface );
        button.style.getColorSet(0).bgColor = vec4(1,1,1,0.2);
        button.style.box.size = Size( Scalar(150,ScalarUnit.Pixel), Scalar(50,ScalarUnit.Pixel) );
        button.onButtonPressed = delegate ()
        {
            button.setText( "Don't touch me!" );
        };
        addChild( button );
    }
}

int main ( string[] args )
{
    auto app = new App( args );

    auto widget = new TestRootWidget;

    auto win = new Window( widget, vec2i(640,480), "TEST", WindowHint.Resizable );
    app.addTask( win );

    win.show();
    return app.exec();
}
