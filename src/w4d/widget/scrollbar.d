// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module w4d.widget.scrollbar;
import w4d.parser.theme,
       w4d.task.window,
       w4d.widget.base,
       w4d.event;
import g4d.element.shape.rect,
       g4d.math.vector;
import std.algorithm;

alias ScrollHandler = EventHandler!( void, float );

class ScrollBarWidget (bool Horizon) : Widget
{
    enum WheelMagnification = 0.1;

    static ref getLengthRef ( ref vec2 v )
    {
        static if ( Horizon ) {
            return v.x;
        } else {
            return v.y;
        }
    }
    static auto getLength ( vec2 v )
    {
        return getLengthRef( v );
    }

    ScrollHandler onScroll;

    // Bar length. (>0)
    protected float _barLength;
    // Current value.
    protected float _value;

    // Bar element.
    protected RectElement _bar;
    // Translate.
    protected vec2 _translate;

    // Dragging offset.
    protected float _dragOffset;

    protected float getValueAt ( vec2 pos )
    {
        return getLength(pos)/getLength(style.box.clientSize);
    }

    override bool handleMouseMove ( vec2 pos )
    {
        if ( super.handleMouseMove(pos) ) return true;

        if ( isTracked ) {
            pos -= style.clientLeftTop;
            setValue( getValueAt(pos) - _dragOffset );
            return true;
        }
        return false;
    }
    override bool handleMouseButton ( MouseButton btn, bool status, vec2 pos )
    {
        if ( super.handleMouseButton(btn,status,pos) ) return true;

        if ( btn == MouseButton.Left && status ) {
            pos -= style.clientLeftTop;

            auto newValue = getValueAt( pos );
            if ( newValue > _value && newValue < _value+_barLength ) {
                _dragOffset = newValue - _value;
            } else {
                _dragOffset = _barLength/2f;
            }
            setValue( newValue - _dragOffset );
            return true;
        }
        return false;
    }
    override bool handleMouseScroll ( vec2 amount, vec2 pos )
    {
        if ( super.handleMouseScroll( amount, pos ) ) return true;

        auto add = -getLength(amount) * _barLength * WheelMagnification;
        setValue( _value + add );
        return true;
    }

    this ()
    {
        super();

        _barLength = 1f;
        _value     = 0f;

        _bar       = null;
        _translate = vec2(0,0);

        parseThemeFromFile!"theme/scrollbar.yaml"( style );
    }

    @property needDrawBar ()
    {
        return _barLength < 1f;
    }

    void setBarLength ( float barLength )
    {
        auto temp = _barLength;
        _barLength = barLength;
        correctBar();

        if ( temp != _barLength ) {
            requestLayout();
        }
    }
    void setValue ( float value )
    {
        auto temp = _value;
        _value = value;

        if ( temp != _value ) {
            correctBar();
            onScroll.call( _value );
            requestLayout();
        }
    }

    protected void correctBar ()
    {
        if ( _barLength <= 0f ) {
            _barLength = 1f;
        }
        setValue( max( 0f, _value ) );
        if ( _value+_barLength > 1f ) {
            setValue( 1f - _barLength );
        }
    }

    override void layout ()
    {
        if ( !_bar ) {
            _bar = new RectElement;
        }
        if ( needDrawBar ) {
            auto size           = style.box.clientSize;
            auto barsize        = size;
            getLengthRef(barsize) *= _barLength;
            _bar.resize( barsize );

            _translate = barsize/2;
            getLengthRef(_translate) += getLength(size)*_value;
        }

        super.layout();
    }

    override void draw ( Window w )
    {
        super.draw( w );
        if ( !needDrawBar ) return;

        auto late = style.clientLeftTop + _translate;

        auto shader = w.shaders.fill3;
        shader.use( false );
        shader.setVectors( vec3(late,0) );
        shader.color = colorset.fgColor;
        _bar.draw( shader );
    }
}

alias HorizontalScrollBarWidget = ScrollBarWidget!true;
alias VerticalScrollBarWidget   = ScrollBarWidget!false;
