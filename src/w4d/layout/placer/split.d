// Written in the D programming language.
/++
 + Authors: KanzakiKino
 + Copyright: KanzakiKino 2018
 + License: LGPL-3.0
++/
module w4d.layout.placer.split;
import w4d.layout.placer.base,
       w4d.layout.placer.lineup,
       w4d.util.vector,
       w4d.log;
import gl3n.linalg;

/// A Placer object that lineups the children and splits the owner.
class SplitPlacer(bool H) : LineupPlacer!H
{
    ///
    this ( PlacerOwner owner )
    {
        super( owner );
    }

    override protected void updateStatus ( vec2 placedSize )
    {
        auto length         = placedSize.getLength!H;
        auto remainedLength = &_childSize.getLength!H;

        if ( length > *remainedLength ) {
            Log.error( "The child protrudes to the outside of the owner." );
            length = *remainedLength;
        }

        *remainedLength -= length;
        super.updateStatus( placedSize );
    }
}

/// A Placer object that lineups the children horizontally and splits the owner.
alias HorizontalSplitPlacer = SplitPlacer!true;
/// A Placer object that lineups the children vertically and splits the owner.
alias VerticalSplitPlacer = SplitPlacer!false;
