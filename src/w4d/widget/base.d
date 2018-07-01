// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module w4d.widget.base;
import w4d.task.window;
import g4d.math.vector;

class Widget : WindowContent
{
    protected vec2i _size;
    @property size () { return _size; }

    override void handleMouseEnter ( bool entered )
    {
    }
    override bool handleMouseMove ( vec2 pos )
    {
        return false;
    }
    override bool handleMouseButton ( MouseButton btn, bool status )
    {
        return false;
    }
    override bool handleMouseScroll ( vec2 amount )
    {
        return false;
    }

    override bool handleKey ( Key key, KeyState status )
    {
        return false;
    }
    override bool handleTextInput ( dchar c )
    {
        return false;
    }

    this ()
    {
    }

    override void resize ( vec2i newSize )
    {
        _size = newSize;
    }
    override void draw ( Window win )
    {
    }
}
