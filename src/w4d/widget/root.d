// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module w4d.widget.root;
import w4d.task.window,
       w4d.widget.base,
       w4d.widget.panel;
import g4d.math.vector;

class RootWidget : PanelWidget
{
    this ()
    {
        super();
        _context = new WindowContext;
    }

    protected void drawPopup ( Window w )
    {
        auto popup = _context.popup;
        if ( !popup ) return;

        if ( popup.needLayout ) {
            popup.layout( style.clientLeftTop, style.box.clientSize );
        }
        popup.draw( w );
    }

    override void draw ( Window w )
    {
        super.draw( w );
        drawPopup( w );
    }
}
