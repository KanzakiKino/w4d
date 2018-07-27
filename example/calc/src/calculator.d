// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module calc.calculator;

enum Operator
{
    Plus,
    Minus,
    Multiple,
    Division,
    Equal,
}
@property Operator toOperator ( dchar o )
{
    switch ( o ) with ( Operator ) {
        case '+': return Plus;
        case '-': return Minus;
        case '*': return Multiple;
        case '/': return Division;
        case '=': return Equal;

        default: assert( false );
    }
}

class Calculator
{
    enum State
    {
        NumberInput,
        OperatorInput,
        Result, // After pushing equal.
    }

    protected State _status;

    protected long     _stackedNumber;
    protected Operator _op;
    protected long     _currentNumber;

    const @property result () { return _currentNumber; }

    this ()
    {
        init();
    }

    void init ()
    {
        _status = State.NumberInput;

        _stackedNumber = 0;
        _op            = Operator.Plus;
        _currentNumber = 0;
    }

    protected void calculate ()
    {
        assert( _op != Operator.Equal,
             "Equation is not supported." );
        if ( _status == State.Result ) return;

        auto l = _stackedNumber, r = _currentNumber;

        switch ( _op ) with ( Operator ) {
            case Plus:
                _currentNumber = l+r;
                break;
            case Minus:
                _currentNumber = l-r;
                break;
            case Multiple:
                _currentNumber = l*r;
                break;
            case Division:
                if ( r == 0 ) {
                    init();
                } else {
                    _currentNumber = l/r;
                }
                break;

            default: assert( false );
        }
        _stackedNumber = 0;
    }

    void pushNumber ( int n )
    {
        assert( n >= 0 && n < 10,
             "Pushed number must be 0 or more and less than 10.");
        if ( _currentNumber > 1e8 ) return;

        if ( _status == State.OperatorInput ) {
            _status = State.NumberInput;
            _stackedNumber = _currentNumber;
            _currentNumber = 0;

        } else if ( _status == State.Result ) {
            init();
        }
        _currentNumber *= 10;
        _currentNumber += n;
    }
    void pushOperator ( Operator op )
    {
        if ( op == Operator.Equal ) {
            calculate();
            _status = State.Result;

        } else {
            calculate();
            _status = State.OperatorInput;
            _op = op;
        }
    }
}
