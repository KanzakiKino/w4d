// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module w4d.widget.input.line;
import w4d.parser.theme,
       w4d.style.rect,
       w4d.style.scalar,
       w4d.task.window,
       w4d.util.clipping,
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
    protected size_t _cursorIndex;
    protected float  _cursorPos;
    protected float  _scrollLength;

    protected RectElement _cursorElm;

    TextChangeHandler onTextChanged;

    override bool handleMouseButton ( MouseButton btn, bool status, vec2 pos )
    {
        if ( super.handleMouseButton( btn, status, pos ) ) {
            return true;
        }
        if ( btn == MouseButton.Left && status ) {
            focus();
            auto r_pos = pos.x - style.clientLeftTop.x + _scrollLength;
            moveCursor( retrieveIndexFromPos( r_pos ) );
            return true;
        }
        return false;
    }

    override bool handleTextInput ( dchar c )
    {
        appendTextAtCursor( c.to!dstring );
        return true;
    }

    this ()
    {
        super();

        _cursorIndex  = 0;
        _cursorPos    = 0;
        _scrollLength = 0;

        _cursorElm = new RectElement;

        style.box.borderWidth = Rect( Scalar(1,ScalarUnit.Pixel) );
        style.box.paddings    = Rect( Scalar(5,ScalarUnit.Pixel) );
        parseThemeFromFile!"theme/focusable.yaml"( style );
    }

    protected @property lineHeight ()
    {
        enforce( _font, "Font is not specified." );
        return _font.size.y;
    }
    protected @property leftText ()
    {
        if ( isFocused ) {
            return _text[0.._cursorIndex];
        }
        return _text;
    }
    protected @property rightText ()
    {
        if ( isFocused ) {
            return _text[_cursorIndex..$];
        }
        return ""d;
    }

    protected size_t retrieveIndexFromPos ( float pos /+ relative +/ )
    {
        foreach ( i,poly; _textElm.polys ) {
            auto border = vec2(poly.pos).x + poly.length/2;
            if ( border >= pos ) {
                return i;
            }
        }
        return _text.length;
    }
    protected float retrievePosFromIndex ( size_t i )
    {
        enforce( i <= _text.length, "Index is too big." );

        if ( i == _text.length ) {
            auto poly = _textElm.polys[$-1];
            return vec2(poly.pos).x + poly.length;
        } else {
            return vec2(_textElm.polys[i].pos).x;
        }
    }

    protected void appendTextAtCursor ( dstring v )
    {
        enforce( isFocused, "Currently not focused." );
        loadText( leftText ~v~ rightText );

        moveCursor( _cursorIndex + v.length );
    }
    override void loadText ( dstring v, FontFace font = null )
    {
        super.loadText( v, font );
        onTextChanged.call( v );

        if ( font ) {
            style.box.size.height = Scalar( lineHeight, ScalarUnit.Pixel );
            _cursorElm.resize( vec2(1,lineHeight) );
        }
    }

    protected void moveCursor ( size_t i )
    {
        _cursorIndex  = min( i, _text.length );
        _cursorPos    = retrievePosFromIndex( _cursorIndex );
        _scrollLength = retrieveScrollLength();
    }
    protected float retrieveScrollLength ()
    {
        auto size = style.box.clientSize;
        if ( _scrollLength >= _cursorPos ) {
            auto index = max( _cursorIndex.to!int-1, 0 ).to!size_t;
            return retrievePosFromIndex(index);

        } else if ( _scrollLength+size.x <= _cursorPos ) {
            auto index = min( _cursorIndex+1, _text.length );
            return retrievePosFromIndex(index);
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
