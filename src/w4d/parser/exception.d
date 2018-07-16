// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module w4d.parser.exception;
static import w4d.exception;

alias enforce = w4d.exception.enforce!ParsingException;

class ParsingException : w4d.exception.W4dException
{
    this ( string mes, string file = __FILE__, size_t line = __LINE__ )
    {
        super( mes, file, line );
    }
}
