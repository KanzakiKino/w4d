// Written in the D programming language.
/++
 + Authors: KanzakiKino
 + Copyright: KanzakiKino 2018
 + License: LGPL-3.0
++/
module w4d.log;
import w4d.exception;
import std.conv,
       std.format,
       std.stdio,
       std.string;

/// An enum of log levels.
/// The uint value is priority of the level.
enum LogLevel : uint
{
    Trace = 0,
    Info,
    Warn,
    Error,
    Fatal,
}

/// Converts LogLevel to string.
@property toString ( LogLevel lv, bool colored )
{
    string result = "";
    final switch ( lv ) with ( LogLevel )
    {
        case Trace: result = "trace";
                    break;
        case Info : result = "info";
                    break;
        case Warn : result = "warn";
                    break;
        case Error: result = "error";
                    break;
        case Fatal: result = "fatal";
                    break;
    }
    if ( colored ) {
        result = lv.toColorCode ~ result ~ "\x1b[39m";
    }
    return result;
}
/// Converts LogLevel to color code in terminal.
@property toColorCode ( LogLevel lv )
{
    final switch ( lv ) with ( LogLevel )
    {
        case Trace: return "\x1b[37m"; // white
        case Info : return "\x1b[36m"; // cyan
        case Warn : return "\x1b[33m"; // yellow
        case Error: return "\x1b[35m"; // magenta
        case Fatal: return "\x1b[31m"; // red
    }
}

/// A logger used in w4d library.
class W4dLogger
{
    protected __gshared W4dLogger _instance;
    ///
    shared static this ()
    {
        new W4dLogger;
    }
    /// An unique instance of W4dLogger.
    static @property instance ()
    {
        enforce( _instance, "W4dLogger isn't created yet." );
        return _instance;
    }

    protected File _output;
    protected bool _colored;

    protected LogLevel _outputThreshold;
    protected LogLevel _throwThreshold;

    ///
    this ()
    {
        enforce( !_instance, "W4dLogger is created already." );
        _instance = this;

        _output  = stdout;
        _colored = true;

        _outputThreshold = LogLevel.Trace;
        _throwThreshold  = LogLevel.Fatal;

        trace( "W4dLogger has been initialized." );
    }
    ~this ()
    {
        trace( "W4dLogger has been deleted." );
    }

    /// Changes output file. Specify stdout to output to the terminal.
    /// When colored is true, logs will be colored for the terminal.
    void setOutputFile ( File f, bool colored = false )
    {
        _output  = f;
        _colored = colored;
    }
    /// Changes threshold levels for handling logs.
    void setThreshold ( LogLevel out_, LogLevel throw_ )
    {
        _outputThreshold = out_;
        _throwThreshold  = throw_;
    }

    protected string formatLog ( LogLevel lv, string text,
            string file, size_t line, string func )
    {
        return ("[%s] %s\n"~
            "    %s at %d (%s)").
            format( lv.toString(_colored), text, file, line, func );
    }

    protected void writeLog
        ( string file = __FILE__, size_t line = __LINE__, string func = __FUNCTION__, Args... )
        ( LogLevel lv, Args args )
    {
        if ( lv < _outputThreshold ) return;

        string text;
        foreach ( arg; args ) {
            text ~= arg.to!string ~ " ";
        }
        text = text.chop;

        auto formattedText = formatLog(
                lv, text, file, line, func );
        _output.writeln( formattedText );

        if ( lv >= _throwThreshold ) {
            auto msg = "%s (%s)".format( text, func );
            throw new W4dException( msg, file, line );
        }
    }

    /// Makes new trace log.
    void trace
        ( string file = __FILE__, size_t line = __LINE__, string func = __FUNCTION__, Args... )
        ( Args args )
    {
        writeLog!( file, line, func )( LogLevel.Trace, args );
    }
    /// Makes new info log.
    void info
        ( string file = __FILE__, size_t line = __LINE__, string func = __FUNCTION__, Args... )
        ( Args args )
    {
        writeLog!( file, line, func )( LogLevel.Info, args );
    }
    /// Makes new warning log.
    void warn
        ( string file = __FILE__, size_t line = __LINE__, string func = __FUNCTION__, Args... )
        ( Args args )
    {
        writeLog!( file, line, func )( LogLevel.Warn, args );
    }
    /// Makes new error log.
    void error
        ( string file = __FILE__, size_t line = __LINE__, string func = __FUNCTION__, Args... )
        ( Args args )
    {
        writeLog!( file, line, func )( LogLevel.Error, args );
    }
    /// Makes new fatal log.
    void fatal
        ( string file = __FILE__, size_t line = __LINE__, string func = __FUNCTION__, Args... )
        ( Args args )
    {
        writeLog!( file, line, func )( LogLevel.Fatal, args );
    }
}

/// Alias for the instance of W4dLogger.
alias Log = W4dLogger.instance;
