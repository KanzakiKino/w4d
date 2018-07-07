// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module w4d.style.widget;
import w4d.style.box,
       w4d.style.exception,
       w4d.style.scalar,
       w4d.style.templates;
import g4d.math.vector;

struct WidgetStyleCalcContext
{
    vec2 parentSize = vec2(0,0);
    vec2 pos        = vec2(0,0);
    vec2 size       = vec2(0,0);
}

class WidgetStyle
{
    @("attr") {
        Scalar   x, y;
        BoxStyle box;
    }

    this ()
    {
    }

    mixin AttributesUtilities;

    @property translate ()
    {
        return vec2( x.calced, y.calced );
    }
    @property clientLeftTop ()
    {
        return translate + box.clientLeftTop;
    }

    void calc ( WidgetStyleCalcContext ctx )
    {
        x.calc( ScalarUnitBase(ctx.pos.x, ctx.parentSize.x) );
        y.calc( ScalarUnitBase(ctx.pos.y, ctx.parentSize.y) );
        box.calc( ctx.parentSize, ctx.size );
    }
}
