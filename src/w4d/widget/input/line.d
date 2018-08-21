// Written in the D programming language.
/++
 + Authors: KanzakiKino
 + Copyright: KanzakiKino 2018
 + License: LGPL-3.0
++/
module w4d.widget.input.line;
import w4d.parser.colorset,
       w4d.style.rect,
       w4d.style.scalar,
       w4d.task.window,
       w4d.util.clipping,
       w4d.util.textline,
       w4d.widget.button,
       w4d.widget.text,
       w4d.event,
       w4d.exception;
import g4d.element.shape.rect,
       g4d.ft.font,
       g4d.glfw.cursor,
       g4d.shader.base;
import gl3n.linalg;
import std.algorithm,
       std.conv,
       std.math,
       std.range;

/// A handler that handles chainging text.
alias TextChangeHandler = EventHandler!( void, dstring );

/// A widget of line input.
class LineInputWidget : TextWidget
{
    protected TextLine _line;
    protected float    _cursorPos;
    protected float    _scrollLength;
    protected float    _selectionLength;

    override @property dstring text () { return _line.text; }

    protected dchar    _passwordChar;
    /// Character of password filed.
    @property passwordChar () { return _passwordChar; }
    /// Sets character of password field.
    /// Deprecated: This method causes heavy method (loadText).
    deprecated @property void passwordChar ( dchar c )
    {
        _passwordChar = c;
        loadText(text);
    }
    /// Checks if the line input is password field.
    @property isPasswordField ()
    {
        return _passwordChar != dchar.init;
    }

    protected RectElement _cursorElm;
    protected RectElement _selectionElm;

    protected ButtonWidget _chainedButton;

    ///
    TextChangeHandler onTextChange;

    ///
    override bool handleMouseMove ( vec2 pos )
    {
        if ( super.handleMouseMove( pos ) ) {
            return true;
        }
        if ( isTracked ) {
            _line.moveCursorTo( retrieveIndexFromAbsPos( pos.x ), true );
            return true;
        }
        return false;
    }
    ///
    override bool handleMouseButton ( MouseButton btn, bool status, vec2 pos )
    {
        if ( super.handleMouseButton( btn, status, pos ) ) {
            return true;
        }
        if ( btn == MouseButton.Left && status ) {
            auto selecting = _context.shift && isFocused;
            _line.moveCursorTo( retrieveIndexFromAbsPos( pos.x ), selecting );
            focus();
            return true;
        }
        return false;
    }
    ///
    override bool handleKey ( Key key, KeyState status )
    {
        if ( super.handleKey( key, status ) ) return true;

        const pressing = ( status != KeyState.Release );

        if ( key == Key.Backspace && pressing ) {
            _line.backspace();

        } else if ( key == Key.Delete && pressing ) {
            _line.del();

        } else if ( key == Key.Left && pressing ) {
            _line.left( _context.shift );
        } else if ( key == Key.Right && pressing ) {
            _line.right( _context.shift );
        } else if ( key == Key.Home && pressing ) {
            _line.home( _context.shift );
        } else if ( key == Key.End && pressing ) {
            _line.end( _context.shift );

        } else if ( key == Key.A && pressing && _context.ctrl ) {
            _line.selectAll();
        } else if ( key == Key.D && pressing && _context.ctrl ) {
            _line.deselect();
            requestRedraw();

        } else if ( key == Key.C && pressing && _context.ctrl ) {
            Window.setClipboard( _line.selectedText );
        } else if ( key == Key.V && pressing && _context.ctrl ) {
            _line.insert( Window.getClipboard() );

        } else if ( key == Key.Enter && pressing ) {
            if ( _chainedButton ) {
                _chainedButton.onButtonPress.call();
            }

        } else {
            return false;
        }
        return true;
    }

    ///
    override bool handleTextInput ( dchar c )
    {
        if ( super.handleTextInput(c) ) return true;

        _line.insert( c.to!dstring );
        return true;
    }

    ///
    override void handleFocused ( bool status )
    {
        if ( !status ) {
            _line.deselect();
            requestRedraw();
        }
        super.handleFocused( status );
    }

    ///
    override @property const(Cursor) cursor ()
    {
        return Cursor.IBeam;
    }

