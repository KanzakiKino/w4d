// Written in the D programming language.
/++
 + Authors: KanzakiKino
 + Copyright: KanzakiKino 2018
 + License: LGPL-3.0
++/
module w4d.widget.base.mouse;

/// A template that declares methods related to Mouse.
template Mouse ()
{
    protected Widget _hovered;

    protected void setHovered ( Widget child, vec2 pos )
    {
        auto temp = _hovered;
        _hovered = child;

        if ( child !is temp ) {
            if ( temp  ) temp .handleMouseEnter( false, pos );
            if ( child ) child.handleMouseEnter(  true, pos );
        }
    }

    @property const(Cursor) cursor ()
    {
        return _hovered? _hovered.cursor: Cursor.Arrow;
    }


    @property isTracked ()
    {
        return _context && _context.tracked is this;
    }
    @property bool trackable ()
    {
        return true;
    }
    void track ()
    {
        if ( trackable ) {
            enforce( _context, "WindowContext is null." );
            _context.setTracked( this );
        }
    }
    void refuseTrack ()
    {
        enforce( isTracked, "The widget has not been tracked." );
        _context.setTracked( null );
    }


    bool handleMouseEnter ( bool entered, vec2 pos )
    {
        if ( _context.tracked && !isTracked ) {
            return true;
        }

        if ( entered ) {
            enableState( WidgetState.Hovered );
        } else {
            setHovered( null, pos );
            disableState( WidgetState.Hovered );
        }
        return false;
    }

    bool handleMouseMove ( vec2 pos )
    {
        if ( !isTracked ) {
            if ( _context.tracked ) {
                _context.tracked.handleMouseMove( pos );
                return true;
            } else if ( auto target = findChildAt(pos) ) {
                setHovered( target, pos );
                if ( target.handleMouseMove( pos ) ) {
                    return true;
                }
            } else {
                setHovered( null, pos );
            }
        }
        return false;
    }

    bool handleMouseButton ( MouseButton btn, bool status, vec2 pos )
    {
        if ( !isTracked ) {
            if ( _context.tracked ) {
                _context.tracked.handleMouseButton( btn, status, pos );
                return true;
            } else if ( auto target = findChildAt(pos) ) {
                if ( target.handleMouseButton( btn, status, pos ) ) {
                    return true;
                }
                if ( _context.tracked ) {
                    return true;
                }
            }
        }

        if ( btn == MouseButton.Left && status ) {
            enableState( WidgetState.Pressed );
            track();
            focus();
        } else if ( btn == MouseButton.Left && !status ) {
            if ( isTracked ) refuseTrack();
            disableState( WidgetState.Pressed );
        }
        return false;
    }

    bool handleMouseScroll ( vec2 amount, vec2 pos )
    {
        if ( !isTracked ) {
            if ( _context.tracked ) {
                _context.tracked.handleMouseScroll( amount, pos );
                return true;
            } else if ( auto target = findChildAt(pos) ) {
                if ( target.handleMouseScroll( amount, pos ) ) {
                    return true;
                }
            }
        }
        return false;
    }

    void handleTracked ( bool a )
    {
        (a? &enableState: &disableState)( WidgetState.Tracked );
    }
}
