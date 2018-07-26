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

    protected bool _locked;
    const @property isLocked () { return _locked; }

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
        _locked         = false;
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

        if ( !selecting ) {
            _selectionIndex = -1;
        }
        if ( temp != _cursorIndex ) {
            onCursorMove.call( _cursorIndex );
        }
    }
    // relatively
    void moveCursor ( long i, bool selecting = false )
    {
        moveCursorTo( _cursorIndex+i, selecting );
    }
    void left ( bool selecting )
    {
        moveCursor( -1, selecting );
    }
    void right ( bool selecting )
    {
        moveCursor( 1, selecting );
    }
    void home ( bool selecting )
    {
        moveCursorTo( 0, selecting );
    }
    void end ( bool selecting )
    {
        moveCursorTo( _text.length, selecting );
    }

    protected @property leftText ()
    {
        auto index = _cursorIndex;
        if ( isSelecting ) {
            index = min( _cursorIndex, _selectionIndex );
        }
        return _text[0 .. index.to!size_t];
    }
    protected @property rightText ()
    {
        auto index = _cursorIndex;
        if ( isSelecting ) {
            index = max( _cursorIndex, _selectionIndex );
        }
        return _text[index.to!size_t .. $];
    }

    void insert ( dstring v )
    {
        setText( leftText ~v~ rightText );
        moveCursor( v.length );
    }
    void backspace ()
    {
        if ( isSelecting ) {
            removeSelecting();
            return;
        }
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
        if ( isSelecting ) {
            removeSelecting();
            return;
        }
        auto left  = leftText;
        auto right = rightText;

        if ( right.length ) {
            right = right[1..$];
            setText( left~right );
        }
    }

    void removeSelecting ()
    {
        if ( !isSelecting ) return;

        long cursorMove = 0;
        if ( _cursorIndex > _selectionIndex ) {
            cursorMove = -(_cursorIndex-_selectionIndex);
        }
        setText( leftText ~ rightText );

        moveCursor( cursorMove );
    }
    void selectAll ()
    {
        moveCursorTo( 0 );
        moveCursorTo( _text.length, true );
    }
    void deselect ()
    {
        moveCursor( 0 );
        // This method doesn't call onCursorMove.
        // So requstRedraw won't be called.
    }

    void setText ( dstring v )
    {
        if ( !_locked && _text != v ) {
            deselect();
            _text = v;
            onTextChange.call( v );
        }
    }

    void lock ()
    {
        _locked = true;
    }
    void unlock ()
    {
        _locked = false;
    }
}
