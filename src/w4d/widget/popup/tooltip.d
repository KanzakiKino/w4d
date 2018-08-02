// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module w4d.widget.popup.tooltip;
import w4d.parser.theme,
       w4d.style.rect,
       w4d.style.scalar,
       w4d.widget.popup.base,
       w4d.widget.text;
import g4d.ft.font,
       g4d.math.vector;

class TooltipPopupWidget : PopupWidget
{
    protected TextWidget _text;

    override bool handleMouseMove ( vec2 pos )
    {
        if ( super.handleMouseMove(pos) ) return true;
        close();
        return true;
    }

    this ()
    {
        super();

        _text = new TextWidget;
        addChild( _text );

        parseThemeFromFile!"theme/tooltip.yaml"( style );
        style.box.borderWidth = Rect(1.pixel);
    }

    void loadText ( dstring v, FontFace face = null )
    {
        _text.loadText( v, face );
    }

    void move ( vec2 pos )
    {
        super.move( pos, _text.wantedSize );
    }
}
