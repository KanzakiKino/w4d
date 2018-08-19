// Written in the D programming language.
/++
 + Authors: KanzakiKino
 + Copyright: KanzakiKino 2018
 + License: LGPL-3.0
++/
module w4d.layout.gravity;
import w4d.layout.placer.base,
       w4d.layout.base,
       w4d.layout.fill;
import gl3n.linalg;

/// A layout object that moves the center pos.
class GravityLayout : FillLayout
{
    protected vec2 _center;

    ///
    this ( Placer placer, Layoutable owner, vec2 center )
    {
        super( placer, owner );
        _center = center;
    }

    override protected void fill ( vec2 pt, vec2 sz )
    {
        super.fill( pt, sz );

        auto late = sz - style.box.collisionSize;
        late.x   *= _center.x;
        late.y   *= _center.y;
        shift( late );
    }
}
