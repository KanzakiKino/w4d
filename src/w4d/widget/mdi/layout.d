// Written in the D programming language.
/++
 + Authors: KanzakiKino
 + Copyright: KanzakiKino 2018
 + License: LGPL-3.0
++/
module w4d.widget.mdi.layout;
import w4d.layout.base,
       w4d.layout.fill;
import gl3n.linalg;

/// A layout object only for MdiClientWidget.
class MdiLayout : FillLayout
{
    ///
    this ( Layoutable owner )
    {
        super( owner );
    }

    ///
    override void place ( vec2 pt, vec2 sz )
    {
        fill( pt, sz );

        auto pos  = style.clientLeftTop;
        auto size = style.box.clientSize;
        foreach ( child; children ) {
            child.layout( pos, size );
        }
    }
}
