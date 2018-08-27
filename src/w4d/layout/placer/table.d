// Written in the D programming language.
/++
 + Authors: KanzakiKino
 + Copyright: KanzakiKino 2018
 + License: LGPL-3.0
++/
module w4d.layout.placer.table;
import w4d.layout.placer.base,
       w4d.style.widget;
import gl3n.linalg;

/// A placer that places like table.
class TablePlacer ( int Cols, int Rows ) : Placer
    if ( Cols >= 0 && Rows >= 0 )
{
    ///
    enum ColsRows = vec2i( Cols, Rows );

    ///
    this ( PlacerOwner owner )
    {
        super( owner );
    }

    ///
    override vec2 placeChildren ()
    {
        const clientSize = style.box.clientSize;
        auto  cellSize   =
            vec2( clientSize.x/Cols, clientSize.y/Rows );

        const basept = style.clientLeftTop;
        auto  index  = vec2i(0,0);
        foreach ( child; children ) {
            const late = basept +
                vec2( cellSize.x*index.x, cellSize.y*index.y );
            child.layout( late, cellSize );

            if ( ++index.x >= Cols ) {
                index.y++;
                index.x = 0;
            }
        }
        return vec2( clientSize.x, cellSize.y*index.y );
    }
}
