// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module w4d.element.border;
import w4d.style.box;
import g4d.element.base,
       g4d.shader.base,
       g4d;
import std.algorithm;

class BoxBorderElement : Element
{
    protected vec3 _pos;

    // 0:top, 1:right, 2:bottom, 3:left
    protected RectElement[4] _rects;
    protected float[4]       _lates;

    this ()
    {
        _pos = vec3(0,0,0);

        foreach ( ref rc; _rects ) {
            rc = new RectElement;
        }
    }

    void resize ( BoxStyle box )
    {
        auto outsz = box.borderOutsideSize;
        auto insz  = box.borderInsideSize;
        auto width = box.borderWidth;

        _rects[0].resize( vec2(outsz.x, width.top   .calced) );
        _rects[2].resize( vec2(outsz.x, width.bottom.calced) );
        _rects[1].resize( vec2(width.right.calced, insz.y  ) );
        _rects[3].resize( vec2(width.left .calced, insz.y  ) );

        _lates[0] = -(insz.y + width.top   .calced)/2;
        _lates[2] =  (insz.y + width.bottom.calced)/2;
        _lates[1] =  (insz.x + width.right .calced)/2;
        _lates[3] = -(insz.x + width.left  .calced)/2;

        _pos = vec3(box.collisionSize/2, 0);
    }

    override void clear ()
    {
        _rects.each!( x => x.clear() );
        _lates[] = 0;
    }

    override void draw ( Shader s )
    {
        s.translate += _pos;
        foreach ( i,rc; _rects ) {
            auto saver = ShaderStateSaver( s );
            (i%2? s.translate.x: s.translate.y) += _lates[i];
            rc.draw( s );
        }
    }
}
