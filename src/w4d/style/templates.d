// Written in the D programming language.
/++
 + Authors: KanzakiKino
 + Copyright: KanzakiKino 2018
 + License: LGPL-3.0
++/
module w4d.style.templates;

/// A template of utilities for a collection of scalar.
template AttributesUtilities ()
{
    import w4d.util.tuple;
    import std.algorithm;

    // FIXME: I don't know how to fix these spaghettis.

    const @property isAuto ()
    {
        static foreach ( name; __traits(allMembers,typeof(this)) ) {
            static if ( !__traits(compiles,__traits(getAttributes,mixin(name))) ) {
            } else static if ( "attr".isIn( __traits(getAttributes,mixin(name)) ) ) {
                if ( mixin(name).isAuto ) return true;
            }
        }
        return false;
    }
    const @property bool isRelative ()
    {
        static foreach ( name; __traits(allMembers,typeof(this)) ) {
            static if ( !__traits(compiles,__traits(getAttributes,mixin(name))) ) {
            } else static if ( "attr".isIn( __traits(getAttributes,mixin(name)) ) ) {
                if ( mixin(name).isRelative ) return true;
            }
        }
        return false;
    }
    const @property isAbsolute ()
    {
        return !isRelative;
    }
    const @property isCalced ()
    {
        static foreach ( name; __traits(allMembers,typeof(this)) ) {
            static if ( !__traits(compiles,__traits(getAttributes,mixin(name))) ) {
            } else static if ( "attr".isIn( __traits(getAttributes,mixin(name)) ) ) {
                if ( !mixin(name).isCalced ) return false;
            }
        }
        return true;
    }
}
