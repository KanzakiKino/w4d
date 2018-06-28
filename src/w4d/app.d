// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module w4d.app;
import w4d.event;
import std.algorithm;
import core.thread;
static import g4d;

alias ExceptionHandler = EventHandler!( bool, Exception );

class App
{
    enum DefaultSleepDuration = 33;

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
                g4d.Window.pollEvents();
                _tasks = _tasks.remove!( x => x.exec(this) );
                Thread.sleep( dur!"msecs"( sleepDuration ) );
            } catch ( Exception e ) {
                if ( !onThrown.call( e ) ) break;
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
