// Written in the D programming language.
/++
 + Authors: KanzakiKino
 + Copyright: KanzakiKino 2018
 + License: LGPL-3.0
++/
module w4d.widget.text;
import w4d.element.text,
       w4d.style.color,
       w4d.style.rect,
       w4d.style.scalar,
       w4d.task.window,
       w4d.widget.base,
       w4d.exception;
import g4d.ft.font,
       g4d.shader.base;
import gl3n.linalg;
import std.math;

/// A widget of text.
class TextWidget : Widget
{
    protected TextElement _textElm;
    protected dstring     _text;
    protected FontFace    _font;

    /// Rate of text origin.
    @property ref textOriginRate ()
    {
        return _textElm.originRate;
    }

    /// Text.
    @property dstring text () { return _text; }
    /// Font.
    @property FontFace font () { return _font; }

    /// Rate of text position.
    vec2 textPosRate;

    ///
    override @property vec2 wantedSize ()
    {
        return _textElm.size;
    }

    ///
    this ()
    {
        super();
        _textElm = new TextElement;
        _text    = null;
        _font    = null;

        textPosRate = vec2(0,0);

        style.box.size.width  = Scalar.Auto;
        style.box.size.height = Scalar.Auto;
    }

    /// Changes text.
    void loadText ( dstring v, FontFace f = null )
    {
        if ( f ) {
            _font = f;
        }
        enforce( _font, "FontFace is not specified." );

        _text = v;
        if ( _text.length ) {
            _textElm.loadText( _font, _text );
        }
        if ( style.box.size.isAuto ) {
            requestLayout();
        } else {
            requestRedraw();
        }
    }

    protected void drawText ( Window win )
    {
        if ( !_text.length ) return;

        auto shader = win.shaders.alpha3;
        auto saver  = ShaderStateSaver( shader );

        auto size = _style.box.clientSize;
        auto late = _style.clientLeftTop;
        late += vec2( size.x*textPosRate.x, size.y*textPosRate.y );

        shader.use();
        shader.matrix.late = vec3( late, 0 );
        shader.color       = colorset.foreground;
        _textElm.draw( shader );
    }
    ///
    override void draw ( Window win, ColorSet parent )
    {
        super.draw( win, parent );
        drawText( win );
    }

    ///
    override @property bool trackable () { return false; }
    ///
    override @property bool focusable () { return false; }
}
