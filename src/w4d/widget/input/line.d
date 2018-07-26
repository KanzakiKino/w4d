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
       std.conv;

alias TextChangeHandler = EventHandler!( void, dstring );

class LineInputWidget : TextWidget
{
    protected TextLine _line;
    protected float    _cursorPos;
    protected float    _scrollLength;

    protected RectElement _cursorElm;

    TextChangeHandler onTextChange;

    override bool handleMouseButton ( MouseButton btn, bool status, vec2 pos )
    {
        if ( super.handleMouseButton( btn, status, pos ) ) {
            return true;
        }
        if ( btn == MouseButton.Left && status ) {
            focus();
            auto r_pos = pos.x - style.clientLeftTop.x + _scrollLength;
            _line.moveCursorTo( retrieveIndexFromPos( r_pos ) );
            return true;
        }
        return false;
    }
    override bool handleKey ( Key key, KeyState status )
    {
        if ( super.handleKey( key, status ) ) return true;

        auto pressing = ( status != KeyState.Release );

        if ( key == Key.Backspace && pressing ) {
            _line.backspace();

        } else if ( key == Key.Delete && pressing ) {
            _line.del();

        } else if ( key == Key.Left && pressing ) {
            _line.left();

        } else if ( key == Key.Right && pressing ) {
            _line.right();

        } else {
            return false;
        }
        return true;
    }

    override bool handleTextInput ( dchar c )
    {
        _line.insert( c.to!dstring );
        return true;
    }

    this ()
    {
        super();

        _line         = new TextLine;
        _cursorPos    = 0;
        _scrollLength = 0;

        _cursorElm = new RectElement;

        _line.onTextChange = ( dstring v ) {
            loadText(v);
        };
        _line.onCursorMove = ( long i ) {
            _cursorPos    = retrievePosFromIndex(i);
            _scrollLength = retrieveScrollLength();
            requestRedraw();
        };

        style.box.borderWidth = Rect( Scalar(1,ScalarUnit.Pixel) );
        style.box.paddings    = Rect( Scalar(5,ScalarUnit.Pixel) );
        parseThemeFromFile!"theme/focusable.yaml"( style );
    }

    protected @property lineHeight ()
    {
        enforce( _font, "Font is not specified." );
        return _font.size.y;
    }

    protected long retrieveIndexFromPos ( float pos /+ relative +/ )
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
            style.box.size.height = Scalar( lineHeight, ScalarUnit.Pixel );
            _cursorElm.resize( vec2(1,lineHeight) );
        }
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

    protected override void drawText ( Window w )
    {
        auto late = vec2(-_scrollLength,0);

        w.clip.pushRect( style.box.borderInsideLeftTop,
                style.box.borderInsideSize );
        w.moveOrigin( w.origin + late );

        super.drawText( w );
        if ( isFocused ) {
            drawCursor( w );
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
}
