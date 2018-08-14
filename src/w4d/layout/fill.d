// Written in the D programming language.
/++
 + Authors: KanzakiKino
 + Copyright: KanzakiKino 2018
 + License: LGPL-3.0
++/
module w4d.layout.fill;
import w4d.layout.base,
       w4d.layout.exception,
       w4d.style.widget;
import gl3n.linalg;

/// A layout object that fills the parent with the owner.
/// This layout doesn't support children.
/// You can specify Scalar.Auto at width or height to respect wantedSize.
/// And you can also specify Scalar.None to fill the parent.
class FillLayout : Layout
{
    ///
    this ( Layoutable owner )
    {
        super( owner );
    }

    protected void alterSize ( vec2 sz )
    {
        if ( style.box.size.width.isNone ) {
            style.box.size.width.alter( sz.x );
        }
        if ( style.box.size.height.isNone ) {
            style.box.size.height.alter( sz.y );
        }
    }

    protected void fill ( vec2 pt, vec2 sz )
    {
        auto ctx = WidgetStyleCalcContext();
        ctx.parentSize = sz;
        ctx.pos        = pt;
        ctx.size       = owner.wantedSize;
        style.calc( ctx );
    }

    ///
    override void place ( vec2 pt, vec2 sz )
    {
        enforce( !children.length,
              "FillLayout doesn't support children." );
        fill( pt, sz );
    }
}
