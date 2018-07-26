// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module w4d.element.background;
import w4d.style.box,
       w4d.exception;
import g4d.shader.base,
       g4d;

class BackgroundElement : RectElement
{
    protected vec3 _pos;

    this ()
    {
        _pos = vec3(0,0,0);
    }

    void resize ( BoxStyle box )
    {
        auto sz = box.borderInsideSize;
        super.resize( sz );
        _pos = vec3(sz/2,0) + vec3(box.borderInsideLeftTop,0);
    }

    override void draw ( Shader s )
    {
        auto saver = ShaderStateSaver( s );
        s.translate += _pos;
        super.draw( s );
    }
}
