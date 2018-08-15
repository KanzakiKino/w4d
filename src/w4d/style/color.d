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
class ColorSet
{
    protected vec4[string] _colors;

    ///
    this ( in ColorSet src )
    {
        foreach ( k,v; src._colors ) {
            _colors[k] = v;
        }
    }
    ///
    this ()
    {
        _colors.clear();
    }

    /// Copyies the colorset.
    const ColorSet copy ()
    {
        return new ColorSet( this );
    }

    /// Clears all color specifications.
    void clear ()
    {
        _colors.clear();
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
}
