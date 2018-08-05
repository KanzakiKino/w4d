// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module w4d.widget.mdi.window;

template WindowOperations ()
{
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
        _size = size;
        requestLayout();
    }

    void close ()
    {
        enforce( _host, "Host is not defined yet." );
        _host.removeClient( this );
    }
}
