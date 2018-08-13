// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module w4d.layout.split;
import w4d.layout.base,
       w4d.layout.exception,
       w4d.layout.lineup,
       w4d.util.vector;
import gl3n.linalg;

class SplitLayout (bool H) : LineupLayout!H
{
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
alias HorizontalSplitLayout = SplitLayout!true;
alias VerticalSplitLayout   = SplitLayout!false;

class MonospacedSplitLayout (bool H) : LineupLayout!H
{
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
alias HorizontalMonospacedSplitLayout = MonospacedSplitLayout!true;
alias VerticalMonospacedSplitLayout   = MonospacedSplitLayout!false;
