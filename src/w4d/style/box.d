// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module w4d.style.box;
import w4d.style.rect,
       w4d.style.scalar,
       w4d.style.size,
       w4d.style.templates;
import g4d.math.vector;

unittest
{
    auto box = BoxStyle();
    box.size        = Size(Scalar(100,ScalarUnit.Percent), Scalar(200));
    box.borderWidth = Rect(Scalar(5,ScalarUnit.Percent));
    box.margins     = Rect(Scalar(5,ScalarUnit.Percent));
    box.calc( vec2(300,300) );

    assert( box.isRelative );
    assert( box.isCalced );
    assert( box.size.width.calced == 300f );
    assert( box.borderWidth.left.calced == 15f );
    assert( box.margins.left.calced == 330/20f );
}

struct BoxStyle
{
    @("attr") {
        Size size;
        Rect paddings;
        Rect borderWidth;
        Rect margins;
    }

    mixin AttributesUtilities;

    @property clientSize ()
    {
        return size.vector;
    }
    @property clientLeftTop ()
    {
        auto result = vec2( margins.left.calced, margins.top.calced );
        result.x += borderWidth.left.calced + paddings.left.calced;
        result.y += borderWidth.top .calced + paddings.top .calced;
        return result;
    }

    @property borderInsideSize ()
    {
        auto result = size.vector;
        result.x += paddings.left.calced + paddings.right .calced;
        result.y += paddings.top .calced + paddings.bottom.calced;
        return result;
    }
    @property borderOutsideSize ()
    {
        auto result = borderInsideSize;
        result.x += borderWidth.left.calced + borderWidth.right .calced;
        result.y += borderWidth.top .calced + borderWidth.bottom.calced;
        return result;
    }
    // Collision size will be sum of size, borderWidth and margins.
    @property collisionSize ()
    {
        auto result = borderOutsideSize;
        result.x += margins.left.calced + margins.right .calced;
        result.y += margins.top .calced + margins.bottom.calced;
        return result;
    }

    void calc ( vec2 parentSize, vec2 def = vec2(0,0) )
    {
        size       .calc( parentSize, def );
        paddings   .calc( size.vector );
        borderWidth.calc( borderInsideSize );
        margins    .calc( borderOutsideSize );
    }
}
