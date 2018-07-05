// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module w4d.style.templates;

template AttributesUtilities ()
{
    import w4d.util.tuple;

    @property bool isRelative ()
    {
        static foreach ( name; __traits(allMembers,typeof(this)) ) {
            static if ( !__traits(compiles,__traits(getAttributes,mixin(name))) ) {
            } else static if ( "attr".isIn( __traits(getAttributes,mixin(name)) ) ) {
                if ( mixin(name).isRelative ) return true;
            }
        }
        return false;
    }
    @property isAbsolute ()
    {
        return !isRelative;
    }
    @property isCalced ()
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
