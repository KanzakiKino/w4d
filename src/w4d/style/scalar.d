// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module w4d.style.scalar;
import w4d.style.exception;
import std.math;

unittest
{
    auto sc = Scalar( 50f, ScalarUnit.Percent ); // 50%
    assert( sc.calc( ScalarUnitBase(100f,10f) ) == 5f );
}

enum ScalarUnit
{
    None,

    // Absolute
    Pixel,
    Inch,

    // Relative
    Percent,
}
struct ScalarUnitBase
{
    float default_ = 0;
    float percent  = 0;

    static float inch = 0;
}

struct Scalar
{
    enum Auto = Scalar(0,ScalarUnit.None);

    protected const float      _value;
    protected const ScalarUnit _unit = ScalarUnit.Pixel;

    protected float _calculated;

    @property isAbsolute ()
    {
        return _unit <= ScalarUnit.Inch && _unit != ScalarUnit.None;
    }
    @property isRelative ()
    {
        return _unit >= ScalarUnit.Percent;
    }

    @property isCalced ()
    {
        return !isNaN(_calculated);
    }
    @property calced ()
    {
        if ( !isCalced ) {
            throw new StyleException( "The scalar isn't calculated." );
        }
        return _calculated;
    }

    float calc ( ScalarUnitBase base = ScalarUnitBase() )
    {
        final switch ( _unit ) with ( ScalarUnit )
        {
            case None:
                _calculated = base.default_;
                break;
            case Pixel:
                _calculated = _value;
                break;
            case Inch:
                _calculated = base.inch*_value;
                break;
            case Percent:
                _calculated = base.percent*_value/100f;
                break;
        }
        return _calculated;
    }
}
