// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module w4d.element.box;
import w4d.element.background,
       w4d.element.border,
       w4d.style.box,
       w4d.style.color,
       w4d.exception;
import g4d.element.base,
       g4d.shader.base,
       g4d;
import std.conv;

class BoxElement : Element
{
    protected vec4              _bgColor;
    protected vec4              _borderColor;

    protected BackgroundElement _bg;
    protected BoxBorderElement  _border;

    this ()
    {
        _bg     = new BackgroundElement;
        _border = new BoxBorderElement;
    }

    void resize ( BoxStyle box )
    {
        _bg    .resize( box );
        _border.resize( box );
    }
    void setColor ( ColorSet col )
    {
        _bgColor     = col.bgColor;
        _borderColor = col.borderColor;
    }

    override void clear ()
    {
        _bg    .clear();
        _border.clear();
    }

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
