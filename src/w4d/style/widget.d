// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module w4d.style.widget;
import w4d.style.box,
       w4d.style.exception,
       w4d.style.templates;
import g4d.math.vector;

class WidgetStyle
{
    @("attr") {
        BoxStyle box;
    }

    this ()
    {
    }

    mixin AttributesUtilities;

    void calc ( WidgetStyle parent, float defHeight = 0 )
    {
        enforce( parent.isCalced, "Parent style has not been calculated yet." );

        auto parentSize = parent.box.size.vector;
        auto defSize    = vec2( parentSize.x, defHeight );
        box.calc( parentSize, defSize );
    }
}
