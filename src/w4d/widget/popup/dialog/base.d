// Written in the D programming language.
/++
 + Authors: KanzakiKino
 + Copyright: KanzakiKino 2018
 + License: LGPL-3.0
++/
module w4d.widget.popup.dialog.base;
import w4d.parser.colorset,
       w4d.style.rect,
       w4d.style.scalar,
       w4d.widget.popup.base,
       w4d.widget.base,
       w4d.exception;
import gl3n.linalg;

/// A base widget of popup dialog.
class PopupDialogWidget : PopupWidget
{
    ///
    override void handlePopup ( bool opened, WindowContext w )
    {
        if ( opened ) {
            requestLayout();
        }
        super.handlePopup( opened, w );
    }

    ///
    this ()
    {
        super();

        parseColorSetsFromFile!"colorset/dialog.yaml"( style );
        style.box.borderWidth = Rect(1.pixel);
        style.box.paddings    = Rect(2.mm);
    }

    ///
    override void move ( vec2, vec2 )
    {
        throw new W4dException( "Cannot move the dialog." );
    }

    ///
    override vec2 layout ( vec2 pos, vec2 parentSize )
    {
        const size = .Widget.layout( pos, parentSize );
        auto  late = (parentSize-size)/2 + pos;
        late      -= style.translate;

        shift( late - style.translate );

        return vec2(0,0);
    }
}
