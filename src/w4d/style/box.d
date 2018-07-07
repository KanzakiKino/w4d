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
    box.size        = Size(Scalar(100,ScalarUnit.Percent), Scalar(200,ScalarUnit.Pixel));
    box.borderWidth = Rect(Scalar(5,ScalarUnit.Percent));
    box.margins     = Rect(Scalar(5,ScalarUnit.Percent));
    box.calc( vec2(300,300) );

    assert( box.isRelative );
    assert( box.isCalced );
    assert( box.size.width.calced == 300f );
    assert( box.borderWidth.left.calced == 300*0.05f );
    assert( box.margins.left.calced == 300*0.05f );
}

struct BoxStyle
{
    @("attr") {
        Size size;
        Rect paddings;
        Rect borderWidth;
        Rect margins;
    }
    vec4 bgColor     = vec4(0,0,0,0);
    vec4 borderColor = vec4(0,0,0,1);

    mixin AttributesUtilities;

    @property clientSize ()
    {
        return size.vector;
    }
    @property clientLeftTop ()
    {
        return borderInsideLeftTop +
            vec2( paddings.left.calced, paddings.top.calced );
    }
    @property clientAdditionalSize ()
    {
        auto result = borderInsideAdditionalSize;
        result.x += paddings.left.calced + paddings.right .calced;
        result.y += paddings.top .calced + paddings.bottom.calced;
        return result;
    }

    @property borderInsideSize ()
    {
        auto result = size.vector;
        result.x += paddings.left.calced + paddings.right .calced;
        result.y += paddings.top .calced + paddings.bottom.calced;
        return result;
    }
    @property borderInsideLeftTop ()
    {
        return borderOutsideLeftTop +
            vec2( borderWidth.left.calced, borderWidth.top.calced );
    }
    @property borderInsideAdditionalSize ()
    {
        auto result = borderOutsideAdditionalSize;
        result.x += borderWidth.left.calced + borderWidth.right .calced;
        result.y += borderWidth.top .calced + borderWidth.bottom.calced;
        return result;
    }

    @property borderOutsideSize ()
    {
        auto result = borderInsideSize;
        result.x += borderWidth.left.calced + borderWidth.right .calced;
        result.y += borderWidth.top .calced + borderWidth.bottom.calced;
        return result;
    }
    @property borderOutsideLeftTop ()
    {
        return vec2( margins.left.calced, margins.top.calced );
    }
    @property borderOutsideAdditionalSize ()
    {
        return vec2( margins.left.calced + margins.right.calced,
               margins.top.calced + margins.bottom.calced );
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
        paddings   .calc( parentSize );
        borderWidth.calc( parentSize );
        margins    .calc( parentSize );

        if ( def.x <= 0 ) {
            def = parentSize - clientAdditionalSize;
        }
        size.calc( parentSize, def );
    }
}
