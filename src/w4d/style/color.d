// Written in the D programming language.
/++
 + Authors: KanzakiKino
 + Copyright: KanzakiKino 2018
 + License: LGPL-3.0
++/
module w4d.style.color;
import w4d.style.exception;
import gl3n.linalg;

/// A collection of color configurations.
struct ColorSet
{
    protected vec4[string] _colors;

    ///
    inout vec4 opIndex ( string v )
    {
        enforce( v in _colors );
        return _colors[v];
    }
    ///
    void opIndexAssign ( vec4 col, string v )
    {
        _colors[v] = col;
    }

    ///
    inout vec4 opDispatch ( string v ) ()
    {
        return this[v];
    }

    /// Copies the unspecified colors from parent.
    void inherit ( in ColorSet parent )
    {
        foreach ( key,val; parent._colors ) {
            if ( key !in _colors ) {
                _colors[key] = val;
            }
        }
    }
}
