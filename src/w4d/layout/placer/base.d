// Written in the D programming language.
/++
 + Authors: KanzakiKino
 + Copyright: KanzakiKino 2018
 + License: LGPL-3.0
++/
module w4d.layout.placer.base;
import w4d.style.widget;
import gl3n.linalg;

/// A baseclass of Placer.
/// Placer decides client area of each children.
abstract class Placer
{
    protected PlacerOwner _owner;

    /// Owner of the placer.
    inout @property inout(PlacerOwner) owner ()
    {
        return _owner;
    }
    protected @property style ()
    {
        return _owner.style;
    }
    protected @property children ()
    {
        return _owner.childPlacerOwners;
    }

    ///
    this ( PlacerOwner owner )
    {
        _owner = owner;
    }

    /// Decides client area of each children.
    vec2 placeChildren ();
}

/// An interface of the owner that has children to place.
interface PlacerOwner
{
    /// Style.
    inout @property inout(WidgetStyle) style ();

    /// Children.
    @property PlacerOwner[] childPlacerOwners ();

    /// Places at the pos with the size.
    vec2 layout ( vec2, vec2 );
}
