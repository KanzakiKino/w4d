// Written in the D programming language.
/++
 + Authors: KanzakiKino
 + Copyright: KanzakiKino 2018
 + License: LGPL-3.0
++/
module w4d.task.window;
import w4d.style.scalar,
       w4d.util.clipping,
       w4d.util.tuple,
       w4d.app,
       w4d.event,
       w4d.exception;
import g4d.glfw.lib;
static import g4d;
import gl3n.linalg;

///
alias WindowHint  = g4d.WindowHint;
///
alias MouseButton = g4d.MouseButton;
///
alias Key         = g4d.Key;
///
alias KeyState    = g4d.KeyState;

/// A window to place widgets.
class Window : g4d.Window, Task
{
    protected static void retrieveDisplayConfig ()
    {
        auto  mon = enforce!glfwGetPrimaryMonitor();
        const mod = enforce!glfwGetVideoMode( mon );

        int mm_x = 0, mm_y = 0; // millimetres
        enforce!glfwGetMonitorPhysicalSize( mon, &mm_x, &mm_y );

        ScalarUnitBase.mm   = mod.width*1f / mm_x;
        ScalarUnitBase.inch = mod.width*1f / mm_x / 25.4f;
    }

    protected Shaders _shaders;
    /// A collection of shader.
    @property shaders () { return _shaders; }

    protected ClipRect _clip;
    /// ClipRect utility object.
    @property clip () { return _clip; }

    protected WindowContent _root;
    protected vec2          _cursorPos;

    ///
    this ( vec2i size, string text, WindowHint hint = WindowHint.None )
    {
        enforce( size.x > 0 && size.y > 0, "Window size is invalid." );

        super( size, text, hint );
        retrieveDisplayConfig();

        _shaders    = new Shaders;
        _clip       = new ClipRect( shaders.fill3 );
        _root       = null;
        _cursorPos  = vec2(0,0);

        g4d.ColorBuffer.enableBlend();
        g4d.DepthBuffer.disable();

        handler.onWindowResize = delegate ( vec2i sz )
        {
            enforce( _root, "Content is null." );
            recalcMatrix();
            _root.layout( sz );
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
    }

    /// Sets contents(widget).
    /// This method can be called only once.
    void setContent ( WindowContent content )
    {
        enforce( !_root, "Content is already setted." );
        _root = content;
        handler.onWindowResize( size );
    }

    protected void recalcMatrix ()
    {
        auto half = vec2( size ) / 2;
        auto late = half * -1;

        const orth = mat4.orthographic( -half.x,half.x,
                half.y,-half.y, short.min,short.max );

        const proj = orth * mat4.translation( vec3( late, 0 ) );

        foreach ( s; shaders.list ) {
            s.matrix.projection = proj;
        }
    }

    /// Makes contexts current,
    /// And clears color and depth buffer.
    /// Warnings: Stencil buffer won't be cleared.
    override void resetFrame ()
    {
        super.resetFrame();
        g4d.ColorBuffer.clear();
        g4d.DepthBuffer.clear();
    }

    /// Updates window.
    /// This method must be called by App object.
    override bool exec ( App app )
    {
        enforce( _root, "Content is null." );

        if ( alive ) {
            if ( _root.needLayout ) {
                _root.layout( size );
            }
            if ( _root.needRedraw ) {
                resetFrame();
                _root.draw( this );
                applyFrame();
            }
            cursor = _root.cursor;
            return false;
        }
        return true;
    }
}

/// A struct of shader collection.
/// One Shaders class is for only one Window.
class Shaders
{
    @("shader") {
        protected g4d.RGBA3DShader  _rgba3;
        protected g4d.Alpha3DShader _alpha3;
        protected g4d.Fill3DShader  _fill3;
    }

    /// FIXME: IDK how to fix these fucking codes.

    static foreach ( name; __traits(allMembers,typeof(this)) ) {
        static if ( "shader".isIn( __traits(getAttributes,mixin(name)) ) ) {
            mixin( "@property "~name[1..$]~"() { return "~name~"; }" );
        }
    }

    ///
    this ()
    {
        static foreach ( name; __traits(allMembers,typeof(this)) ) {
            static if ( "shader".isIn( __traits(getAttributes,mixin(name)) ) ) {
                mixin( name~"= new typeof("~name~");" );
            }
        }
    }

    /// List of all shaders.
    @property list ()
    {
        import g4d.shader.base: Shader;
        Shader[] result;

        static foreach ( name; __traits(allMembers,typeof(this)) ) {
            static if ( "shader".isIn( __traits(getAttributes,mixin(name)) ) ) {
                mixin( "result ~= "~name~";" );
            }
        }
        return result;
    }
}

/// An interface that objects placed in Window must inherit.
/// Some handlers return true if event was handled.
interface WindowContent
{

    /// Be called with true when cursor is entered.
    bool handleMouseEnter ( bool, vec2 );
    /// Be called when cursor is moved.
    bool handleMouseMove ( vec2 );
    /// Be called when mouse button is clicked.
    bool handleMouseButton ( MouseButton, bool, vec2 );
    /// Be called when mouse wheel is rotated.
    bool handleMouseScroll ( vec2, vec2 );

    /// Be called when key is pressed, repeated or released.
    bool handleKey ( Key, KeyState );
    /// Be called when focused and text was inputted.
    bool handleTextInput ( dchar );

    /// Current cursor.
    @property const(g4d.Cursor) cursor ();

    /// Checks if the contents need window size.
    @property bool needLayout ();
    /// Checks if the contents need redrawing.
    @property bool needRedraw ();

    /// Be called with size of Window when needLayout is true.
    void layout ( vec2i );
    /// Be called when needRedraw is true.
    void draw   ( Window );
}
