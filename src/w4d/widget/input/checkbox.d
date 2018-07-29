// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module w4d.widget.input.checkbox;
import w4d.parser.theme,
       w4d.style.rect,
       w4d.style.scalar,
       w4d.style.widget,
       w4d.task.window,
       w4d.widget.input.templates,
       w4d.widget.text,
       w4d.event;
import g4d.element.shape.border,
       g4d.element.shape.regular,
       g4d.ft.font,
       g4d.math.vector,
       g4d.shader.base;
import std.math;

alias CheckHandler = EventHandler!( void, bool );

class CheckBoxWidget : TextWidget
{
    mixin Lockable;

    protected bool _checked;
    const @property checked () { return _checked; }

    protected RegularNgonBorderElement!4 _boxBorder;
    protected RegularNgonElement!4       _checkMark;

    CheckHandler onCheck;

    override bool handleMouseButton ( MouseButton btn, bool status, vec2 pos )
    {
        if ( super.handleMouseButton( btn, status, pos ) ) return true;

        if ( isLocked || !style.isPointInside( pos ) ) {
            return false;
        }
        if ( btn == MouseButton.Left && !status ) {
            setChecked( !_checked );
            return true;
        }
        return false;
    }

    this ()
    {
        super();
        style.box.paddings = Rect( 2.mm );
        parseThemeFromFile!"theme/checkbox.yaml"( style );

        _checked = false;

        _boxBorder = new RegularNgonBorderElement!4;
        _checkMark = new RegularNgonElement!4;

        textOriginRate = vec2(1f,0.5f);
        textPosRate    = vec2(1f,0.5f);
    }

    void setChecked ( bool c )
    {
        auto temp = _checked;
        _checked = c;

        if ( temp != _checked ) {
            onCheck.call( _checked );

            (_checked? &enableState: &disableState)( WidgetState.Selected );
            requestRedraw();
        }
    }
    override void loadText ( dstring v, FontFace font = null )
    {
        super.loadText( v, font );
        if ( font ) {
            _boxBorder.resize( font.size.y/2, 1.5f );
            _checkMark.resize( font.size.y/3 );
        }
    }
    override void adjustSize ()
    {
        super.adjustSize();
        style.box.size.width = (font.size.y+_textElm.size.x).pixel;
    }

    protected @property checkBoxLate ()
    {
        return vec3( _font.size.y/2, _font.size.y/2, 0 ) +
            style.clientLeftTop;
    }
    override void draw ( Window w )
    {
        super.draw( w );

        auto shader = w.shaders.fill3;
        auto saver  = ShaderStateSaver( shader );

        shader.use( false );
        shader.setVectors( checkBoxLate, vec3(0,0,PI/4) );
        shader.color = colorset.fgColor;

        _boxBorder.draw( shader );
        if ( _checked ) {
            _checkMark.draw( shader );
        }
    }
}
