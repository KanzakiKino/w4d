// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module w4d.style.scalar;
import w4d.style.exception;
import std.math;

unittest
{
    auto sc = 50.percent; // 50%
    assert( sc.calc( ScalarUnitBase(100f,10f) ) == 5f );
}

@property pixel ( float n )
{
    return Scalar( n, ScalarUnit.Pixel );
}
@property inch ( float n )
{
    return Scalar( n, ScalarUnit.Inch );
}
@property mm ( float n )
{
    return Scalar( n, ScalarUnit.MilliMetre );
}
@property percent ( float n )
{
    return Scalar( n, ScalarUnit.Percent );
}

enum ScalarUnit
{
    None,
    Auto,

    // Absolute
    Pixel,
    MilliMetre,
    Inch,

    // Relative
    Percent,
}
struct ScalarUnitBase
{
    float default_ = 0;
    float percent  = 0;

    static float mm   = 0;
    static float inch = 0;
}

struct Scalar
{
    enum None = Scalar(0,ScalarUnit.None);
    enum Auto = Scalar(0,ScalarUnit.Auto);

    protected float      _value = 0;
    protected ScalarUnit _unit  = ScalarUnit.None;

    protected float _calculated;

    @property isNone ()
    {
        return _unit == ScalarUnit.None;
    }
    @property isAuto ()
    {
        return _unit == ScalarUnit.Auto;
    }

    @property isAbsolute ()
    {
        return _unit <= ScalarUnit.Inch && !isNone && !isAuto;
    }
    @property isRelative ()
    {
        return _unit >= ScalarUnit.Percent;
    }
    @property isSpecified ()
    {
        return isAbsolute || isRelative;
    }

    @property isCalced ()
    {
        return !isNaN(_calculated);
    }
    @property calced ()
    {
        enforce( isCalced, "The scalar isn't calculated." );
        return _calculated;
    }

    float calc ( ScalarUnitBase base = ScalarUnitBase() )
    {
        final switch ( _unit ) with ( ScalarUnit )
        {
            case None, Auto:
                _calculated = base.default_;
                break;
            case Pixel:
                _calculated = _value;
                break;
            case MilliMetre:
                _calculated = base.mm*_value;
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

    void alter ( float v, bool force = false )
    {
        if ( isSpecified && !force ) {
            import std.stdio;
            "Tried to alter the specified value.".writeln; // TODO
            return;
        }
        _calculated = v;
    }
}
