// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module w4d.element.text;
import g4d.element.text,
       g4d.shader.base;
import gl3n.linalg;
import std.math;

class TextElement : HTextElement
{
    vec2 originRate;

    this ()
    {
        super();
        originRate = vec2(0,0);
    }

    override void draw ( Shader s )
    {
        const saver = ShaderStateSaver(s);
        const late  = vec3(
                size.x*originRate.x, size.y*originRate.y, 0 );

        s.matrix.late = s.matrix.late - late;
        s.matrix.rota = s.matrix.rota + vec3(PI,0,0);
        super.draw( s );
    }
}
