// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module w4d.widget.mdi.host;
import w4d.style.widget,
       w4d.task.window,
       w4d.widget.mdi.layout,
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

        unfocusAllClients();
        cli.widget.enableState( WidgetState.Focused );
    }
    void removeClient ( MdiClient cli )
    {
        _context.forget( cli.widget );
        _clients = _clients.remove!( x => x is cli );
    }

    protected void unfocusAllClients ()
    {
        foreach ( cli; _clients ) {
            cli.widget.disableState( WidgetState.Focused );
        }
    }
    void focusClient ( MdiClient cli )
    {
        enforce( cli, "The client is invalid." );
        removeClient( cli );
        addClient( cli );
    }

    override @property bool needLayout ()
    {
        return _needLayout;
    }
    void layoutQuickly ()
    {
        auto pos  = style.clientLeftTop;
        auto size = style.box.clientSize;

        children.filter!"a.needLayout"().
            each!( x => x.layout(pos,size) );
    }

    override void draw ( Window w )
    {
        layoutQuickly();

        w.clip.pushRect( style.box.borderInsideLeftTop,
                style.box.borderInsideSize );
        super.draw( w );
        w.clip.popRect();
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
