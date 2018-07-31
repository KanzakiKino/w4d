// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module w4d.layout.fill;
import w4d.layout.base,
       w4d.layout.exception,
       w4d.style.widget;
import g4d.math.vector;

class FillLayout : Layout
{
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

    override void place ( vec2 pt, vec2 sz )
    {
        enforce( !children.length,
              "FillLayout doesn't support children." );
        fill( pt, sz );
    }
}
