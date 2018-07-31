// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module w4d.widget.input.slider;
import w4d.parser.theme,
       w4d.style.rect,
       w4d.style.scalar,
       w4d.task.window,
       w4d.widget.input.templates,
       w4d.widget.base,
       w4d.util.vector,
       w4d.event,
       w4d.exception;
import g4d.element.shape.rect,
       g4d.element.shape.regular,
       g4d.math.vector,
       g4d.shader.base;
import std.algorithm,
       std.math;

alias ValueChangeHandler = EventHandler!( void, float );

class SliderWidget(bool Horizon) : Widget
{
    mixin Lockable;

    protected float _min, _max;
    protected float _value;
    protected float _unit;

    protected float       _barLength;
    protected float       _barWeight;
    protected RectElement _bar;

    protected float                _pointerSize;
    protected RegularNgonElement!3 _pointer;

    protected bool _shift;

    ValueChangeHandler onValueChange;

    protected @property magnification ()
    {
        return _shift? 10f: 2f;
    }

    override bool handleMouseMove ( vec2 pos )
    {
        if ( super.handleMouseMove( pos ) ) return true;

        if ( isTracked && !isLocked ) {
            setValue( retrieveValueFromAbsPos( pos ) );
            return true;
        }
        return false;
    }
    override bool handleMouseButton ( MouseButton btn, bool status, vec2 pos )
    {
        if ( super.handleMouseButton( btn, status, pos ) ) return true;

        if ( btn == MouseButton.Left && status && !isLocked ) {
            setValue( retrieveValueFromAbsPos( pos ) );
            focus();
            return true;
        }
        return false;
    }
    override bool handleMouseScroll ( vec2 amount, vec2 pos )
    {
        if ( super.handleMouseScroll( amount, pos ) ) return true;
        if ( isLocked ) return false;

        auto a = (amount.x != 0)? amount.x: amount.y;
        setValue( _value - a*_unit*magnification );
        return true;
    }
    override bool handleKey ( Key key, KeyState status )
    {
        if ( super.handleKey( key, status ) ) return true;
        if ( !isFocused || isLocked ) return false;

        auto pressing = status != KeyState.Release;
        if ( key == Key.LeftShift ) {
            _shift = pressing;

        } else if ( key == Key.Left && pressing ) {
            setValue( _value - _unit*magnification );
        } else if ( key == Key.Right && pressing ) {
            setValue( _value + _unit*magnification );
        } else if ( key == Key.Home && pressing ) {
            setValue( _min );
        } else if ( key == Key.End && pressing ) {
            setValue( _max );

        } else {
            return false;
        }
        return true;
    }

    this ()
    {
        super();
        style.box.paddings    = Rect( 2.mm );
        style.box.size.height = 6.mm;
        parseThemeFromFile!"theme/slider.yaml"( style );

        setRange( 0f, 1f, 11e-4f );
        _value = 0.5;

        _barLength = 0f;
        _barWeight = 0f;
        _bar       = new RectElement;

        _pointerSize = 0f;
        _pointer     = new RegularNgonElement!3;

        _shift = false;
    }

    protected float retrieveValueFromAbsPos ( vec2 pos )
    {
        pos -= style.clientLeftTop;

        auto length = pos.length!Horizon;
        auto rate   = length / _barLength;

        return rate*rangeSize + _min;
    }

    const @property rangeSize ()
    {
        return _max - _min;
    }
    const @property valueRate ()
    {
        return (_value-_min) / rangeSize;
    }

    void setRange ( float min, float max, float unit )
    {
        enforce( min < max, "Min must be less than max." );
        enforce( unit > 0 , "Unit must be more than 0." );
        enforce( max-min >= unit, "Unit must be size of range or less." );
        _min  = min;
        _max  = max;
        _unit = unit;
        setValue( _value ); // to re-clamp value
        requestRedraw();
    }
    void setValue ( float v )
    {
        v        -= v%_unit;
        auto temp = _value;
        _value    = v.clamp( _min, _max );
        if ( _value != temp ) {
            onValueChange.call( _value );
            requestRedraw();
        }
    }

    protected void resizeElements ()
    {
        auto size = style.box.clientSize;

        auto barsz = size;
        barsz.weightRef!Horizon /= 3f;
        _bar.resize( barsz );
        _barLength = barsz.length!Horizon;
        _barWeight = barsz.weight!Horizon;

        _pointerSize =
            (size.weight!Horizon - _barWeight)/2;
        _pointer.resize( _pointerSize );
    }
    override vec2 layout ( vec2 pos, vec2 size )
    {
        scope(success) resizeElements();
        return super.layout( pos, size );
    }

    protected @property barLate ()
    {
        auto result = vec3(style.clientLeftTop,0);
        result.lengthRef!Horizon += _barLength/2;
        result.weightRef!Horizon += _barWeight/2;
        return result;
    }
    protected @property pointerLate ()
    {
        auto result = vec3(style.clientLeftTop,0);
        result.lengthRef!Horizon += _barLength*valueRate;
        result.weightRef!Horizon += _barWeight+_pointerSize;
        return result;
    }
    override void draw ( Window w )
    {
        super.draw( w );

        auto shader = w.shaders.fill3;
        auto saver  = ShaderStateSaver( shader );

        shader.use( false );
        shader.setVectors( barLate );
        shader.color = colorset.fgColor;
        _bar.draw( shader );

        shader.setVectors( pointerLate, vec3(0,0,PI) );
        _pointer.draw( shader );
    }

    override @property bool trackable () { return true; }
    override @property bool focusable () { return true; }
}

alias HorizontalSliderWidget = SliderWidget!true;
alias VerticalSliderWidget   = SliderWidget!false;
