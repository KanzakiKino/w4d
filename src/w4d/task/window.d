// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino.
module w4d.task.window;
import w4d.util.clipping,
       w4d.util.tuple,
       w4d.app,
       w4d.event,
       w4d.exception;
static import g4d;
import g4d.math.matrix,
       g4d.math.vector;

alias WindowHint  = g4d.WindowHint;
alias MouseButton = g4d.MouseButton;
alias Key         = g4d.Key;
alias KeyState    = g4d.KeyState;

class Window : g4d.Window, Task
{
    protected Shaders _shaders;
    @property shaders () { return _shaders; }

    protected ClipRect _clip;
    @property clip () { return _clip; }

    protected vec2 _origin;
    @property origin () { return _origin; }

    protected WindowContent _root;
    protected vec2          _cursorPos;

    this ( WindowContent root, vec2i size, string text, WindowHint hint = WindowHint.None )
    {
        enforce(                     root, "Main content is NULL." );
        enforce( size.x > 0 && size.y > 0, "Window size is invalid." );

        super( size, text, hint );

        _shaders   = new Shaders;
        _clip  = new ClipRect( shaders.fill3 );
        _origin    = vec2(0,0);
        _root      = root;
        _cursorPos = vec2(0,0);

        handler.onWindowResize = delegate ( vec2i sz )
        {
            recalcMatrix();
            _root.resize( sz );
        };
        handler.onMouseEnter = delegate ( bool entered )
        {
            _root.handleMouseEnter( entered, _cursorPos );
        };
        handler.onMouseMove = delegate ( vec2 pos )
        {
            _cursorPos = pos;
            _root.handleMouseMove( pos );
        };
        handler.onMouseButton = delegate ( MouseButton btn, bool status )
        {
            _root.handleMouseButton( btn, status, _cursorPos );
        };
        handler.onMouseScroll = delegate ( vec2 amount )
        {
            _root.handleMouseScroll( amount, _cursorPos );
        };
        handler.onKey = delegate ( Key key, KeyState state )
        {
            _root.handleKey( key, state );
        };
        handler.onCharacter = delegate ( dchar c )
        {
            _root.handleTextInput( c );
        };

        handler.onWindowResize( size );
    }

    protected void recalcMatrix ()
    {
        auto half = vec2(size)/2;
        auto late = origin - half;

        auto proj = mat4.orthographic( -half.x,half.x, -half.y,half.y, short.min,short.max )*
            mat4.translate( late.x, late.y, 0 );

        foreach ( s; shaders.list ) {
            s.projection = proj;
        }
    }

    void moveOrigin ( vec2 pos )
    {
        _origin = pos;
        recalcMatrix();
    }

    override bool exec ( App app )
    {
        if ( alive ) {
            if ( _root.needRedraw ) {
                resetFrame();
                _root.draw( this );
                applyFrame();
            }
            return false;
        }
        return true;
    }
}

// One Shaders class is for only one Window.
class Shaders
{
    @("shader") {
        protected g4d.RGBA3DShader  _rgba3;
        protected g4d.Alpha3DShader _alpha3;
        protected g4d.Fill3DShader  _fill3;
    }

    static foreach ( name; __traits(allMembers,typeof(this)) ) {
        static if ( "shader".isIn( __traits(getAttributes,mixin(name)) ) ) {
            mixin( "@property "~name[1..$]~"() { return "~name~"; }" );
        }
    }

    // Call the constructor while a context of the objective window is active.
    this ()
    {
        static foreach ( name; __traits(allMembers,typeof(this)) ) {
            static if ( "shader".isIn( __traits(getAttributes,mixin(name)) ) ) {
                mixin( name~"= new typeof("~name~");" );
            }
        }
    }

    // Returns list of all shaders.
    @property list ()
    {
        import g4d.shader.base;
        Shader[] result;

        static foreach ( name; __traits(allMembers,typeof(this)) ) {
            static if ( "shader".isIn( __traits(getAttributes,mixin(name)) ) ) {
                mixin( "result ~= "~name~";" );
            }
        }
        return result;
    }
}

interface WindowContent
{
    // Some handlers return whether event was handled.

    // Be called with true when cursor is entered.
    bool handleMouseEnter ( bool, vec2 );
    // Be called when cursor is moved.
    bool handleMouseMove ( vec2 );
    // Be called when mouse button is clicked.
    bool handleMouseButton ( MouseButton, bool, vec2 );
    // Be called when mouse wheel is rotated.
    bool handleMouseScroll ( vec2, vec2 );

    // Be called when key is pressed, repeated or released.
    bool handleKey ( Key, KeyState );
    // Be called when focused and text was inputted.
    bool handleTextInput ( dchar );

    @property bool needRedraw ();

    void resize ( vec2i );
    void draw   ( Window );
}
