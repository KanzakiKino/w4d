// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module w4d.style.color;
import g4d.math.vector;

struct ColorSet
{
    protected vec4[string] _colors;

    ref vec4 opDispatch ( string v ) ()
    {
        if ( v !in _colors ) {
            _colors[v] = vec4(0,0,0,0);
        }
        return _colors[v];
    }

    void inherit ( ColorSet parent )
    {
        foreach ( key,val; parent._colors ) {
            if ( key !in _colors ) {
                _colors[key] = val;
            }
        }
    }
}
