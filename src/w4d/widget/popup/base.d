// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module w4d.widget.popup.base;
import w4d.widget.base,
       w4d.widget.panel,
       w4d.widget.root,
       w4d.exception;
import gl3n.linalg;

class PopupWidget : RootWidget
{
    // WindowContext of target of popup.
    protected WindowContext _objectContext;

    protected vec2 _pos, _size;

    override void handlePopup ( bool opened, WindowContext w )
    {
        if ( opened ) {
            _objectContext = w;
        } else {
            _objectContext.requestRedraw();
            _objectContext = null;
        }
    }

    this ()
    {
        super();
        _objectContext = null;

        _pos  = vec2(0,0);
        _size = vec2(0,0);
    }

    void move ( vec2 pos, vec2 size )
    {
        _pos  = pos;
        _size = size;
        requestLayout();
    }
    void close ()
    {
        enforce( _objectContext,
                "The popup is not opened yet." );
        _objectContext.setPopup( null );
    }

    override vec2 layout ( vec2 rootlt, vec2 rootsz )
    {
        .Widget.layout( _pos, _size );

        auto rootrb = rootlt + rootsz;

        auto lt = style.translate;
        auto rb = lt + style.box.collisionSize;

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
