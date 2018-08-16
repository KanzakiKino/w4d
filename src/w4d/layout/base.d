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
import std.algorithm;

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

    protected vec2 _beforeBasePos;
    protected vec2 _beforeParentSize;

    ///
    this ( Layoutable owner )
    {
        enforce( owner, "Owner is null." );
        _owner = owner;

        _beforeBasePos    = vec2(0,0);
        _beforeParentSize = vec2(-1,-1);
    }

    /// Moves the owner and the children.
    void shift ( vec2 size )
    {
        _beforeBasePos += size;
        style.shift( size );
        children.each!( x => x.shift( size ) );
    }

    /// Checks if need to layout completely.
    protected @property needLayoutCompletely ()
    {
        return _owner.needLayout;
    }

    /// Just moves the owner and the children to pos
    /// if no need to layout completely.
    /// Returns: Whether the owner is placed easily.
    protected bool placeEasily ( vec2 basepos, vec2 parentSize )
    {
        scope(exit) {
            _beforeBasePos    = basepos;
            _beforeParentSize = parentSize;
        }

        alias dirty = needLayoutCompletely; // To evaluate lazily.
        if ( _beforeParentSize != parentSize || dirty ) {
            return false;
        }

        shift( basepos - _beforeBasePos );
        return true;
    }

    /// Calculates styles and decodes position of children.
    void place ( vec2, vec2 );
}

/// An interface of layoutable objects.
interface Layoutable
{
    /// Style data.
    inout @property inout(WidgetStyle) style ();

    /// Children.
    @property Layoutable[] childLayoutables ();

    /// Wanted size.
    @property vec2 wantedSize ();

    /// Checks if need to layout completely.
    @property bool needLayout ();

    /// Places at the pos with the size.
    vec2 layout ( vec2, vec2 );

    /// Moves the owner and the children.
    void shift ( vec2 );
}
