// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module w4d.widget.text;
import w4d.element.text,
       w4d.task.window,
       w4d.widget.base,
       w4d.exception;
import g4d.ft.font,
       g4d.math.vector,
       g4d.shader.base;
import std.math;

class TextWidget : Widget
{
    protected TextElement _textElm;
    protected dstring     _text;
    protected FontFace    _font;

    @property text () { return _text; }
    @property font () { return _font; }

    vec2 textPosRate;
    protected vec2 _calcedMargin;

    this ()
    {
        _textElm = new TextElement;
        _text    = null;
        _font    = null;

        textPosRate   = vec2(0,0);
        _calcedMargin = vec2(0,0);
    }

    void setText ( dstring v, FontFace f = null )
    {
        if ( f ) {
            _font = f;
        }
        _text = v;
        applyText();
    }

    protected void applyText ()
    {
        enforce( _font, "FontFace is not specified." );

        _textElm.clear();
        if ( _text ) {
            _textElm.appendText( _text, _font );
        }
    }
    protected void fixText ()
    {
        auto boxSize  = style.box.clientSize;

        if ( _textElm.isFixed ) {
            return;
        }
        _textElm.maxSize.x = boxSize.x;
        _textElm.maxSize.y = 0;

        auto textSize = _textElm.fix();
        _calcedMargin.x = (boxSize.x-textSize.x) * textPosRate.x;
        _calcedMargin.y = (boxSize.y-textSize.y) * textPosRate.y;
    }

    override void layout ()
    {
        applyText(); // Recreate char polys to re-layout characters.
        super.layout();
    }

    override void draw ( Window win )
    {
        super.draw( win );

        fixText();

        auto shader    = win.shaders.alpha3;
        auto saver     = ShaderStateSaver( shader );
        auto translate = _style.clientLeftTop + _calcedMargin;

        shader.use( false );
        shader.setVectors( vec3(translate,0) );
        shader.color = colorset.fgColor;
        _textElm.draw( shader );
    }
}
