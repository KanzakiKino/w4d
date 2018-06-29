// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module w4d.event;
import w4d.exception;

unittest
{
    auto handler = EventHandler!( bool, string )();
    handler = delegate ( string mes )
    {
        return mes == "world";
    };

    assert( !handler.call( "hello" ) );
    assert(  handler.call( "world" ) );
}

struct EventHandler ( ReturnType, Args... )
{
    alias Handler = ReturnType delegate ( Args );

    protected Handler _handler = null;

    void opAssign ( Handler rhs )
    {
        if ( _handler ) {
            throw new W4dException( "Tried to overwrite the handler." );
        }
        _handler = rhs;
    }

    auto call ( Args args )
    {
        static if ( is(ReturnType==void) ) {
            if ( _handler ) _handler( args );
        } else {
            if ( _handler ) return _handler( args );
            return ReturnType.init;
        }
    }
}
