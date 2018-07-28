// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module w4d.layout.split;
import w4d.layout.base,
       w4d.layout.exception,
       w4d.layout.lineup,
       w4d.style.widget,
       w4d.util.vector;
import g4d.math.vector;

class SplitLayout (bool Horizon) : LineupLayout!Horizon
{
    this ( WidgetStyle style )
    {
        super( style );
    }

    override void push ( Layout child )
    {
        auto pos = _style.clientLeftTop;
        pos.lengthRef!Horizon += _usedLength;

        auto sz = _style.box.clientSize;
        sz.lengthRef!Horizon -= _usedLength;

        enforce( sz.length!Horizon > 0, "Cannot place too big child." );

        child.move( pos, sz );
        _usedLength += child.style.box.collisionSize.length!Horizon;
    }
}
alias HorizontalSplitLayout = SplitLayout!true;
alias VerticalSplitLayout   = SplitLayout!false;

class MonospacedSplitLayout (bool Horizon) : LineupLayout!Horizon
{
    protected Layout[] _children;

    this ( WidgetStyle style )
    {
        super( style );
    }

    override void push ( Layout child )
    {
        enforce( child, "Null is not a child." );
        _children ~= child;
    }
    override void fix ()
    {
        if ( !_children.length ) return;

        auto size               = _style.box.clientSize;
        size.lengthRef!Horizon /= _children.length;

        auto pos = style.clientLeftTop;

        foreach ( l; _children ) {
            l.move( pos, size );
            pos.lengthRef!Horizon += size.length!Horizon;
        }
        _children = [];
        super.fix();
    }
}
alias HorizontalMonospacedSplitLayout = MonospacedSplitLayout!true;
alias VerticalMonospacedSplitLayout   = MonospacedSplitLayout!false;
