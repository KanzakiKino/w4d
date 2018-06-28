// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module w4d.exception;

class W4dException : Exception
{
    this ( string mes, string file = __FILE__, int line = __LINE__ )
    {
        super( mes, file, line );
    }
}
