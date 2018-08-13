// Written in the D programming language.
/++
 + Authors: KanzakiKino
 + Copyright: KanzakiKino 2018
 + License: LGPL-3.0
++/
module w4d.event;
import w4d.exception;

///
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

/// A struct of handler that handles the events.
struct EventHandler ( ReturnType, Args... )
{
    /// Delegate type.
    alias Handler = ReturnType delegate ( Args );

    protected Handler _handler = null;

    /// Sets the handler delegate.
    void opAssign ( Handler rhs )
    {
        enforce( !_handler, "Tried to overwrite the handler." );
        _handler = rhs;
    }

    /// Calls the handler.
    const auto call ( Args args )
    {
        static if ( is(ReturnType==void) ) {
            if ( _handler ) _handler( args );
        } else {
            if ( _handler ) return _handler( args );
            return ReturnType.init;
        }
    }
}
