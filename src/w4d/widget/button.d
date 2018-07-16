// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module w4d.widget.button;
import w4d.parser.theme,
       w4d.task.window,
       w4d.widget.text,
       w4d.event;
import g4d.math.vector;

alias ButtonPressedHandler = EventHandler!( void );
class ButtonWidget : TextWidget
{
    ButtonPressedHandler onButtonPressed;

    this ()
    {
        super();
        textPosRate = vec2(0.5,0.5);

        parseThemeFromFile!"theme/pressable.yaml"( style );
    }

    override bool handleMouseButton ( MouseButton btn, bool status, vec2 pos )
    {
        if ( super.handleMouseButton( btn, status, pos ) ) {
            return true;
        }
        if ( !style.isPointInside(pos) ) {
            return false;
        }
        if ( btn == MouseButton.Left && !status ) {
            onButtonPressed.call();
            return true;
        }
        return false;
    }
}
