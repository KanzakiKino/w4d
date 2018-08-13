// Written in the D programming language.
/++
 + Authors: KanzakiKino
 + Copyright: KanzakiKino 2018
 + License: LGPL-3.0
++/
module w4d.style.scalar;
import w4d.style.exception;
import std.math;

///
unittest
{
    auto sc = 50.percent; // 50%
    assert( sc.calc( ScalarUnitBase(100f,10f) ) == 5f );
}

/// Converts float to Scalar(pixel).
@property pixel ( float n )
{
    return Scalar( n, ScalarUnit.Pixel );
}
/// Converts float to Scalar(inch).
@property inch ( float n )
{
    return Scalar( n, ScalarUnit.Inch );
}
/// Converts float to Scalar(millimetres).
@property mm ( float n )
{
    return Scalar( n, ScalarUnit.MilliMetre );
}
/// Converts float to Scalar(%).
@property percent ( float n )
{
    return Scalar( n, ScalarUnit.Percent );
}

/// An enum of units scalar supports.
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

/// An information of base for relative units.
struct ScalarUnitBase
{
    /// This value can be used if none/auto is specified.
    float default_ = 0;
    /// Value of the parent.
    float percent  = 0;

    /// Pixel per millimetres.
    static float mm   = 0;
    /// Pixel per inch.
    static float inch = 0;
}

/// A scalar data that converts relative values to pixel.
struct Scalar
{
    /// A scalar that is specified as None.
    enum None = Scalar(0,ScalarUnit.None);
    /// A scalar that is specified as Auto.
    enum Auto = Scalar(0,ScalarUnit.Auto);

    protected float      _value = 0;
    protected ScalarUnit _unit  = ScalarUnit.None;

    protected float _calculated;

    ///
    const @property isNone ()
    {
        return _unit == ScalarUnit.None;
    }
    ///
    const @property isAuto ()
    {
        return _unit == ScalarUnit.Auto;
    }

    ///
    const @property isAbsolute ()
    {
        return _unit <= ScalarUnit.Inch && !isNone && !isAuto;
    }
    ///
    const @property isRelative ()
    {
        return _unit >= ScalarUnit.Percent;
    }
    ///
    const @property isSpecified ()
    {
        return isAbsolute || isRelative;
    }

    ///
    const @property isCalced ()
    {
        return !isNaN(_calculated);
    }
    /// Calculated value.
    const @property calced ()
    {
        enforce( isCalced, "The scalar isn't calculated." );
        return _calculated;
    }

    /// Calculates the scalar using unit base.
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

    /// Alters the scalar.
    /// Altering the explicitly specified scalar is not preferred.
    void alter ( float v, bool force = false )
    {
        if ( isSpecified && !force ) {
            import std.stdio: writeln;
            "Tried to alter the specified value.".writeln; // TODO
            return;
        }
        _calculated = v;
    }
}
