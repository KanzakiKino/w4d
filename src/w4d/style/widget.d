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
    WidgetStyle parent = null;
    vec2        pos    = vec2(0,0);
    vec2        size   = vec2(0,0);

    void fillValues ()
    {
        enforce( parent, "Parent is null." );
        enforce( parent.isCalced, "Parent style has not been calculated yet." );

        if ( size.x <= 0 ) size.x = parent.box.size.width .calced;
        if ( size.y <= 0 ) size.y = parent.box.size.height.calced;
    }
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

    void calc ( WidgetStyleCalcContext ctx )
    {
        ctx.fillValues();
        auto parentSize = ctx.parent.box.clientSize;

        x.calc( ScalarUnitBase(ctx.pos.x, parentSize.x) );
        y.calc( ScalarUnitBase(ctx.pos.y, parentSize.y) );
        box.calc( parentSize, ctx.size );
    }
}
