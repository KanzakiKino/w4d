// Written under LGPL-3.0 in the D programming laguage.
// Copyright 2018 KanzakiKino
module w4d.util.vector;
import g4d.math.vector;

ref lengthRef ( bool Horizon, V ) ( ref V vec )
    if ( isVector!V )
{
    static if ( Horizon ) {
        return vec.x;
    } else {
        return vec.y;
    }
}

auto length ( bool Horizon, V ) ( V vec )
{
    return vec.lengthRef!Horizon;
}
