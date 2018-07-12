// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module w4d.style.widget;
import w4d.style.box,
       w4d.style.color,
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

enum WidgetState : uint
{
    None     = 0b000000,

    Disabled = 0b000001,
    Enabled  = 0b000010,

    Hovered  = 0b000100,
    Pressed  = 0b001000,
    Tracked  = 0b010000,
    Focused  = 0b100000,
}

class WidgetStyle
{
    @("attr") {
        Scalar   x, y;
        BoxStyle box;
    }
    ColorSet[WidgetState] colorsets;

    this ()
    {
        colorsets.clear();
        colorsets[WidgetState.None] = ColorSet();
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

    ref ColorSet getColorSet ( uint status )
    {
        static foreach ( v; __traits(allMembers,WidgetState) ) with (WidgetState) {
            static if ( mixin(v) != None ) {
                if ( (status & mixin(v)) && (mixin(v) in colorsets) ) {
                    return colorsets[mixin(v)];
                }
            }
        }
        return colorsets[WidgetState.None];
    }

    bool isPointInside ( vec2 pt )
    {
        pt -= translate + box.borderInsideLeftTop;
        if ( pt.x < 0 || pt.y < 0 ) {
            return false;
        }
        pt -= box.borderInsideSize;
        return pt.x <= 0 && pt.y <= 0;
    }
}
