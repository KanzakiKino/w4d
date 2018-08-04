// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module w4d.widget.base.keyboard;

template Keyboard ()
{
    protected Widget _focusChain;
    @property focusChain () { return _focusChain; }

    void setFocusChain ( Widget w )
    {
        if ( w ) {
            enforce( w.focusable,
                    "Cannot chain the unfocusable widget." );
            _focusChain = w;
        } else {
            _focusChain = null;
        }
    }

    bool pullFocusChain ()
    {
        if ( _focusChain && isFocused ) {
            _context.setFocused( _focusChain );
            return true;
        }
        return false;
    }


    @property isFocused ()
    {
        return _context && _context.focused is this;
    }
    @property bool focusable ()
    {
        return true;
    }
    void focus ()
    {
        if ( focusable ) {
            enforce( _context, "WindowContext is null." );
            _context.setFocused( this );
        }
    }
    void dropFocus ()
    {
        enforce( isFocused, "The widget has not been focused." );
        _context.setFocused( null );
    }


    bool handleKey ( Key key, KeyState status )
    {
        if ( !isFocused ) {
            if ( _context.focused ) {
                return _context.focused.handleKey( key, status );
            } else if ( children.canFind!(x => x.handleKey( key, status )) ) {
                return true;
            }
        }

        auto pressing = status != KeyState.Release;
        if ( key == Key.LeftShift ) {
            _context.setModkeyStatus( Modkey.Shift, pressing );
        } else if ( key == Key.LeftControl ) {
            _context.setModkeyStatus( Modkey.Ctrl, pressing );

        } else if ( key == Key.Tab && pressing ) {
            return pullFocusChain();
        }
        return false;
    }

    bool handleTextInput ( dchar c )
    {
        if ( _context.focused && !isFocused ) {
            return _context.focused.handleTextInput( c );
        }
        return false;
    }

    void handleFocused ( bool a )
    {
        (a? &enableState: &disableState)( WidgetState.Focused );
    }
}
