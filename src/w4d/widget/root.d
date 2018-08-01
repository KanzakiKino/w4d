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

    override void draw ( Window w )
    {
        super.draw( w );
    }
}
