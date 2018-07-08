// Written without LICENSE in the D programming language.
// Copyright 2018 KanzakiKino
import w4d;

class TestWidget : PanelWidget
{
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
            auto child = right.addChild( new Widget );
            child.style.box.size.height = Scalar(50,ScalarUnit.Pixel);
            child.style.box.margins     = Rect( Scalar(5,ScalarUnit.Pixel) );
            child.style.box.bgColor     = vec4(1,1,1,0.4);
        }
        auto child = right.addChild( new Widget );
        child.style.box.size.height = Scalar(95,ScalarUnit.Percent);
        child.style.box.margins     = Rect( Scalar(5,ScalarUnit.Pixel) );
        child.style.box.bgColor     = vec4(1,1,1,0.4);
    }
}

int main ( string[] args )
{
    auto app = new App( args );

    auto widget = new TestWidget;

    auto win = new Window( widget, vec2i(640,480), "TEST", WindowHint.Resizable );
    app.addTask( win );

    win.show();
    return app.exec();
}
