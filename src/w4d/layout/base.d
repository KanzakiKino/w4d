// Written in the D programming language.
/++
 + Authors: KanzakiKino
 + Copyright: KanzakiKino 2018
 + License: LGPL-3.0
++/
module w4d.layout.base;
import w4d.layout.exception,
       w4d.style.widget;
import gl3n.linalg;

/// A baseclass of Layout object.
/// Layout object decides children position to place
/// and calculates all styles.
abstract class Layout
{
    protected Layoutable _owner;

    /// Owner of the layout.
    inout @property owner () { return _owner; }

    protected @property style ()
    {
        return _owner.style;
    }

    protected @property children ()
    {
        return _owner.childLayoutables;
    }

    ///
    this ( Layoutable owner )
    {
        enforce( owner, "Owner is null." );
        _owner = owner;
    }

    /// Calculates styles and decodes position of children.
    void place ( vec2, vec2 );
}

/// An interface of layoutable objects.
interface Layoutable
{
    /// Style data.
    @property WidgetStyle style ();

    /// Children.
    @property Layoutable[] childLayoutables ();

    /// Wanted size.
    @property vec2 wantedSize ();

    /// Places at the pos with the size.
    vec2 layout ( vec2, vec2 );

    /// Shifts children.
    void shiftChildren ( vec2 );
}
