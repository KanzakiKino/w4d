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

enum LayoutState
{
    None,
    Dirty,
    Clean,
}

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

    protected LayoutState _status;

    protected vec2 _beforeBasePos;
    protected vec2 _beforeParentSize;

    ///
    this ( Layoutable owner )
    {
        enforce( owner, "Owner is null." );
        _owner = owner;

        _status           = LayoutState.None;
        _beforeBasePos    = vec2(0,0);
        _beforeParentSize = vec2(-1,-1);
    }

    /// Moves the owner and the children.
    void shift ( vec2 size )
    {
        if ( size == vec2(0,0) ) return;

        _beforeBasePos += size;
        style.shift( size );
        children.each!( x => x.shift( size ) );
    }

    protected bool updateDirtyState ()
    {
        auto dirty = false;
        foreach ( child; children ) {
            if ( child.layoutObject.updateDirtyState() ) {
                dirty = true;
            }
        }
        if ( !dirty ) {
            dirty = _owner.checkNeedLayout( false );
        }
        _status = dirty? LayoutState.Dirty: LayoutState.Clean;
        return dirty;
    }

    /// Just moves the owner and the children to pos
    /// if no need to layout completely.
    /// Returns: Whether the owner is placed easily.
    protected bool placeEasily ( vec2 basepos, vec2 parentSize )
    {
        scope(exit) {
            _status           = LayoutState.None;
            _beforeBasePos    = basepos;
            _beforeParentSize = parentSize;
        }
        if ( _status == LayoutState.None ) {
            updateDirtyState();
        }

        auto dirty = (_status != LayoutState.Clean);
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

    /// Layout object.
    inout @property inout(Layout) layoutObject ();

    /// Children.
    @property Layoutable[] childLayoutables ();

    /// Wanted size.
    @property vec2 wantedSize ();

    /// Checks if need to layout completely.
    /// Set the first argument true to check recursively.
    bool checkNeedLayout ( bool );

    /// Places at the pos with the size.
    vec2 layout ( vec2, vec2 );

    /// Moves the owner and the children.
    void shift ( vec2 );
}
