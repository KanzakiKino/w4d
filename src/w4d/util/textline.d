// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module w4d.util.textline;
import w4d.event;
import std.algorithm,
       std.conv;

alias TextChangeHandler = EventHandler!( void, dstring );
alias CursorMoveHandler = EventHandler!( void, long );

class TextLine
{
    TextChangeHandler onTextChange;
    CursorMoveHandler onCursorMove;

    protected dstring _text;
    const @property text () { return _text; }

    protected long _cursorIndex;
    const @property cursorIndex () { return _cursorIndex; }

    protected long _selectionIndex;
    const @property selectionIndex () { return _selectionIndex; }

    const @property isSelecting ()
    {
        return _selectionIndex >= 0 && _selectionIndex != _cursorIndex;
    }

    this ()
    {
        _text           = ""d;
        _cursorIndex    = 0;
        _selectionIndex = 0;
    }

    // absolutely
    void moveCursorTo ( long i, bool selecting = false )
    {
        if ( selecting && !isSelecting ) {
            _selectionIndex = _cursorIndex;
        }
        auto temp = _cursorIndex;
        _cursorIndex = i.clamp( 0, _text.length );

        if ( temp != _cursorIndex ) {
            onCursorMove.call( _cursorIndex );
        }
    }
    // relatively
    void moveCursor ( long i, bool selecting = false )
    {
        moveCursorTo( _cursorIndex+i, selecting );
    }
    void left ()
    {
        moveCursor( -1 );
    }
    void right ()
    {
        moveCursor( 1 );
    }

    protected @property leftText ()
    {
        return _text[0 .. _cursorIndex.to!size_t];
    }
    protected @property rightText ()
    {
        return _text[_cursorIndex.to!size_t .. $];
    }

    void insert ( dstring v )
    {
        setText( leftText ~v~ rightText );
        moveCursor( v.length );
    }
    void backspace ()
    {
        auto left  = leftText;
        auto right = rightText;

        if ( left.length ) {
            left = left[0..$-1];
            setText( left~right );
            moveCursor( -1 );
        }
    }
    void del ()
    {
        auto left  = leftText;
        auto right = rightText;

        if ( right.length ) {
            right = right[1..$];
            setText( left~right );
        }
    }

    void setText ( dstring v )
    {
        if ( _text != v ) {
            deselect();
            _text = v;
            onTextChange.call( v );
        }
    }

    void deselect ()
    {
        _selectionIndex = -1;
    }
}
