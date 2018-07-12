// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module w4d.element.text;
import g4d.shader.base;
static import g4d.element.text;
import std.math;

class TextElement : g4d.element.text.HTextElement
{
    this ()
    {
        super();
    }

    override void draw ( Shader s )
    {
        auto saver = ShaderStateSaver( s );
        s.translate.y += _firstLineHeight*2;
        s.rotation.x += PI;
        super.draw( s );
    }
}
