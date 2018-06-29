// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino.
module w4d.task.window;
import w4d.app,
       w4d.event;
static import g4d;
import g4d.math.vector;

alias WindowHint = g4d.WindowHint;

class Window : g4d.Window, Task
{
    WindowContent root;

    this ( vec2i size, string text, WindowHint hint = WindowHint.None )
    {
        super( size, text, hint );

        handler.onFbResize = delegate ( vec2i sz )
        {
            clip( vec2i(0,0), sz );
        };
        handler.onMouseEnter = delegate ( bool entered )
        {
            if ( root ) root.onMouseEnter.call( entered );
        };
    }

    override bool exec ( App app )
    {
        if ( alive ) {
            resetFrame();
            scope(success) applyFrame();

            // Draw something.
            return false;
        }
        return true;
    }
}

// void delegate ( bool entered, vec2i pos );
alias MouseEnterHandler = EventHandler!( void, bool );
// void delegate ( vec2i cursorpos );
alias MouseMoveHandler  = EventHandler!( void, vec2i );

abstract class WindowContent
{
    MouseEnterHandler  onMouseEnter;
    MouseMoveHandler   onMouseMove;;
}
