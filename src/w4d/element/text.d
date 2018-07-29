// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module w4d.element.text;
import g4d.shader.base;
import g4d.math.vector;
static import g4d.element.text;
import std.math;

class TextElement : g4d.element.text.HTextElement
{
    vec2 originRate;

    @property size () { return _size; }

    this ()
    {
        super();
        originRate = vec2(0,0);
    }

    override void draw ( Shader s )
    {
        auto saver = ShaderStateSaver( s );

        s.translate.x -= _size.x*originRate.x;
        s.translate.y -= _size.y*originRate.y;
        s.rotation.x  += PI;
        super.draw( s );
    }
}
