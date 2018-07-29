// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module w4d.widget.input.line;
import w4d.parser.theme,
       w4d.style.rect,
       w4d.style.scalar,
       w4d.task.window,
       w4d.util.clipping,
       w4d.util.textline,
       w4d.widget.text,
       w4d.event,
       w4d.exception;
import g4d.element.shape.rect,
       g4d.ft.font,
       g4d.math.vector,
       g4d.shader.base;
import std.algorithm,
       std.conv,
       std.math;

alias TextChangeHandler = EventHandler!( void, dstring );

class LineInputWidget : TextWidget
{
    protected TextLine _line;
    protected float    _cursorPos;
    protected float    _scrollLength;
    protected float    _selectionLength;

    protected RectElement _cursorElm;
    protected RectElement _selectionElm;

    protected bool _shift, _ctrl;

    TextChangeHandler onTextChange;

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
    override bool handleMouseButton ( MouseButton btn, bool status, vec2 pos )
    {
        if ( super.handleMouseButton( btn, status, pos ) ) {
            return true;
        }
        if ( btn == MouseButton.Left && status ) {
            auto selecting = _shift && isFocused;
            _line.moveCursorTo( retrieveIndexFromAbsPos( pos.x ), selecting );
            focus();
            return true;
        }
        return false;
    }
    override bool handleKey ( Key key, KeyState status )
    {
        if ( super.handleKey( key, status ) ) return true;

        auto pressing = ( status != KeyState.Release );

        if ( key == Key.LeftShift ) {
            _shift = pressing;
        } else if ( key == Key.LeftControl ) {
            _ctrl = pressing;

        } else if ( key == Key.Backspace && pressing ) {
            _line.backspace();

        } else if ( key == Key.Delete && pressing ) {
            _line.del();

        } else if ( key == Key.Left && pressing ) {
            _line.left( _shift );
        } else if ( key == Key.Right && pressing ) {
            _line.right( _shift );
        } else if ( key == Key.Home && pressing ) {
            _line.home( _shift );
        } else if ( key == Key.End && pressing ) {
            _line.end( _shift );

        } else if ( key == Key.A && pressing && _ctrl ) {
            _line.selectAll();
        } else if ( key == Key.D && pressing && _ctrl ) {
            _line.deselect();
            requestRedraw();

        } else {
            return false;
        }
        return true;
    }

    override bool handleTextInput ( dchar c )
    {
        if ( super.handleTextInput(c) ) return true;

        _line.insert( c.to!dstring );
        return true;
    }

    override void handleFocused ( bool status )
    {
        if ( !status ) {
            _line.deselect();
            requestRedraw();
        }
        super.handleFocused( status );
    }

    this ()
    {
        super();

        _line            = new TextLine;
        _cursorPos       = 0;
        _scrollLength    = 0;
        _selectionLength = 0;

        _cursorElm    = new RectElement;
        _selectionElm = new RectElement;

        _line.onTextChange = ( dstring v ) {
            loadText(v);
        };
        _line.onCursorMove = ( long i ) {
            _cursorPos    = retrievePosFromIndex(i);
            _scrollLength = retrieveScrollLength();
            updateSelectionRect();
            requestRedraw();
        };

        style.box.borderWidth = Rect( 1.pixel );
        style.box.paddings    = Rect( 2.mm );
        parseThemeFromFile!"theme/focusable.yaml"( style );
    }

    protected @property lineHeight ()
    {
        enforce( _font, "Font is not specified." );
        return _font.size.y;
    }

    protected long retrieveIndexFromAbsPos ( float pos )
    {
        auto r_pos = pos - style.clientLeftTop.x + _scrollLength;
        return retrieveIndexFromPos( r_pos );
    }
    protected long retrieveIndexFromPos ( float pos )
    {
        foreach ( i,poly; _textElm.polys ) {
            auto border = vec2(poly.pos).x + poly.length/2;
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
            return vec2(_textElm.polys[i].pos).x;
        }
    }

    override void loadText ( dstring v, FontFace font = null )
    {
        super.loadText( v, font );

        _line.setText( v );
        onTextChange.call( v );

        if ( font ) {
            style.box.size.height = lineHeight.pixel;
            _cursorElm.resize( vec2(1,lineHeight) );
        }
    }

    void lock ()
    {
        _line.lock();
    }
    void unlock ()
    {
        _line.unlock();
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

        auto selectionPos = retrievePosFromIndex( _line.selectionIndex );
        auto newLength    = _cursorPos - selectionPos;
        if ( newLength == _selectionLength ) return;

        _selectionLength = newLength;

        auto size = vec2( _selectionLength.abs, lineHeight );
        _selectionElm.resize( size );
    }

    protected override void drawText ( Window w )
    {
        auto late = vec2(-_scrollLength,0);

        auto pos = style.box.
            borderInsideLeftTop + style.translate;
        w.clip.pushRect( pos, style.box.borderInsideSize );
        w.moveOrigin( w.origin + late );

        super.drawText( w );
        if ( isFocused ) {
            drawCursor( w );
        }
        if ( _line.isSelecting ) {
            drawSelectionRect( w );
        }

        w.clip.popRect();
        w.moveOrigin( w.origin - late );
    }
    protected void drawCursor ( Window w )
    {
        auto shader = w.shaders.fill3;
        auto saver  = ShaderStateSaver( shader );
        auto late   = vec2(_cursorPos, lineHeight/2);
        late       += style.clientLeftTop;

        shader.use( false );
        shader.setVectors( vec3(late,0) );
        shader.color = colorset.fgColor;
        _cursorElm.draw( shader );
    }
    protected void drawSelectionRect ( Window w )
    {
        auto shader = w.shaders.fill3;
        auto saver  = ShaderStateSaver( shader );
        auto late   = vec2(_cursorPos, lineHeight/2);
        late       += style.clientLeftTop;
        late.x     -= _selectionLength/2;

        shader.use( false );
        shader.setVectors( vec3(late,0) );
        shader.color = colorset.borderColor;
        _selectionElm.draw( shader );
    }
}
