// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module w4d.widget.popup.dialog.base;
import w4d.parser.colorset,
       w4d.style.rect,
       w4d.style.scalar,
       w4d.widget.popup.base,
       w4d.widget.base,
       w4d.exception;
import g4d.math.vector;

class PopupDialogWidget : PopupWidget
{
    override void handlePopup ( bool opened, WindowContext w )
    {
        if ( opened ) {
            requestLayout();
        }
        super.handlePopup( opened, w );
    }

    this ()
    {
        super();

        style.box.borderWidth = Rect(1.pixel);
        style.box.paddings    = Rect(2.mm);
    }

    override void move ( vec2, vec2 )
    {
        throw new W4dException( "Cannot move the dialog." );
    }

    override vec2 layout ( vec2 pos, vec2 parentSize )
    {
        auto size = .Widget.layout( pos, parentSize );
        auto late = (parentSize-size)/2 + pos;
        late     -= style.translate;

        shiftChildren( late - style.translate );
        style.x.alter( style.x.calced + late.x );
        style.y.alter( style.y.calced + late.y );

        return vec2(0,0);
    }
}
