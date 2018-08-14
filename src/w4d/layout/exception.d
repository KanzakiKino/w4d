// Written in the D programming language.
/++
 + Authors: KanzakiKino
 + Copyright: KanzakiKino 2018
 + License: LGPL-3.0
++/
module w4d.layout.exception;
static import w4d.exception;

/// A template of enforce function.
alias enforce(T=LayoutException) = w4d.exception.enforce!T;

/// An exception type used in layout modules.
class LayoutException : w4d.exception.W4dException
{
    ///
    this ( string mes, string file = __FILE__, size_t line = __LINE__ )
    {
        super( mes, file, line );
    }
}
