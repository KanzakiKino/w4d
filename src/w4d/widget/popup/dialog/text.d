// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module w4d.widget.popup.dialog.text;
import w4d.layout.lineup,
       w4d.widget.popup.dialog.base,
       w4d.widget.button,
       w4d.widget.panel,
       w4d.widget.text,
       w4d.event,
       w4d.exception;
import g4d.ft.font;

enum DialogButton
{
    Ok,
    Cancel,
}

@property dstring toDString ( const DialogButton type )
{
    final switch ( type ) with ( DialogButton ) {
        case Ok    : return "OK"d;
        case Cancel: return "Cancel"d;
    }
}

alias ResultHandler = EventHandler!( void, DialogButton );

class PopupTextDialogWidget : PopupDialogWidget
{
    protected class CustomButton : ButtonWidget
    {
        const DialogButton type;

        override void handleButtonPress ()
        {
            handleResult( type );
        }

        this ( DialogButton t, FontFace face )
        {
            super();
            type = t;

            loadText( t.toDString, face );
        }
    }

    protected TextWidget  _text;
    protected PanelWidget _buttons;

    ResultHandler onResult;

    void handleResult ( DialogButton btn )
    {
        close();
        onResult.call( btn );
    }

    this ()
    {
        super();
        setLayout!VerticalLineupLayout;

        _text = new TextWidget;
        addChild( _text );

        _buttons = new PanelWidget;
        _buttons.setLayout!HorizontalLineupLayout;
        addChild( _buttons );
    }

    void loadText ( dstring v, FontFace face = null )
    {
        _text.loadText( v, face );
    }

    void setButtons ( DialogButton[] btns, FontFace face = null )
    {
        if ( !face ) {
            face = _text.font;
        }
        enforce( face, "FontFace is not specified." );

        _buttons.removeAllChildren();
        foreach ( type; btns ) {
            _buttons.addChild( new CustomButton(type,face) );
        }
        requestLayout();
    }
}
