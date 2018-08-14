// Written in the D programming language.
/++
 + Authors: KanzakiKino
 + Copyright: KanzakiKino 2018
 + License: LGPL-3.0
++/
module w4d.layout.split;
import w4d.layout.base,
       w4d.layout.exception,
       w4d.layout.lineup,
       w4d.util.vector;
import gl3n.linalg;

/// A layout object that lineups children and splits the parent.
class SplitLayout (bool H) : LineupLayout!H
{
    ///
    this ( Layoutable owner )
    {
        super( owner );
    }
    protected override void updateStatus ( vec2 placedSize )
    {
        auto length = placedSize.getLength!H;
        enforce( length <= _childSize.getLength!H,
              "Failed to place the too big child." );

        _childSize.getLength!H -= length;
        super.updateStatus( placedSize );
    }
}
/// A layout object that lineups children horizontally and splits the parent.
alias HorizontalSplitLayout = SplitLayout!true;
/// A layout object that lineups children vertically and splits the parent.
alias VerticalSplitLayout   = SplitLayout!false;

/// A layout object that lineups children as the same size.
class MonospacedSplitLayout (bool H) : LineupLayout!H
{
    ///
    this ( Layoutable owner )
    {
        super( owner );
    }
    protected override void clearStatus ()
    {
        super.clearStatus();
        _childSize.getLength!H /= children.length;
    }
}
/// A layout object that lineups children as the same size horizontally.
alias HorizontalMonospacedSplitLayout = MonospacedSplitLayout!true;
/// A layout object that lineups children as the same size vertically.
alias VerticalMonospacedSplitLayout   = MonospacedSplitLayout!false;
