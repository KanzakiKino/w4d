// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module w4d.layout.gravity;
import w4d.layout.exception,
       w4d.layout.base,
       w4d.layout.fill;
import gl3n.linalg;

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

        const maxlate = newsz - style.box.collisionSize;
        const late    = vec3( maxlate.x*_center.x, maxlate.y*_center.y, 0 );
        const pt      = vec3( basept, 0 ) + late;

        style.x.alter( pt.x );
        style.y.alter( pt.y );
    }
}
