// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module w4d.style.widget;
import w4d.style.box,
       w4d.style.color,
       w4d.style.exception,
       w4d.style.scalar,
       w4d.style.templates;
import gl3n.linalg;

struct WidgetStyleCalcContext
{
    vec2 parentSize = vec2(0,0);
    vec2 pos        = vec2(0,0);
    vec2 size       = vec2(0,0);
}

// Upper state is rarer to occur.
enum WidgetState : uint
{
    Focused  = 0b00001,
    Tracked  = 0b00010,
    Pressed  = 0b00100,
    Hovered  = 0b01000,

    Selected = 0b10000,

    None     = 0b00000,
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

    ColorSet getColorSet ( uint status )
    {
        ColorSet result;

        static foreach ( v; __traits(allMembers,WidgetState) ) with (WidgetState) {
            enum S = mixin(v);
            if ( ((status & S) || !S) && (S in colorsets) ) {
                result.inherit( colorsets[S] );
            }
        }
        return result;
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

    bool isWidgetInside ( WidgetStyle target )
    {
        auto targetLT = target.translate +
            target.box.borderOutsideLeftTop;
        auto targetRB = targetLT +
            target.box.borderOutsideSize;

        auto selfLT = translate +
            box.borderOutsideLeftTop;
        auto selfRB = selfLT +
            box.borderOutsideSize;

        return selfLT.x > targetRB.x? false:
               selfLT.y > targetRB.y? false:
               selfRB.x < targetLT.x? false:
               selfRB.y < targetLT.y? false:
               true;
    }

    void shift ( vec2 size )
    {
        x.alter( x.calced+size.x );
        y.alter( y.calced+size.y );
    }
}
