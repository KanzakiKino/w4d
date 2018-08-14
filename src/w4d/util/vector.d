// Written in the D programming language.
/++
 + Authors: KanzakiKino
 + Copyright: KanzakiKino 2018
 + License: LGPL-3.0
++/
module w4d.util.vector;
import gl3n.linalg;

/// If Horizon is true, returns x, else, returns y.
ref getLength ( bool Horizon, V ) ( return ref V vec )
{
    static if ( Horizon ) {
        return vec.x;
    } else {
        return vec.y;
    }
}

/// If Horizon is true, returns y, else, returns x.
ref getWeight ( bool Horizon, V ) ( ref V vec )
{
    return vec.getLength!(!Horizon);
}
