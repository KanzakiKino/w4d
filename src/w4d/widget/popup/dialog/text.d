// Written in the D programming language.
/++
 + Authors: KanzakiKino
 + Copyright: KanzakiKino 2018
 + License: LGPL-3.0
++/
module w4d.widget.popup.dialog.text;
import w4d.layout.placer.lineup,
       w4d.layout.fill,
       w4d.widget.popup.dialog.base,
       w4d.widget.button,
       w4d.widget.panel,
       w4d.widget.text,
       w4d.event,
       w4d.exception;
import g4d.ft.font;

/// An enum of dialog buttons.
enum DialogButton
{
    Ok,
    Cancel,
}

/// Converts DialogButton to dstring.
@property dstring toDString ( DialogButton type )
{
    final switch ( type ) with ( DialogButton ) {
        case Ok    : return "OK"d;
        case Cancel: return "Cancel"d;
    }
}

/// A handler that handles closing the dialog.
alias ResultHandler = EventHandler!( void, DialogButton );

/// A widget of text dialog.
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

    ///
    ResultHandler onResult;

    ///
    void handleResult ( DialogButton btn )
    {
        close();
        onResult.call( btn );
    }

    ///
    this ()
    {
        super();
        setLayout!( FillLayout, VerticalLineupPlacer );

        _text = new TextWidget;
        addChild( _text );

        _buttons = new PanelWidget;
        _buttons.setLayout!( FillLayout, HorizontalLineupPlacer );
        addChild( _buttons );
    }

    /// Changes text.
    void loadText ( dstring v, FontFace face = null )
    {
        _text.loadText( v, face );
    }

    /// Changes the buttons.
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
