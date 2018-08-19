// Written in the D programming language.
/++
 + Authors: KanzakiKino
 + Copyright: KanzakiKino 2018
 + License: LGPL-3.0
++/
module w4d.layout.placer.monospaced;
import w4d.layout.placer.base,
       w4d.layout.placer.lineup,
       w4d.util.vector;

/// A Placer object that lineups the children as the same size.
class MonospacedPlacer ( bool H ) : LineupPlacer!H
{
    this ( PlacerOwner owner )
    {
        super( owner );
    }
    protected override void clearStatus ()
    {
        super.clearStatus();
        _childSize.getLength!H /= children.length;
    }
}
/// A Placer object that lineups the children horizontally as the same size.
alias HorizontalMonospacedPlacer = MonospacedPlacer!true;
/// A Placer object that lineups the children vertically as the same size.
alias VerticalMonospacedPlacer = MonospacedPlacer!false;
