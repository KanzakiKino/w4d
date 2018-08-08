// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module w4d.widget.scrollbar;
import w4d.parser.theme,
       w4d.style.color,
       w4d.style.scalar,
       w4d.task.window,
       w4d.widget.base,
       w4d.util.vector,
       w4d.event;
import g4d.element.shape.rect,
       g4d.math.vector,
       g4d.shader.base;
import std.algorithm;

alias ScrollHandler = EventHandler!( void, float );

class ScrollBarWidget (bool Horizon) : Widget
{
    enum WheelMagnification = 0.1;

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
        return pos.length!Horizon /
            style.box.clientSize.length!Horizon;
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

        auto add = -amount.length!Horizon * _barLength * WheelMagnification;
        setValue( _value + add );
        return true;
    }

    void handleScroll ( float v )
    {
        onScroll.call( v );
    }

    this ()
    {
        super();

        _barLength = 1f;
        _value     = 0f;

        _bar       = new RectElement;
        _translate = vec2(0,0);

        static if ( Horizon ) {
            style.box.size.height = 3.mm;
        } else {
            style.box.size.width  = 3.mm;
        }
    }

    @property needDrawBar ()
    {
        return _barLength < 1f;
    }

    void setBarLength ( float newlen )
    {
        newlen = newlen.clamp( 0f, 1f );
        auto temp = _barLength;
        _barLength = newlen;

        correctBar();
        handleScroll( _value );

        if ( temp != _barLength ) {
            resizeElements();
        }
    }
    void setValue ( float value )
    {
        auto temp = _value;
        _value = value;

        if ( temp != _value ) {
            correctBar();
            handleScroll( _value );
            resizeElements();
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

    protected void resizeElements ()
    {
        if ( !style.isCalced ) {
            requestLayout();

        } else if ( needDrawBar ) {
            auto size    = style.box.clientSize;
            auto barsize = size;
            barsize.lengthRef!Horizon *= _barLength;
            _bar.resize( barsize );

            _translate = barsize/2;
            _translate.lengthRef!Horizon +=
                size.length!Horizon*_value;
        }
    }
    override vec2 layout ( vec2 pos, vec2 size )
    {
        scope(success) resizeElements();
        return super.layout( pos, size );
    }

    override void draw ( Window w, ColorSet parent )
    {
        super.draw( w, parent );
        if ( !needDrawBar ) return;

        auto late = style.clientLeftTop + _translate;

        auto shader = w.shaders.fill3;
        auto saver  = ShaderStateSaver( shader );
        shader.use( false );
        shader.setVectors( vec3(late,0) );
        shader.color = colorset.foreground;
        _bar.draw( shader );
    }

    override @property bool trackable () { return true; }
    override @property bool focusable () { return true; }
}

alias HorizontalScrollBarWidget = ScrollBarWidget!true;
alias VerticalScrollBarWidget   = ScrollBarWidget!false;
