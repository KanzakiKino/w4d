// Written in the D programming language.
/++
 + Authors: KanzakiKino
 + Copyright: KanzakiKino 2018
 + License: LGPL-3.0
++/
module w4d.exception;
static import std.exception;

/// A template of enforce function.
alias enforce(T=W4dException) = std.exception.enforce!T;

/// An exception type used in all w4d modules.
class W4dException : Exception
{
    ///
    this ( string mes, string file = __FILE__, size_t line = __LINE__ )
    {
        super( mes, file, line );
    }
}
