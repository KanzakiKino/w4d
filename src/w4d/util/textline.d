// Written in the D programming language.
/++
 + Authors: KanzakiKino
 + Copyright: KanzakiKino 2018
 + License: LGPL-3.0
++/
module w4d.util.textline;
import w4d.event;
import std.algorithm,
       std.conv;

/// A handler of chainging text.
alias TextChangeHandler = EventHandler!( void, dstring );
/// A handler of cursor moving.
alias CursorMoveHandler = EventHandler!( void, long );

/// An object of editable text.
class TextLine
{
    ///
    TextChangeHandler onTextChange;
    ///
    CursorMoveHandler onCursorMove;

    protected dstring _text;
    /// Current text.
    const @property text () { return _text; }

    protected bool _locked;
    /// Checks if editing is locked.
    const @property isLocked () { return _locked; }

    protected long _cursorIndex;
    /// Index of cursor.
    const @property cursorIndex () { return _cursorIndex; }

    protected long _selectionIndex;
    /// Index that selection is beginning.
    const @property selectionIndex () { return _selectionIndex; }

    /// Checks if text is selected.
    const @property isSelecting ()
    {
        return _selectionIndex >= 0 && _selectionIndex != _cursorIndex;
    }

    ///
    this ()
    {
        _text           = ""d;
        _locked         = false;
        _cursorIndex    = 0;
        _selectionIndex = 0;
    }

    /// Moves cursor to absolute index.
    void moveCursorTo ( long i, bool selecting = false )
    {
        if ( selecting && !isSelecting ) {
            _selectionIndex = _cursorIndex;
        }
        const temp = _cursorIndex;
        _cursorIndex = i.clamp( 0, _text.length );

        if ( !selecting ) {
            _selectionIndex = -1;
        }
        if ( temp != _cursorIndex ) {
            onCursorMove.call( _cursorIndex );
        }
    }
    /// Moves cursor to relative index.
    void moveCursor ( long i, bool selecting = false )
    {
        moveCursorTo( _cursorIndex+i, selecting );
    }
    /// Moves cursor to left.
    void left ( bool selecting )
    {
        moveCursor( -1, selecting );
    }
    /// Moves cursor to right.
    void right ( bool selecting )
    {
        moveCursor( 1, selecting );
    }
    /// Moves cursor to home.
    void home ( bool selecting )
    {
        moveCursorTo( 0, selecting );
    }
    /// Moves cursor to end.
    void end ( bool selecting )
    {
        moveCursorTo( _text.length, selecting );
    }

    const @property leftText ()
    {
        long index = _cursorIndex;
        if ( isSelecting ) {
            index = min( _cursorIndex, _selectionIndex );
        }
        return _text[0 .. index.to!size_t];
    }
    const @property rightText ()
    {
        long index = _cursorIndex;
        if ( isSelecting ) {
            index = max( _cursorIndex, _selectionIndex );
        }
        return _text[index.to!size_t .. $];
    }
    const @property dstring selectedText ()
    {
        if ( !isSelecting ) return ""d;

        long left  = _cursorIndex;
        long right = _selectionIndex;
        if ( left > right ) {
            swap( left, right );
        }
        return _text[left .. right];
    }

    /// Inserts text at cursor.
    void insert ( dstring v )
    {
        if ( isLocked ) return;

        setText( leftText ~v~ rightText );
        moveCursor( v.length );
    }
    /// Removes a left char of cursor.
    void backspace ()
    {
        if ( isLocked ) return;

        if ( isSelecting ) {
            removeSelecting();
            return;
        }
        auto left  = leftText;
        auto right = rightText;

        if ( left.length ) {
            left = left[0..$-1];
            moveCursor( -1 );
            setText( left~right );
        }
    }
    /// Removes a right char of cursor.
    void del ()
    {
        if ( isLocked ) return;

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

    /// Removes the selected text.
    void removeSelecting ()
    {
        if ( !isSelecting || isLocked ) return;

        long cursorMove = 0;
        if ( _cursorIndex > _selectionIndex ) {
            cursorMove = -(_cursorIndex-_selectionIndex);
        }
        setText( leftText ~ rightText );

        moveCursor( cursorMove );
    }
    /// Sets all text selected.
    void selectAll ()
    {
        moveCursorTo( 0 );
        moveCursorTo( _text.length, true );
    }
    ///
    void deselect ()
    {
        moveCursor( 0 );
        // This method doesn't call onCursorMove.
        // So requstRedraw won't be called.
    }

    /// Changes text.
    void setText ( dstring v )
    {
        if ( _text != v ) {
            deselect();
            _text = v;
            moveCursor(0);
            onTextChange.call( v );
        }
    }

    /// Locks editing.
    void lock ()
    {
        _locked = true;
    }
    /// Unlocks editing.
    void unlock ()
    {
        _locked = false;
    }
}
