// Written in the D programming language.
/++
 + Authors: KanzakiKino
 + Copyright: KanzakiKino 2018
 + License: LGPL-3.0
++/
module w4d.widget.mdi.host;
import w4d.layout.placer.fill,
       w4d.layout.fill,
       w4d.style.color,
       w4d.style.widget,
       w4d.task.window,
       w4d.widget.base,
       w4d.exception;
import gl3n.linalg;
import std.algorithm,
       std.array;

/// A host widget for MDI.
class MdiHostWidget : Widget
{
    protected MdiClient[] _clients;
    /// Child clients.
    @property clients () { return _clients; }

    ///
    override @property Widget[] children ()
    {
        return _clients.map!"a.widget".array;
    }

    ///
    this ()
    {
        super();
        setLayout!( FillLayout, FillPlacer );

        _clients = [];
    }

    /// Adds the client widget.
    void addClient ( MdiClient cli )
    {
        enforce( cli, "The client is invalid." );
        cli.setHost( this );
        _clients ~= cli;
        infectWindowContext();

        unfocusAllClients();
        cli.widget.status.focused = true;
        requestRedraw();
    }
    /// Removes the client widget.
    void removeClient ( MdiClient cli )
    {
        _context.forget( cli.widget );
        _clients = _clients.remove!( x => x is cli );
        requestRedraw();
    }

    protected void unfocusAllClients ()
    {
        foreach ( cli; _clients ) {
            cli.widget.status.focused = false;
        }
    }
    /// Focuses to the client.
    void focusClient ( MdiClient cli )
    {
        enforce( cli, "The client is invalid." );
        removeClient( cli );
        addClient( cli );
        requestRedraw();
    }

    ///
    override vec2 layout ( vec2 basept, vec2 parentSize )
    {
        return super.layout( basept, parentSize );
    }

    ///
    override void draw ( Window w, in ColorSet parent )
    {
        auto leftTop = style.translate +
            style.box.borderInsideLeftTop;

        w.clip.pushRect( leftTop,
                style.box.borderInsideSize );
        super.draw( w, parent );
        w.clip.popRect();
    }
}

/// An interface of clients for MDI..
interface MdiClient
{
    /// Position of the client.
    @property vec2 pos  ();
    /// Size of the client.
    @property vec2 size ();

    /// This property returns thiself that is casted to Widget.
    /// To prove the casting is safe.
    @property Widget widget ();

    /// Changes the host widget.
    void setHost ( MdiHostWidget );
}
