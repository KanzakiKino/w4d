// Written under LGPL-3.0 in the D programming laguage.
// Copyright 2018 KanzakiKino
module w4d.util.vector;
import gl3n.linalg;

ref getLength ( bool Horizon, V ) ( return ref V vec )
{
    static if ( Horizon ) {
        return vec.x;
    } else {
        return vec.y;
    }
}

ref getWeight ( bool Horizon, V ) ( ref V vec )
{
    return vec.getLength!(!Horizon);
}
