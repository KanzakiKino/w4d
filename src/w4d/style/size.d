// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module w4d.style.size;
import w4d.style.scalar,
       w4d.style.templates;
import g4d.math.vector;

unittest
{
    auto sz = Size(
            30.percent, 20.percent );
    assert( sz.isRelative );
    sz.calc( vec2(100,100) );
    assert( sz.isCalced );
    assert( sz.width .calced == 30 );
    assert( sz.height.calced == 20 );
}

struct Size
{
    enum Auto = Size();

    @("attr") {
        Scalar width  = Scalar.Auto,
               height = Scalar.Auto;
    }

    mixin AttributesUtilities;

    @property vector ()
    {
        return vec2( width.calced, height.calced );
    }

    void calc ( vec2 parentSize, vec2 def = vec2(0,0) )
    {
        width .calc( ScalarUnitBase( def.x, parentSize.x ) );
        height.calc( ScalarUnitBase( def.y, parentSize.y ) );
    }
}
