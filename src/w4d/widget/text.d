// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module w4d.widget.text;
import w4d.element.text,
       w4d.task.window,
       w4d.widget.base;
import g4d.ft.font,
       g4d.math.vector;
import std.math;

class TextWidget : Widget
{
    protected TextElement _text;

    this ()
    {
        _text = new TextElement;
    }

    void appendText ( dstring v, FontFace f )
    {
        _text.appendText( v, f );
    }
    void setText ( dstring v, FontFace f )
    {
        clearText();
        appendText( v, f );
    }
    void clearText ()
    {
        _text.clear();
    }

    protected void fixText ()
    {
        if ( _text.isFixed ) {
            return;
        }
        _text.fix();
        layout();
    }

    override void layout ()
    {
        super.layout();
    }

    override void draw ( Window win )
    {
        super.draw( win );

        fixText();

        auto shader = win.shaders.alpha3;

        shader.use( false );
        shader.setVectors( vec3(_style.clientLeftTop,0) );
        shader.color = style.color;
        _text.draw( shader );
    }
}
