// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module w4d.layout.base;
import w4d.layout.exception,
       w4d.style.widget;
import g4d.math.vector;

abstract class Layout
{
    protected WidgetStyle _style;

    this ( WidgetStyle style )
    {
        enforce( style, "style is null." );
        _style = style;
    }

    void push ( Layout child )
    {
        throw new LayoutException( "This layout doesn't support children." );
    }
    void fix ( vec2, vec2 );
}
