// Written in the D programming language.
/++
 + Authors: KanzakiKino
 + Copyright: KanzakiKino 2018
 + License: LGPL-3.0
++/
module w4d.widget.base.status;
import w4d.style.widget,
       w4d.event;
import std.string,
       std.uni;

alias StatusChangeHandler = EventHandler!( void, WidgetState, bool );

struct WidgetStatus
{
    protected uint _flags;
    const @property flags () { return _flags; }

    StatusChangeHandler onChangeStatus;

    void enable ( WidgetState state )
    {
        _flags |= state;
        onChangeStatus.call( state, true );
    }

    void disable ( WidgetState state )
    {
        _flags &= ~state;
        onChangeStatus.call( state, false );
    }

    static foreach ( name; __traits(allMembers,WidgetState) ) {
        mixin(q{
            const @property bool $LOWER_NAME ()
            {
                return !!(_flags & WidgetState.$NAME);
            }
            @property void $LOWER_NAME ( bool e )
            {
                (e? &enable: &disable)( WidgetState.$NAME );
            }
        }.
        replace( "$LOWER_NAME", name.toLower ).
        replace( "$NAME", name ) );
    }
}
