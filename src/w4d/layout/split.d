// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module w4d.layout.split;
import w4d.layout.base,
       w4d.layout.exception,
       w4d.layout.lineup,
       w4d.util.vector;
import g4d.math.vector;

class SplitLayout (bool Horizon) : LineupLayout!Horizon
{
    this ( Layoutable owner )
    {
        super( owner );
    }
    protected override void updateStatus ( vec2 placedSize )
    {
        auto length = placedSize.length!Horizon;
        enforce( length <= _childSize.length!Horizon,
              "Failed to place the too big child." );

        _childSize.lengthRef!Horizon -= length;
        super.updateStatus( placedSize );
    }
}
alias HorizontalSplitLayout = SplitLayout!true;
alias VerticalSplitLayout   = SplitLayout!false;

class MonospacedSplitLayout (bool Horizon) : LineupLayout!Horizon
{
    this ( Layoutable owner )
    {
        super( owner );
    }
    protected override void clearStatus ()
    {
        super.clearStatus();
        _childSize.lengthRef!Horizon /= children.length;
    }
}
alias HorizontalMonospacedSplitLayout = MonospacedSplitLayout!true;
alias VerticalMonospacedSplitLayout   = MonospacedSplitLayout!false;
