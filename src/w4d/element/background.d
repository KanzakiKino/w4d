// Written in the D programming language.
/++
 + Authors: KanzakiKino
 + Copyright: KanzakiKino 2018
 + License: LGPL-3.0
++/
module w4d.element.background;
import w4d.style.box,
       w4d.exception;
import g4d.element.shape.rect,
       g4d.shader.base;
import gl3n.linalg;

/// An element of background.
class BackgroundElement : RectElement
{
    protected vec3 _pos;

    ///
    this ()
    {
        _pos = vec3(0,0,0);
    }

    ///
    void resize ( BoxStyle box )
    {
        auto sz = box.borderInsideSize;
        super.resize( sz );
        _pos = vec3(sz/2,0) + vec3(box.borderInsideLeftTop,0);
    }

    ///
    override void draw ( Shader s )
    {
        s.matrix.late = s.matrix.late+_pos;
        super.draw( s );
        s.matrix.late = s.matrix.late-_pos;
    }
}
