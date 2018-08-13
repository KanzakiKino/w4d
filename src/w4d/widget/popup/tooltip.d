// Written in the D programming language.
/++
 + Authors: KanzakiKino
 + Copyright: KanzakiKino 2018
 + License: LGPL-3.0
++/
module w4d.widget.popup.tooltip;
import w4d.parser.colorset,
       w4d.style.rect,
       w4d.style.scalar,
       w4d.widget.popup.base,
       w4d.widget.text;
import g4d.ft.font;
import gl3n.linalg;

/// A widget of tooltip.
class PopupTooltipWidget : PopupWidget
{
    protected TextWidget _text;

    ///
    override bool handleMouseMove ( vec2 pos )
    {
        if ( super.handleMouseMove(pos) ) return true;
        close();
        return true;
    }

    ///
    this ()
    {
        super();

        _text = new TextWidget;
        addChild( _text );

        parseColorSetsFromFile!"colorset/menu.yaml"( style );
        style.box.borderWidth = Rect(1.pixel);
    }

    /// Changes tooltip text.
    void loadText ( dstring v, FontFace face = null )
    {
        _text.loadText( v, face );
    }

    /// Moves to the pos.
    void move ( vec2 pos )
    {
        super.move( pos, _text.wantedSize );
    }
}
