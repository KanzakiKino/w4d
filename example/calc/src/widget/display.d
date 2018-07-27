// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module calc.widget.display;
import calc.context;
import w4d;

class DisplayWidget : LineInputWidget, ResultDisplay
{
    this ()
    {
        super();
        lock();
    }

    override void pushText ( dstring v )
    {
        loadText( v );
    }
}
