// Written in the D programming language.
/++
 + Authors: KanzakiKino
 + Copyright: KanzakiKino 2018
 + License: LGPL-3.0
++/
module w4d.layout.lineup;
import w4d.layout.base,
       w4d.layout.exception,
       w4d.layout.fill,
       w4d.style.widget,
       w4d.util.vector;
import gl3n.linalg;
import std.algorithm;

/// A layout object that lineups children.
/// You can specify Scalar.Auto at width or height to respect wantedSize.
/// And you can also specify Scalar.None to shrink as small as possible.
class LineupLayout (bool H) : FillLayout
{
    /// Direction of lineup.
    alias Horizon = H;

    protected vec2 _childSize;
    protected vec2 _basePoint;
    protected vec2 _usedSize;

    ///
    this ( Layoutable owner )
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
    override void place ( vec2 basepos, vec2 parentSize )
    {
        fill( basepos, parentSize );
        clearStatus();
        foreach ( child; children ) {
            auto size = child.layout( _basePoint, _childSize );
            updateStatus( size );
        }
        alterSize( _usedSize );
    }
}

/// A layout object that lineups horizontally.
alias HorizontalLineupLayout = LineupLayout!true;
/// A layout object that lineups vertically.
alias VerticalLineupLayout   = LineupLayout!false;
