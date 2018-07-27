// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module calc.context;
import calc.calculator;
import std.conv,
       std.traits;

class AppContext
{
    protected static AppContext _instance;
    static @property instance () { return _instance; }

    protected ResultDisplay _display;
    protected Calculator    _calculator;

    this ( ResultDisplay d )
    {
        assert( !_instance, "AppContext is already created." );
        assert( d, "ResultDisplay is null." );

        _instance = this;

        _display    = d;
        _calculator = new Calculator;
        reset();
    }

    void push (T) ( T v )
    {
        static if ( is(T==Operator) ) {
            _calculator.pushOperator( v );
        } else static if ( isNumeric!T ) {
            _calculator.pushNumber( v );
        } else {
            static assert( false, "Unexpected type: "~
                    __traits(identifier,typeof(T)) );
        }
        _display.pushText( _calculator.result.to!dstring );
    }
    void reset ()
    {
        _calculator.init();
        _display.pushText( _calculator.result.to!dstring );
    }
}
alias CalcContext = AppContext.instance;

interface ResultDisplay
{
    void pushText ( dstring );
}
