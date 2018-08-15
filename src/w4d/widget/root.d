// Written in the D programming language.
/++
 + Authors: KanzakiKino
 + Copyright: KanzakiKino 2018
 + License: LGPL-3.0
++/
module w4d.widget.root;
import w4d.parser.colorset,
       w4d.style.color,
       w4d.task.window,
       w4d.widget.base,
       w4d.widget.panel;
import g4d.glfw.cursor;
import gl3n.linalg;

/// A widget to be placed root of all widgets.
class RootWidget : PanelWidget
{
    ///
    override @property const(Cursor) cursor ()
    {
        auto popup = _context.popup;
        return popup? popup.cursor: super.cursor;
    }

    ///
    this ()
    {
        super();
        _context = new WindowContext;

        parseColorSetsFromFile!"colorset/root.yaml"( style );
    }

    ///
    override @property bool needLayout ()
    {
        auto popup = _context.popup;
        return (popup && popup.needLayout) || super.needLayout;
    }
    ///
    override void layout ( vec2i size )
    {
        super.layout( size );

        auto popup = _context.popup;
        if ( popup ) {
            popup.layout( style.clientLeftTop, style.box.clientSize );
        }
    }

    ///
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
    ///
    override void draw ( Window w, in ColorSet parent )
    {
        super.draw( w, parent );
        drawPopup( w );
    }
}
