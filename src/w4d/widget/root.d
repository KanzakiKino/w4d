// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module w4d.widget.root;
import w4d.task.window,
       w4d.widget.base,
       w4d.widget.panel;
import g4d.glfw.cursor,
       g4d.math.vector;

class RootWidget : PanelWidget
{
    override @property Cursor cursor ()
    {
        auto popup = _context.popup;
        return popup? popup.cursor: super.cursor;
    }

    this ()
    {
        super();
        _context = new WindowContext;
    }

    override @property bool needLayout ()
    {
        auto popup = _context.popup;
        return (popup && popup.needLayout) || super.needLayout;
    }
    override void layout ( vec2i size )
    {
        super.layout( size );

        auto popup = _context.popup;
        if ( popup ) {
            popup.layout( style.clientLeftTop, style.box.clientSize );
        }
    }

    override @property bool needRedraw ()
    {
        auto popup = _context.popup;
        return (popup && popup.needRedraw) || super.needRedraw;
    }
    protected void drawPopup ( Window w )
    {
        auto popup = _context.popup;
        if ( !popup ) return;

        popup.draw( w );
    }
    override void draw ( Window w )
    {
        super.draw( w );
        drawPopup( w );
    }
}
