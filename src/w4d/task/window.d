// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino.
module w4d.task.window;
import w4d.app,
       w4d.event,
       w4d.exception;
static import g4d;
import g4d.math.vector;

alias WindowHint  = g4d.WindowHint;
alias MouseButton = g4d.MouseButton;
alias Key         = g4d.Key;
alias KeyState    = g4d.KeyState;

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
            _root.resize( sz );
        };
        handler.onMouseEnter = delegate ( bool entered )
        {
            _root.handleMouseEnter( entered );
        };
        handler.onMouseMove = delegate ( vec2 pos )
        {
            _root.handleMouseMove( pos );
        };
        handler.onMouseButton = delegate ( MouseButton btn, bool status )
        {
            _root.handleMouseButton( btn, status );
        };
        handler.onMouseScroll = delegate ( vec2 amount )
        {
            _root.handleMouseScroll( amount );
        };
        handler.onKey = delegate ( Key key, KeyState state )
        {
            _root.handleKey( key, state );
        };
        handler.onCharacter = delegate ( dchar c )
        {
            _root.handleTextInput( c );
        };
    }

    override void clip ( vec2i pt, vec2i sz )
    {
        super.clip( pt, sz );
        // TODO
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
    // Some handlers return whether event was handled.

    // Be called with true when cursor is entered.
    void handleMouseEnter ( bool );
    // Be called when cursor is moved.
    bool handleMouseMove ( vec2 );
    // Be called when mouse button is clicked.
    bool handleMouseButton ( MouseButton, bool );
    // Be called when mouse wheel is rotated.
    bool handleMouseScroll ( vec2 );

    // Be called when key is pressed, repeated or released.
    bool handleKey ( Key, KeyState );
    // Be called when focused and text was inputted.
    bool handleTextInput ( dchar );

    void resize ( vec2i );
    void draw   ( Window );
}
