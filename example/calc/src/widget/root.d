// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module calc.widget.root;
import calc.widget.display,
       calc.calculator,
       calc.context;
import w4d;
import std.ascii,
       std.conv,
       std.file,
       std.path;

class RootWidget : PanelWidget
{
    enum dstring[] Buttons = [
         "9", "8", "7", "/",
         "6", "5", "4", "*",
         "3", "2", "1", "-",
        "AC", "0", "=", "+",
    ];

    protected static auto createEvent ( dstring b )
    {
        ButtonPressedHandler hndl;
        if ( b.length == 1 && b[0].isDigit ) {
            hndl = delegate () {
                CalcContext.push( b.to!int );
            };
        } else if ( b == "AC"d ) {
            hndl = delegate () {
                CalcContext.reset();
            };
        } else if ( b.length == 1 ) {
            hndl = delegate () {
                CalcContext.push( b[0].toOperator );
            };
        } else assert( false );
        return hndl;
    }

    this ()
    {
        super();
        setLayout!VerticalSplitLayout;

        auto dirpath = thisExePath.dirName;
        auto font    = new Font( dirpath~"/noto.ttf" );

        auto display = new DisplayWidget;
        display.loadText( ""d, new FontFace( font, vec2i(32,32) ));
        addChild( display );

        PanelWidget panel = new PanelWidget;
        panel.setLayout!TableLayout( 4, 4 );
        addChild( panel );

        auto buttonface = new FontFace( font, vec2i(24,24) );
        foreach ( i,b; Buttons ) {
            auto button = new ButtonWidget;
            button.loadText( b, buttonface );
            button.onButtonPressed = createEvent( b );
            panel.addChild( button );
        }

        new AppContext( display );
    }
}
