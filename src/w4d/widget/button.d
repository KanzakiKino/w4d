// Written in the D programming language.
/++
 + Authors: KanzakiKino
 + Copyright: KanzakiKino 2018
 + License: LGPL-3.0
++/
module w4d.widget.button;
import w4d.layout.placer.fill,
       w4d.layout.gravity,
       w4d.parser.colorset,
       w4d.style.rect,
       w4d.style.scalar,
       w4d.task.window,
       w4d.widget.panel,
       w4d.widget.text,
       w4d.event;
import g4d.ft.font,
       g4d.glfw.cursor;
import gl3n.linalg;

/// A handler that handles pressing buttons.
alias ButtonPressHandler = EventHandler!( void );

/// A widget of button.
class ButtonWidget : PanelWidget
{
    protected TextWidget _text;
    /// TextWidget.
    inout @property inout(TextWidget) text () { return _text; }

    ///
    ButtonPressHandler onButtonPress;

    ///
    override bool handleMouseButton ( MouseButton btn, bool status, vec2 pos )
    {
        if ( super.handleMouseButton( btn, status, pos ) ) {
            return true;
        }
        if ( _status.disabled || !style.isPointInside(pos) ) {
            return false;
        }
        if ( btn == MouseButton.Left && !status ) {
            if ( !_status.locked ) handleButtonPress();
            return true;
        }
        return false;
    }

    ///
    void handleButtonPress ()
    {
        onButtonPress.call();
    }

    ///
    override @property const(Cursor) cursor ()
    {
        return Cursor.Hand;
    }

    ///
    this ()
    {
        super();

        _text = new TextWidget;
        _text.textOriginRate = vec2(0.5,0.5);
        _text.textPosRate    = vec2(0.5,0.5);
        super.addChild( _text );

        parseColorSetsFromFile!"colorset/button.yaml"( style );
        style.box.margins     = Rect(1.mm);
        style.box.paddings    = Rect(2.mm);
        style.box.borderWidth = Rect(1.pixel);
    }
    mixin DisableModifyChildren;

    /// Changes the text.
    void loadText ( dstring text, FontFace face )
    {
        _text.loadText( text, face );
    }

    ///
    override @property bool trackable () { return true; }
    ///
    override @property bool focusable () { return true; }
}
