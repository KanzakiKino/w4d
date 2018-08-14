// Written in the D programming language.
/++
 + Authors: KanzakiKino
 + Copyright: KanzakiKino 2018
 + License: LGPL-3.0
++/
module w4d.util.tuple;
public import std.typecons;

///
unittest
{
    assert( "hello".isIn( tuple("hello", "world") ) );
    assert( !"hello".isIn() );
}

/// Checks if needle is in haystack.
/// Tuples in haystack will be expanded.
bool isIn ( T1, Args... ) ( T1 needle, Args haystack )
{
    foreach ( v; haystack ) {
        static if ( isTuple!(typeof(v)) ) {
            if ( needle.isIn( v.expand ) ) return true;
        } else static if ( __traits(compiles, v == needle ) ) {
            if ( v == needle ) return true;
        }
    }
    return false;
}
