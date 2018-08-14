// Written in the D programming language.
/++
 + Authors: KanzakiKino
 + Copyright: KanzakiKino 2018
 + License: LGPL-3.0
++/
module w4d.style.rect;
import w4d.style.exception,
       w4d.style.scalar,
       w4d.style.templates;
import gl3n.linalg;

///
unittest
{
    auto rc = Rect( Scalar(50f,ScalarUnit.Percent) );
    rc.calc( vec2(300f,200f) );
    assert( rc.isRelative );
    assert( rc.isCalced );
    assert( rc.top   .calced == 100f );
    assert( rc.right .calced == 150f );
    assert( rc.bottom.calced == 100f );
    assert( rc.left  .calced == 150f );
}

/// A style data of each sides' width.
struct Rect
{
    /// A preset of rectangle that all sides are not specified.
    enum None = Rect( Scalar.None, Scalar.None, Scalar.None, Scalar.None );
    /// A preset of rectangle that all sides are specified as auto.
    enum Auto = Rect( Scalar.Auto, Scalar.Auto, Scalar.Auto, Scalar.Auto );

    @("attr") {
        /// Top side.
        Scalar top    = Scalar.None;
        /// Right side.
        Scalar right  = Scalar.None;
        /// Bottom side.
        Scalar bottom = Scalar.None;
        /// Left side.
        Scalar left   = Scalar.None;
    }

    /// Order of arguments is the same to CSS.
    this ( Scalar[] args... )
    {
        enforce( args.length <= 4, "Args are too many to initialize Rect." );

        if ( args.length == 1 ) {
            top    = args[0];
            right  = args[0];
            bottom = args[0];
            left   = args[0];
        } else if ( args.length == 2 ) {
            top    = args[0];
            right  = args[1];
            bottom = args[0];
            left   = args[1];
        } else if ( args.length == 3 ) {
            top    = args[0];
            right  = args[1];
            bottom = args[2];
            left   = args[1];
        } else if ( args.length == 4 ) {
            top    = args[0];
            right  = args[1];
            bottom = args[2];
            left   = args[3];
        }
    }

    mixin AttributesUtilities;

    /// Calculates all relative values.
    void calc ( vec2 parentSize, vec2 def = vec2(0,0) )
    {
        const xBase = ScalarUnitBase( def.x, parentSize.x );
        const yBase = ScalarUnitBase( def.y, parentSize.y );

        top   .calc( yBase );
        right .calc( xBase );
        bottom.calc( yBase );
        left  .calc( xBase );
    }
}
