// Written in the D programming language.
/++
 + Authors: KanzakiKino
 + Copyright: KanzakiKino 2018
 + License: LGPL-3.0
++/
module w4d.layout.placer.lineup;
import w4d.layout.placer.base,
       w4d.util.vector;
import gl3n.linalg;
import std.algorithm;

/// A Placer object that lineups the children.
class LineupPlacer(bool H) : Placer
{
    /// Whether the Placer lineups horizontally.
    alias Horizon = H;

    protected vec2 _childSize;
    protected vec2 _basePoint;
    protected vec2 _usedSize;

    ///
    this ( PlacerOwner owner )
    {
        super( owner );
    }

    protected void clearStatus ()
    {
        _childSize = style.box.clientSize;
        _basePoint = style.clientLeftTop;
        _usedSize  = vec2(0,0);
    }
    protected void updateStatus ( vec2 placedSize )
    {
        const length = placedSize.getLength!H;
        const weight = placedSize.getWeight!H;

        _basePoint.getLength!H += length;
        _usedSize .getLength!H += length;

        _usedSize.getWeight!Horizon =
            max( _usedSize.getWeight!H, weight );
    }

    ///
    override vec2 placeChildren ()
    {
        clearStatus();
        foreach ( child; children ) {
            auto sz = child.layout( _basePoint, _childSize );
            if ( !child.style.floating ) {
                updateStatus( sz );
            }
        }
        return _usedSize;
    }
}
/// A Placer object that lineups the children horizontally.
alias HorizontalLineupPlacer = LineupPlacer!true;
/// A Placer object that lineups the children vertically.
alias VerticalLineupPlacer = LineupPlacer!false;
