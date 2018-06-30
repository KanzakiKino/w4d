// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino.
module w4d.task.window;
import w4d.app,
       w4d.event,
       w4d.exception;
static import g4d;
import g4d.math.vector;

alias WindowHint = g4d.WindowHint;

class Window : g4d.Window, Task
{
    protected WindowContent _root;

    this ( WindowContent root, vec2i size, string text, WindowHint hint = WindowHint.None )
    {
        enforce(                     root, "Main content is NULL." );
        enforce( size.x > 0 && size.y > 0, "Window size is invalid." );

        super( size, text, hint );
        _root = root;

        handler.onFbResize = delegate ( vec2i sz )
        {
            clip( vec2i(0,0), sz );
        };
        handler.onMouseEnter = delegate ( bool entered )
        {
            _root.handleMouseEnter( entered );
        };
        handler.onMouseMove = delegate ( vec2 pos )
        {
            _root.handleMouseMove( pos );
        };
    }

    override bool exec ( App app )
    {
        if ( alive ) {
            resetFrame();
            scope(success) applyFrame();

            _root.draw( this );
            return false;
        }
        return true;
    }
}

interface WindowContent
{
    // Be called with true when cursor is entered.
    void handleMouseEnter ( bool );
    // Be called when cursor is moved.
    void handleMouseMove ( vec2 );

    void draw ( Window );
}
