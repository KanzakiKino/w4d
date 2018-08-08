// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module w4d.widget.input.checkbox;
import w4d.layout.lineup,
       w4d.parser.colorset,
       w4d.style.color,
       w4d.style.rect,
       w4d.style.scalar,
       w4d.style.widget,
       w4d.task.window,
       w4d.widget.base,
       w4d.widget.text,
       w4d.event,
       w4d.exception;
import g4d.element.shape.border,
       g4d.element.shape.regular,
       g4d.ft.font,
       g4d.glfw.cursor,
       g4d.math.vector,
       g4d.shader.base;
import std.math;

alias CheckHandler = EventHandler!( void, bool );

class CheckBoxWidget : Widget
{
    class CheckMarkWidget : Widget
    {
        protected RegularNgonBorderElement!4 _border;
        protected RegularNgonElement!4       _mark;

        override @property vec2 wantedSize ()
        {
            auto lineheight = _text.font.size.y;
            return vec2( lineheight, lineheight );
        }
        override @property Cursor cursor ()
        {
            return Cursor.Hand;
        }
        this ()
        {
            super();

            _border = new RegularNgonBorderElement!4;
            _mark   = new RegularNgonElement!4;

            style.box.size.width  = Scalar.Auto;
            style.box.size.height = Scalar.Auto;
        }
        override vec2 layout ( vec2 pos, vec2 size )
        {
            scope(success) {
                auto sz = style.box.clientSize.x;
                _border.resize( sz/2, 1.5f );
                _mark  .resize( sz/3 );
            }
            return super.layout( pos, size );
        }
        override void draw ( Window w, ColorSet parent )
        {
            super.draw( w, parent );

            auto shader = w.shaders.fill3;
            auto saver  = ShaderStateSaver( shader );
            auto late   = style.box.clientSize/2;
            late       += style.clientLeftTop;

            shader.use( false );
            shader.setVectors( vec3(late,0), vec3(0,0,PI/4) );
            shader.color = colorset.foreground;
            _border.draw( shader );

            if ( checked ) {
                _mark.draw( shader );
            }
        }
        override @property bool trackable () { return false; }
        override @property bool focusable () { return false; }
    }

    protected CheckMarkWidget _mark;
    protected TextWidget      _text;

    override @property Widget[] children ()
    {
        return [ _mark, _text ];
    }

    protected bool _checked;
    const @property checked () { return _checked; }

    CheckHandler onCheck;

    override bool handleMouseButton ( MouseButton btn, bool status, vec2 pos )
    {
        if ( super.handleMouseButton( btn, status, pos ) ) return true;

        if ( !style.isPointInside(pos) ) return false;

        if ( btn == MouseButton.Left && !status ) {
            setChecked( !_checked );
            return true;
        }
        return false;
    }

    this ()
    {
        super();
        setLayout!HorizontalLineupLayout;

        _mark = new CheckMarkWidget;
        _text = new TextWidget;

        _checked = false;

        style.box.margins     = Rect(1.mm);
        style.box.borderWidth = Rect(1.pixel);
    }

    void setChecked ( bool b )
    {
        auto temp = _checked;
        _checked  = b;

        if ( _checked != temp ) {
            onCheck.call( _checked );

            (_checked? &enableState: &disableState)
                ( WidgetState.Selected );
            requestRedraw();
        }
    }

    void loadText ( dstring text, FontFace face = null )
    {
        _text.loadText( text, face );
    }

    override @property bool trackable () { return true; }
    override @property bool focusable () { return true; }
}
