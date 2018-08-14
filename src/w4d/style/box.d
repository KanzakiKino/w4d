// Written in the D programming language.
/++
 + Authors: KanzakiKino
 + Copyright: KanzakiKino 2018
 + License: LGPL-3.0
++/
module w4d.style.box;
import w4d.style.rect,
       w4d.style.scalar,
       w4d.style.size,
       w4d.style.templates;
import gl3n.linalg;

///
unittest
{
    auto box = BoxStyle();
    box.size        = Size(100.percent, 200.pixel);
    box.borderWidth = Rect(5.percent);
    box.margins     = Rect(5.percent);
    box.calc( vec2(300,300) );

    assert( box.isRelative );
    assert( box.isCalced );
    assert( box.size.width.calced == 300f );
    assert( box.borderWidth.left.calced == 300*0.05f );
    assert( box.margins.left.calced == 300*0.05f );
}

/// A style data of box.
struct BoxStyle
{
    @("attr") {
        /// Size of the client.
        Size size;
        /// Width of the paddings.
        Rect paddings;
        /// Width of the border.
        Rect borderWidth;
        /// Width of the margins.
        Rect margins;
    }

    mixin AttributesUtilities;

    ///
    const @property clientSize ()
    {
        return size.vector;
    }
    /// Left top position of the client area.
    const @property clientLeftTop ()
    {
        return borderInsideLeftTop +
            vec2( paddings.left.calced, paddings.top.calced );
    }
    /// Size of margins + border + paddings.
    const @property clientAdditionalSize ()
    {
        auto result = borderInsideAdditionalSize;
        result.x += paddings.left.calced + paddings.right .calced;
        result.y += paddings.top .calced + paddings.bottom.calced;
        return result;
    }

    /// Size of clientArea + paddings.
    const @property borderInsideSize ()
    {
        auto result = size.vector;
        result.x += paddings.left.calced + paddings.right .calced;
        result.y += paddings.top .calced + paddings.bottom.calced;
        return result;
    }
    /// Left top position of inside of the border.
    const @property borderInsideLeftTop ()
    {
        return borderOutsideLeftTop +
            vec2( borderWidth.left.calced, borderWidth.top.calced );
    }
    /// Size of margins + border.
    const @property borderInsideAdditionalSize ()
    {
        auto result = borderOutsideAdditionalSize;
        result.x += borderWidth.left.calced + borderWidth.right .calced;
        result.y += borderWidth.top .calced + borderWidth.bottom.calced;
        return result;
    }

    /// Size of border + paddings + clienatArea.
    const @property borderOutsideSize ()
    {
        auto result = borderInsideSize;
        result.x += borderWidth.left.calced + borderWidth.right .calced;
        result.y += borderWidth.top .calced + borderWidth.bottom.calced;
        return result;
    }
    /// Left top position of outside of border.
    const @property borderOutsideLeftTop ()
    {
        return vec2( margins.left.calced, margins.top.calced );
    }
    /// Size of margins.
    const @property borderOutsideAdditionalSize ()
    {
        return vec2( margins.left.calced + margins.right.calced,
               margins.top.calced + margins.bottom.calced );
    }

    /// Size of margins + border + paddings + clientArea.
    const @property collisionSize ()
    {
        auto result = borderOutsideSize;
        result.x += margins.left.calced + margins.right .calced;
        result.y += margins.top .calced + margins.bottom.calced;
        return result;
    }

    /// Calculates all styles.
    void calc ( vec2 parentSize, vec2 def = vec2(0,0) )
    {
        paddings   .calc( parentSize );
        borderWidth.calc( parentSize );
        margins    .calc( parentSize );

        const expand = parentSize - clientAdditionalSize;
        if ( size.width.isNone || def.x <= 0 ) {
            def.x = expand.x;
        }
        if ( size.height.isNone || def.y <= 0 ) {
            def.y = expand.y;
        }
        size.calc( parentSize, def );
    }
}
