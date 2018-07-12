// Written without LICENSE in the D programming language.
// Copyright 2018 KanzakiKino
import w4d;

class TestRootWidget : PanelWidget
{
    class TestContentWidget : Widget
    {
        this ()
        {
            super();
            style.box.size.width  = Scalar(50,ScalarUnit.Pixel);
            style.box.size.height = Scalar(50,ScalarUnit.Pixel);
            style.box.bgColor     = vec4(1,1,1,0.4);
            setLayout!GravityLayout( vec2(0.2,0.5) );
        }
    }

    this ()
    {
        super();
        setLayout!HorizontalSplitLayout;

        _style.box.bgColor = vec4(1,1,1,0.2);

        auto left = addChild( new Widget );
        left.style.box.size.width  = Scalar(20,ScalarUnit.Percent);
        left.style.box.size.height = Scalar(300,ScalarUnit.Pixel);
        left.style.box.margins     = Rect( Scalar(5,ScalarUnit.Pixel) );
        left.style.box.bgColor     = vec4(1,1,1,0.4);

        auto right = new PanelWidget;
        right.style.box.margins     = Rect( Scalar(5,ScalarUnit.Pixel) );
        right.style.box.bgColor     = vec4(1,1,1,0.4);
        right.setLayout!VerticalSplitLayout;
        addChild( right );

        foreach ( i; 0..5 ) {
            auto child = new TextWidget;
            import g4d.ft.font;
            child.style.box.size.height = Scalar(50,ScalarUnit.Pixel);
            child.style.box.bgColor = vec4(1,1,1,0.4);
            child.style.box.margins = Rect( Scalar(5, ScalarUnit.Pixel) );
            child.setText( "hoge"d,  new FontFace( new Font("/usr/share/fonts/TTF/Ricty-Regular.ttf"), vec2i(16,0) ));
            right.addChild( child );
        }
        auto gravity = new PanelWidget;
        gravity.style.box.margins     = Rect( Scalar(5,ScalarUnit.Pixel) );
        gravity.style.box.bgColor     = vec4(1,1,1,0.4);
        gravity.addChild( new TestContentWidget );
        right.addChild( gravity );
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
