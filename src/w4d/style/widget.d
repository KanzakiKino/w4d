// Written in the D programming language.
/++
 + Authors: KanzakiKino
 + Copyright: KanzakiKino 2018
 + License: LGPL-3.0
++/
module w4d.style.widget;
import w4d.style.box,
       w4d.style.color,
       w4d.style.exception,
       w4d.style.scalar,
       w4d.style.templates;
import gl3n.linalg;

/// A context of widget style calculation.
struct WidgetStyleCalcContext
{
    /// Size of the parent widget.
    vec2 parentSize = vec2(0,0);
    /// Position the widget should be placed.
    vec2 pos        = vec2(0,0);
    /// Size the widget should be resized.
    vec2 size       = vec2(0,0);
}

/// An enum of widget state.
/// Upper state is rarer to occur.
enum WidgetState : uint
{
    Focused  = 0b00001,
    Tracked  = 0b00010,
    Pressed  = 0b00100,
    Hovered  = 0b01000,

    Selected = 0b10000,

    None     = 0b00000,
}

/// A style data of widget.
class WidgetStyle
{
    @("attr") {
        /// Left top position.
        /// This shouldn't be specified.,
        Scalar   x, y;
        /// Box style.
        BoxStyle box;
    }
    /// Colorset data.
    /// Please inherit the parent's before using.
    ColorSet[WidgetState] colorsets;

    /// Whether the widget is floating.
    /// When true, spaces for the widget won't be reserved.
    bool floating;

    ///
    this ()
    {
        colorsets.clear();
        colorsets[WidgetState.None] = new ColorSet();

        floating = false;
    }

    mixin AttributesUtilities;

    /// Left top position.
    const @property translate ()
    {
        return vec2( x.calced, y.calced );
    }
    /// Left top position + margins + border + paddings.
    const @property clientLeftTop ()
    {
        return translate + box.clientLeftTop;
    }

    /// Calculates the all styles.
    void calc ( WidgetStyleCalcContext ctx )
    {
        x.calc( ScalarUnitBase(ctx.pos.x, ctx.parentSize.x) );
        y.calc( ScalarUnitBase(ctx.pos.y, ctx.parentSize.y) );
        box.calc( ctx.parentSize, ctx.size );
    }

    /// Make src inherit the colorset.
    const ColorSet inheritColorSet ( return ColorSet src, uint status )
    {
        static foreach ( v; __traits(allMembers,WidgetState) ) with (WidgetState) {
            enum S = mixin(v);
            if ( ((status & S) || !S) && (S in colorsets) ) {
                src.inherit( colorsets[S] );
            }
        }
        return src;
    }

    /// Checks if pt is inside of border.
    const bool isPointInside ( vec2 pt )
    {
        pt -= translate + box.borderInsideLeftTop;
        if ( pt.x < 0 || pt.y < 0 ) {
            return false;
        }
        pt -= box.borderInsideSize;
        return pt.x <= 0 && pt.y <= 0;
    }

    /// Checks if target is outside of border.
    const bool isWidgetInside ( in WidgetStyle target )
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

    /// Moves x and y scalars.
    void shift ( vec2 size )
    {
        x.alter( x.calced+size.x );
        y.alter( y.calced+size.y );
    }
}
