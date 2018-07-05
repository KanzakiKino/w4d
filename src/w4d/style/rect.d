// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module w4d.style.rect;
import w4d.style.exception,
       w4d.style.scalar,
       w4d.style.templates;
import g4d.math.vector;

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

struct Rect
{
    @("attr") {
        Scalar top    = Scalar.Auto,
               right  = Scalar.Auto,
               bottom = Scalar.Auto,
               left   = Scalar.Auto;
    }

    this ( Scalar[] args... )
    {
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
        } else {
            throw new StyleException( "Args length is too many to initialize Rect." );
        }
    }

    mixin AttributesUtilities;

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
