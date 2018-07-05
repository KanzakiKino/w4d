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
        Rect borderWidth;
        Rect margins;
    }

    mixin AttributesUtilities;

    @property border ()
    {
        auto w = size.width .calced + borderWidth.left.calced + borderWidth.right .calced;
        auto h = size.height.calced + borderWidth.top .calced + borderWidth.bottom.calced;
        return vec2( w, h );
    }
    // Collision size will be sum of size, borderWidth and margins.
    @property collision ()
    {
        auto result = border;
        result.x += margins.left.calced + margins.right .calced;
        result.y += margins.top .calced + margins.bottom.calced;
        return result;
    }

    void calc ( vec2 parentSize, vec2 def = vec2(0,0) )
    {
        size       .calc( parentSize, def );
        borderWidth.calc( size.vector );
        margins    .calc( border );
    }
}
