// Written in the D programming language.
/++
 + Authors: KanzakiKino
 + Copyright: KanzakiKino 2018
 + License: LGPL-3.0
++/
module w4d.style.size;
import w4d.style.scalar,
       w4d.style.templates;
import gl3n.linalg;

///
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

/// A style data of size.
struct Size
{
    /// A size data that is specified as None.
    enum None = Size( Scalar.None, Scalar.None );
    /// A size data that is specified as Auto.
    enum Auto = Size( Scalar.Auto, Scalar.Auto );

    @("attr") {
        /// A scalar of width.
        Scalar width  = Scalar.None;
        /// A scalar of height.
        Scalar height = Scalar.None;
    }

    mixin AttributesUtilities;

    /// Converts to vec2.
    /// An exception will be thrown if width or height have not been calculated.
    const @property vector ()
    {
        return vec2( width.calced, height.calced );
    }

    /// Calculates size using parentSize and defaultSize.
    void calc ( vec2 parentSize, vec2 def = vec2(0,0) )
    {
        width .calc( ScalarUnitBase( def.x, parentSize.x ) );
        height.calc( ScalarUnitBase( def.y, parentSize.y ) );
    }
}
