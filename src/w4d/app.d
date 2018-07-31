// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module w4d.app;
import w4d.event;
import std.algorithm,
       std.stdio;
import core.thread;
static import g4d;

alias ExceptionHandler = EventHandler!( bool, Exception );

class App
{
    enum DefaultSleepDuration = 10;

    protected Task[]   _tasks;
    protected string[] _args;

    uint sleepDuration;
    int  returnCode;

    ExceptionHandler onThrown;

    this ( in string[] args )
    {
        _args         = args.dup;
        sleepDuration = DefaultSleepDuration;
    }

    const @property alive () { return !!_tasks.length; }

    Task addTask ( Task newTask )
    {
        _tasks ~= newTask;
        return newTask;
    }

    int exec ()
    {
        while ( alive ) {
            try {
                _tasks = _tasks.remove!( x => x.exec(this) );
                g4d.Window.pollEvents();
                Thread.sleep( dur!"msecs"( sleepDuration ) );
            } catch ( Exception e ) {
                if ( !onThrown.call( e ) ) {
                    e.writeln;
                    break;
                }
            }
        }
        return returnCode;
    }

    void terminate ()
    {
        _tasks = [];
    }
}

interface Task
{
    // Returns true to notify to finish the task.
    bool exec ( App );
}
