// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module w4d.widget.mdi.window;

enum Side
{
    None   = 0b0000,
    Left   = 0b0001,
    Top    = 0b0010,
    Right  = 0b0100,
    Bottom = 0b1000,
}

template WindowOperations ()
{
    protected uint _draggingSides;

    protected void enableSideDragging ( vec2 pos )
    {
        auto lt = style.translate +
            style.box.borderInsideLeftTop;
        auto ltsz = vec2( style.box.paddings.left.calced,
                style.box.paddings.top.calced );

        auto rb = lt + ltsz + style.box.clientSize;
        auto rbsz = vec2( style.box.paddings.right.calced,
                style.box.paddings.bottom.calced );

        _draggingSides = Side.None;
        if ( pos.x > lt.x && pos.x < lt.x+ltsz.x ) {
            _draggingSides |= Side.Left;
        }
        if ( pos.y > lt.y && pos.y < lt.y+ltsz.y ) {
            _draggingSides |= Side.Top;
        }
        if ( pos.x > rb.x && pos.x < rb.x+rbsz.x ) {
            _draggingSides |= Side.Right;
        }
        if ( pos.y > rb.y && pos.y < rb.y+rbsz.y ) {
            _draggingSides |= Side.Bottom;
        }
    }

    protected void resizeWithDragging ( vec2 cur )
    {
        auto sides = _draggingSides;
        auto size = _size, pos = _pos;

        if ( sides & Side.Left ) {
            size.x += pos.x-cur.x;
            pos.x   = cur.x;
        }
        if ( sides & Side.Top ) {
            size.y += pos.y-cur.y;
            pos.y   = cur.y;
        }
        if ( sides & Side.Right ) {
            size.x = cur.x - pos.x;
        }
        if ( sides & Side.Bottom ) {
            size.y = cur.y - pos.y;
        }
        move  ( pos );
        resize( size );
    }


    protected vec2 _minSize;
    @property vec2 minSize () { return _minSize; }

    protected vec2 _maxSize;
    @property vec2 maxSize () { return _maxSize; }

    void limitSize ( vec2 min, vec2 max )
    {
        _minSize = min;
        _maxSize = max;
        resize( size );
    }


    protected vec2 _pos;
    @property vec2 pos () { return _pos; }

    protected vec2 _size;
    @property vec2 size () { return _size; }

    void move ( vec2 pos )
    {
        _pos = pos;
        requestLayout();
    }
    void resize ( vec2 size )
    {
        size.x = size.x.clamp( minSize.x, maxSize.x );
        size.y = size.y.clamp( minSize.y, maxSize.y );
        _size = size;
        requestLayout();
    }

    void close ()
    {
        enforce( _host, "Host is not defined yet." );
        _host.removeClient( this );
    }


    override bool handleMouseMove ( vec2 cur )
    {
        if ( super.handleMouseMove( cur ) ) return true;

        if ( isTracked ) {
            cur -= _host.style.clientLeftTop;
            resizeWithDragging( cur );
            return true;
        }
        return false;
    }

    override bool handleMouseButton ( MouseButton btn, bool status, vec2 pos )
    {
        enforce( _host, "MdiHost is null." );
        _host.focusClient( this );

        if ( super.handleMouseButton(btn,status,pos) ) return true;

        if ( btn == MouseButton.Left && status ) {
            enableSideDragging( pos );
            return true;

        } else if ( btn == MouseButton.Left && !status ) {
            _draggingSides = Side.None;
            return true;
        }
        return false;
    }
}
