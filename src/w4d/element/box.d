// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module w4d.element.box;
import w4d.element.background,
       w4d.style.box,
       w4d.exception;
import g4d.element.base,
       g4d.shader.base,
       g4d;
import std.conv;

class BoxElement : Element
{
    protected vec4              _bgColor;
    protected BackgroundElement _bg;

    this ()
    {
        _bg = new BackgroundElement;
    }

    void resize ( BoxStyle box )
    {
        _bgColor = box.bgColor;
        _bg.resize( box );
    }

    override void clear ()
    {
        _bg.clear();
    }

    override void draw ( Shader s )
    {
        auto shader = s.to!Fill3DShader;
        shader.color = _bgColor;
        _bg.draw( shader );
    }
}
