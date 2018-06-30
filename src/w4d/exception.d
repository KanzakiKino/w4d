// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module w4d.exception;
static import std.exception;

alias enforce(T=W4dException) = std.exception.enforce!T;

class W4dException : Exception
{
    this ( string mes, string file = __FILE__, size_t line = __LINE__ )
    {
        super( mes, file, line );
    }
}
