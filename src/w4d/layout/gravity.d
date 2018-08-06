// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module w4d.layout.gravity;
import w4d.layout.exception,
       w4d.layout.base,
       w4d.layout.fill;
import g4d.math.vector;

class GravityLayout : FillLayout
{
    // Rate of center point;
    protected vec2 _center;

    this ( Layoutable owner, vec2 center )
    {
        super( owner );
        _center = center;
    }

    override void place ( vec2 basept, vec2 newsz )
    {
        super.place( basept, newsz );

        auto sz = style.box.collisionSize;
        auto pt = basept;
        pt.x += (newsz.x - sz.x)*_center.x;
        pt.y += (newsz.y - sz.y)*_center.y;
        style.x.alter( pt.x );
        style.y.alter( pt.y );
    }
}
