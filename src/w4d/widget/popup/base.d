// Written in the D programming language.
/++
 + Authors: KanzakiKino
 + Copyright: KanzakiKino 2018
 + License: LGPL-3.0
++/
module w4d.widget.popup.base;
import w4d.widget.base,
       w4d.widget.panel,
       w4d.widget.root,
       w4d.exception;
import gl3n.linalg;

/// A base widget of popup.
class PopupWidget : RootWidget
{
    /// WindowContext of the popup target.
    protected WindowContext _objectContext;

    protected vec2 _pos, _size;

    ///
    override void handlePopup ( bool opened, WindowContext w )
    {
        if ( opened ) {
            _objectContext = w;
        } else {
            _objectContext.requestRedraw();
            _objectContext = null;
        }
    }

    ///
    this ()
    {
        super();
        _objectContext = null;

        _pos  = vec2(0,0);
        _size = vec2(0,0);
    }

    /// Moves the popup to the pos and resize to the size.
    void move ( vec2 pos, vec2 size )
    {
        _pos  = pos;
        _size = size;
        requestLayout();
    }
    /// Closes the popup.
    void close ()
    {
        enforce( _objectContext,
                "The popup is not opened yet." );
        _objectContext.setPopup( null );
    }

    ///
    override vec2 layout ( vec2 rootlt, vec2 rootsz )
    {
        .Widget.layout( _pos, _size );

        const rootrb = rootlt + rootsz;

        const lt = style.translate;
        const rb = lt + style.box.collisionSize;

        auto late = vec2(0,0);
        if ( lt.x < rootlt.x ) {
            late.x = rootlt.x - lt.x;
        } else if ( rb.x > rootrb.x ) {
            late.x = rootrb.x - rb.x;
        }
        if ( lt.y < rootlt.y ) {
            late.y = rootlt.y - lt.y;
        } else if ( rb.y > rootrb.y ) {
            late.y = rootrb.y - rb.y;
        }

        style.shift( late );
        shiftChildren( late );
        return vec2(0,0);
    }
}
