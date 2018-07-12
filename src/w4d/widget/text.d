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
    protected dstring     _content;
    protected FontFace    _font;

    this ()
    {
        _text    = new TextElement;
        _content = null;
        _font    = null;
    }

    void setText ( dstring v, FontFace f = null )
    {
        if ( f ) {
            _font = f;
        }
        _content = v;
        applyText();
    }

    protected void applyText ()
    {
        _text.clear();
        if ( _font && _content ) {
            _text.appendText( _content, _font );
        }
    }
    protected void fixText ()
    {
        if ( _text.isFixed ) {
            return;
        }
        _text.maxSize.x = style.box.clientSize.x;
        _text.maxSize.y = 0;
        _text.fix();
    }

    override void layout ()
    {
        applyText();
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
