// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module w4d.layout.base;
import w4d.layout.exception,
       w4d.style.widget;
import g4d.math.vector;

abstract class Layout
{
    protected Layoutable _owner;

    @property owner    () { return _owner; }
    @property style    () { return _owner.style; }
    @property children () { return _owner.childLayoutables; }

    this ( Layoutable owner )
    {
        enforce( owner, "Owner is null." );
        _owner = owner;
    }

    void place ( vec2, vec2 );
}

interface Layoutable
{
    @property WidgetStyle  style            ();
    @property Layoutable[] childLayoutables ();

    vec2 layout ( vec2, vec2 );
}
