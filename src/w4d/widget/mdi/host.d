// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module w4d.widget.mdi.host;
import w4d.widget.mdi.layout,
       w4d.widget.base,
       w4d.exception;
import g4d.math.vector;
import std.algorithm,
       std.array;

class MdiHostWidget : Widget
{
    MdiClient[] _clients;
    @property clients () { return _clients; }

    override @property Widget[] children ()
    {
        return _clients.map!"a.widget".array;
    }

    this ()
    {
        super();
        setLayout!MdiLayout();

        _clients = [];
    }

    void addClient ( MdiClient cli )
    {
        enforce( cli, "The client is invalid." );
        cli.setHost( this );
        _clients ~= cli;
    }
    void removeClient ( MdiClient cli )
    {
        _context.forget( cli.widget );
        _clients = _clients.remove!( x => x is cli );
    }

    void focusClient ( MdiClient cli )
    {
        enforce( cli, "The client is invalid." );
        removeClient( cli );
        addClient( cli );
    }
}

interface MdiClient
{
    @property vec2 pos  ();
    @property vec2 size ();

    // This method returns thiself that is casted to Widget.
    // To prove the casting is safe.
    @property Widget widget ();

    void setHost ( MdiHostWidget );
}
