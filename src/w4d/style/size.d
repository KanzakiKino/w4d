// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module w4d.style.size;
import w4d.style.scalar;
import g4d.math.vector;

unittest
{
    auto sz = Size(
            Scalar(30,ScalarUnit.Percent),
            Scalar(20,ScalarUnit.Percent) );
    assert( sz.isRelative );
    sz.calc( vec2(100,100) );
    assert( sz.isCalced );
    assert( sz.width .calced == 30 );
    assert( sz.height.calced == 20 );
}

struct Size
{
    Scalar width  = Scalar.Auto,
           height = Scalar.Auto;

    @property isAbsolute ()
    {
        return width.isAbsolute && height.isAbsolute;
    }
    @property isRelative ()
    {
        return !isAbsolute;
    }
    @property isCalced ()
    {
        return width.isCalced && height.isCalced;
    }

    void calc ( vec2 parentSize, vec2 def = vec2(0,0) )
    {
        width .calc( ScalarUnitBase( def.x, parentSize.x ) );
        height.calc( ScalarUnitBase( def.y, parentSize.y ) );
    }
}
