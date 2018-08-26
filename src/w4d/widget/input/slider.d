// Written in the D programming language.
/++
 + Authors: KanzakiKino
 + Copyright: KanzakiKino 2018
 + License: LGPL-3.0
++/
module w4d.widget.input.slider;
import w4d.parser.colorset,
       w4d.style.color,
       w4d.style.rect,
       w4d.style.scalar,
       w4d.task.window,
       w4d.widget.base,
       w4d.util.vector,
       w4d.event,
       w4d.exception;
import g4d.element.shape.rect,
       g4d.element.shape.regular,
       g4d.glfw.cursor,
       g4d.shader.base;
import gl3n.linalg;
import std.algorithm,
       std.math;

/// A handler that handles changing value of slider.
alias ValueChangeHandler = EventHandler!( void, float );

/// A widget of slider.
class SliderWidget(bool H) : Widget
{
    /// Whether this slider is horizon.
    alias Horizon = H;

    protected float _min, _max;
    protected float _value;
    protected float _unit;

    protected float       _barLength;
    protected float       _barWeight;
    protected RectElement _bar;

    protected float                _pointerSize;
    protected RegularNgonElement!3 _pointer;

    ///
    ValueChangeHandler onValueChange;

    protected @property magnification ()
    {
        enforce( _context );
        return _context.shift? 10f: 2f;
    }

    ///
    override bool handleMouseMove ( vec2 pos )
    {
        if ( super.handleMouseMove( pos ) ) return true;

        if ( isTracked && !status.locked ) {
            setValue( retrieveValueFromAbsPos( pos ) );
            return true;
        }
        return false;
    }
    ///
    override bool handleMouseButton ( MouseButton btn, bool status, vec2 pos )
    {
        if ( super.handleMouseButton( btn, status, pos ) ) return true;

        if ( btn == MouseButton.Left && status && !_status.locked ) {
            setValue( retrieveValueFromAbsPos( pos ) );
            focus();
            return true;
        }
        return false;
    }
    ///
    override bool handleMouseScroll ( vec2 amount, vec2 pos )
    {
        if ( super.handleMouseScroll( amount, pos ) ) return true;
        if ( status.locked ) return false;

        const a = (amount.x != 0)? amount.x: amount.y;
        setValue( _value - a*_unit*magnification );
        return true;
    }
    ///
    override bool handleKey ( Key key, KeyState status )
    {
        if ( super.handleKey( key, status ) ) return true;
        if ( !isFocused || _status.locked ) return false;

        const pressing = status != KeyState.Release;
        if ( key == Key.Left && pressing ) {
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

    ///
    override @property const(Cursor) cursor ()
    {
        static if ( Horizon ) {
            return Cursor.HResize;
        } else {
            return Cursor.VResize;
        }
    }

    ///
    this ()
    {
        super();

        setRange( 0f, 1f, 11e-4f );
        _value = 0.5;

        _barLength = 0f;
        _barWeight = 0f;
        _bar       = new RectElement;

        _pointerSize = 0f;
        _pointer     = new RegularNgonElement!3;

        style.box.size.height = 6.mm;
        style.box.paddings    = Rect(2.mm);
        style.box.margins     = Rect(1.mm);
        style.box.borderWidth = Rect(1.pixel);
    }

    protected float retrieveValueFromAbsPos ( vec2 pos )
    {
        pos -= style.clientLeftTop;

        const length = pos.getLength!H;
        const rate   = length / _barLength;

        return rate*rangeSize + _min;
    }

    ///
    @property rangeSize ()
    {
        return _max - _min;
    }
    ///
    @property valueRate ()
    {
        return (_value-_min) / rangeSize;
    }

    /// Sets range of slider value.
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
    /// Changes value.
    void setValue ( float v )
    {
        v         -= v%_unit;
        const temp = _value;
        _value     = v.clamp( _min, _max );
        if ( _value != temp ) {
            onValueChange.call( _value );
            requestRedraw();
        }
    }

    protected void resizeElements ()
    {
        const size = style.box.clientSize;

        auto barsz = vec2( size );
        barsz.getWeight!H /= 3f;
        _bar.resize( barsz );
        _barLength = barsz.getLength!H;
        _barWeight = barsz.getWeight!H;

        _pointerSize =
            (size.getWeight!H - _barWeight) / 2;
        _pointer.resize( _pointerSize );
    }
    ///
    override vec2 layout ( vec2 pos, vec2 size )
    {
        scope(success) resizeElements();
        return super.layout( pos, size );
    }

    protected @property barLate ()
    {
        auto result = vec3(style.clientLeftTop,0);
        result.getLength!H += _barLength / 2;
        result.getWeight!H += _barWeight / 2;
        return result;
    }
    protected @property pointerLate ()
    {
        auto result = vec3(style.clientLeftTop,0);
        result.getLength!H += _barLength * valueRate;
        result.getWeight!H += _barWeight + _pointerSize;
        return result;
    }
    ///
    override void draw ( Window w, in ColorSet parent )
    {
        super.draw( w, parent );

        auto  shader = w.shaders.fill3;
        const saver  = ShaderStateSaver( shader );

        shader.use();
        shader.matrix.late = barLate;
        shader.color       = colorset.foreground;
        _bar.draw( shader );

        shader.matrix.late = pointerLate;
        shader.matrix.rota = vec3( 0, 0, PI );
        _pointer.draw( shader );
    }

    ///
    override @property bool trackable () { return true; }
    ///
    override @property bool focusable () { return true; }
}

/// A widget of horizontal slider.
alias HorizontalSliderWidget = SliderWidget!true;
/// A widget of vertical slider.
alias VerticalSliderWidget   = SliderWidget!false;
