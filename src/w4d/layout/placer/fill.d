// Written in the D programming language.
/++
 + Authors: KanzakiKino
 + Copyright: KanzakiKino 2018
 + License: LGPL-3.0
++/
module w4d.layout.placer.fill;
import w4d.layout.placer.base;
import gl3n.linalg;

/// A Placer object that fills each children.
class FillPlacer : Placer
{
    this ( PlacerOwner owner )
    {
        super( owner );
    }

    override vec2 placeChildren ()
    {
        const pos  = style.clientLeftTop;
        const size = style.box.clientSize;
        foreach ( child; children ) {
            child.layout( pos, size );
        }
        return size;
    }
}
