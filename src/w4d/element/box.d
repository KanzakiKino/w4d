// Written in the D programming language.
/++
 + Authors: KanzakiKino
 + Copyright: KanzakiKino 2018
 + License: LGPL-3.0
++/
module w4d.element.box;
import w4d.element.border,
       w4d.style.box,
       w4d.style.color,
       w4d.exception;
import g4d.element.shape.rect,
       g4d.element.base,
       g4d.shader.base,
       g4d.shader.fill3d;
import gl3n.linalg;
import std.conv;

/// An element of BoxStyle.
class BoxElement : Element
{
    protected vec4 _bgColor;
    protected vec4 _borderColor;

    protected RectElement       _bg;
    protected BoxBorderElement  _border;

    ///
    this ()
    {
        _bgColor     = vec4(0,0,0,0);
        _borderColor = vec4(0,0,0,0);

        _bg     = new RectElement;
        _border = new BoxBorderElement;
    }

    ///
    void resize ( BoxStyle box )
    {
        _bg    .resize( box.borderInsideSize );
        _border.resize( box );
    }
    ///
    void setColor ( in ColorSet col )
    {
        _bgColor     = col.background;
        _borderColor = col.border;
    }

    ///
    override void clear ()
    {
        _bg    .clear();
        _border.clear();
    }

    ///
    override void draw ( Shader s )
    {
        auto shader = s.to!Fill3DShader;

        if ( _bgColor.a ) {
            shader.color = _bgColor;
            _bg.draw( shader );
        }
        if ( _borderColor.a ) {
            shader.color = _borderColor;
            _border.draw( shader );
        }
    }
}
