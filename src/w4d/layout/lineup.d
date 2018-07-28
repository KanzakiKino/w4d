// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module w4d.layout.lineup;
import w4d.layout.base,
       w4d.layout.exception,
       w4d.layout.fill,
       w4d.style.widget,
       w4d.util.vector;
import g4d.math.vector;

class LineupLayout (bool Horizon) : FillLayout
{
    protected float _usedLength;

    this ( WidgetStyle style )
    {
        super( style );

        _usedLength = 0;
    }

    override void push ( Layout l )
    {
        auto pos = _style.clientLeftTop;
        pos.lengthRef!Horizon += _usedLength;

        l.move( pos, _style.box.clientSize );
        _usedLength += l.style.box.collisionSize.length!Horizon;
    }
    override void fix ()
    {
        _usedLength = 0;
    }
}

alias HorizontalLineupLayout = LineupLayout!true;
alias VerticalLineupLayout   = LineupLayout!false;
