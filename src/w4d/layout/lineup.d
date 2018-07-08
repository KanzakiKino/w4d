// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module w4d.layout.lineup;
import w4d.layout.base,
       w4d.layout.exception,
       w4d.layout.fill,
       w4d.style.widget;
import g4d.math.vector;

private class LineupLayout (bool Horizon) : FillLayout
{
    protected float _usedLength;

    this ( WidgetStyle style )
    {
        enforce( style, "Style is null." );
        super( style );

        _usedLength = 0;
    }

    protected ref float getLengthRef ( ref vec2 v )
    {
        static if (Horizon) {
            return v.x;
        } else {
            return v.y;
        }
    }
    protected float getLength ( vec2 v )
    {
        return getLengthRef(v);
    }

    override void push ( Layout l )
    {
        auto pos = _style.clientLeftTop;
        getLengthRef(pos) += _usedLength;

        l.move( pos, _style.box.clientSize );
        _usedLength += getLength(_style.box.collisionSize);
    }
    override void fix ()
    {
        _usedLength = 0;
    }
}

alias HorizontalLayout = LineupLayout!true;
alias VerticalLayout   = LineupLayout!false;