    ///
    this ()
    {
        super();

        _line            = new TextLine;
        _cursorPos       = 0;
        _scrollLength    = 0;
        _selectionLength = 0;

        _cursorElm    = new RectElement;
        _selectionElm = new RectElement;

        _chainedButton = null;

        _line.onTextChange = ( dstring v ) {
            loadText(v);
        };
        _line.onCursorMove = ( long i ) {
            _cursorPos    = retrievePosFromIndex(i);
            _scrollLength = retrieveScrollLength();
            updateSelectionRect();
            requestRedraw();
        };

        parseColorSetsFromFile!"colorset/lineinput.yaml"( style );
        style.box.size.width  = Scalar.None;
        style.box.borderWidth = Rect( 1.pixel );
        style.box.paddings    = Rect( 1.mm );
        style.box.margins     = Rect(1.mm);
    }

    protected @property lineHeight ()
    {
        enforce( _font, "Font is not specified." );
        return _font.size.y;
    }

    protected long retrieveIndexFromAbsPos ( float pos )
    {
        const r_pos = pos - style.clientLeftTop.x + _scrollLength;
        return retrieveIndexFromPos( r_pos );
    }
    protected long retrieveIndexFromPos ( float pos )
    {
        foreach ( i,poly; _textElm.polys ) {
            const border = vec2(poly.pos).x + poly.length/2;
            if ( border >= pos ) {
                return i;
            }
        }
        return _text.length;
    }
    protected float retrievePosFromIndex ( long i )
    {
        i = i.clamp( 0, _line.text.length );

        if ( i == 0 ) {
            return 0;
        } else if ( i == _text.length ) {
            auto poly = _textElm.polys[$-1];
            return vec2(poly.pos).x + poly.length;
        } else {
            return vec2(_textElm.polys[i.to!size_t].pos).x;
        }
    }

    /// Changes the character of password field.
    void changePasswordChar ( dchar c = dchar.init )
    {
        _passwordChar = c;
        loadText( text );
    }
    ///
    override void loadText ( dstring text, FontFace font = null )
    {
        auto display = text;
        if ( isPasswordField ) {
            display = passwordChar.
                repeat( text.length ).to!dstring;
        }
        super.loadText( display, font );

        _line.setText( text );
        onTextChange.call( text );

        if ( font ) {
            style.box.size.height = lineHeight.pixel;
            _cursorElm.resize( vec2(1,lineHeight) );
        }
    }

    /// Locks editing.
    void lock ()
    {
        _line.lock();
    }
    /// Unlocks editing.
    void unlock ()
    {
        _line.unlock();
    }

    /// Chains the button.
    /// Chained button will be handled when Enter is pressed.
    void chainButton ( ButtonWidget btn )
    {
        _chainedButton = btn;
    }

    protected float retrieveScrollLength ()
    {
        auto size = style.box.clientSize;
        if ( _scrollLength >= _cursorPos ) {
            auto index = max( _line.cursorIndex-1, 0 );
            return retrievePosFromIndex(index);

        } else if ( _scrollLength+size.x <= _cursorPos ) {
            auto index = min( _line.cursorIndex+1, _line.text.length );
            return retrievePosFromIndex(index) - size.x;
        }
        return _scrollLength;
    }
    protected void updateSelectionRect ()
    {
        if ( !_line.isSelecting ) return;

        const selectionPos = retrievePosFromIndex( _line.selectionIndex );
        const newLength    = _cursorPos - selectionPos;
        if ( newLength == _selectionLength ) return;

        _selectionLength = newLength;

        const size = vec2( _selectionLength.abs, lineHeight );
        _selectionElm.resize( size );
    }

    protected override void drawText ( Window w )
    {
        auto pos = style.box.
            borderInsideLeftTop + style.translate;
        w.clip.pushRect( pos, style.box.borderInsideSize );

        super.drawText( w );
        if ( isFocused ) {
            drawCursor( w );
        }
        if ( _line.isSelecting ) {
            drawSelectionRect( w );
        }

        w.clip.popRect();
    }
    protected void drawCursor ( Window w )
    {
        auto  shader = w.shaders.fill3;
        const saver  = ShaderStateSaver( shader );
        auto  late   = vec2(_cursorPos, lineHeight/2);
        late       += style.clientLeftTop;

        shader.use();
        shader.matrix.late = vec3( late, 0 );
        shader.color = colorset.foreground;
        _cursorElm.draw( shader );
    }
    protected void drawSelectionRect ( Window w )
    {
        auto  shader = w.shaders.fill3;
        const saver  = ShaderStateSaver( shader );
        auto  late   = vec2(_cursorPos, lineHeight/2);
        late       += style.clientLeftTop;
        late.x     -= _selectionLength/2;

        shader.use();
        shader.matrix.late = vec3( late, 0 );
        shader.color = colorset.border;
        _selectionElm.draw( shader );
    }

    ///
    override @property bool trackable () { return true; }
    ///
    override @property bool focusable () { return true; }
}
