// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module w4d.layout.fill;
import w4d.layout.base,
       w4d.style.widget;
import g4d.math.vector;

class FillLayout : Layout
{
    this ( WidgetStyle style )
    {
        super( style );
    }

    override void fix ( vec2 pt, vec2 sz )
    {
        auto ctx = WidgetStyleCalcContext();
        ctx.parentSize = sz;
        ctx.pos        = pt;
        _style.calc( ctx );
    }
}
