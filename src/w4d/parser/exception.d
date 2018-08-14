// Written in the D programming language.
/++
 + Authors: KanzakiKino
 + Copyright: KanzakiKino 2018
 + License: LGPL-3.0
++/
module w4d.parser.exception;
static import w4d.exception;

/// A template of enforce function.
alias enforce = w4d.exception.enforce!ParsingException;

/// An exception type used in parser modules.
class ParsingException : w4d.exception.W4dException
{
    ///
    this ( string mes, string file = __FILE__, size_t line = __LINE__ )
    {
        super( mes, file, line );
    }
}
