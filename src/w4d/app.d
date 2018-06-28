// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module w4d.app;
import std.algorithm;
import core.thread;
static import g4d;

class App
{
    enum DefaultSleepDuration = 33;

    protected Task[]   _tasks;
    protected string[] _args;

    uint sleepDuration;
    int  returnCode;

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
            g4d.Window.pollEvents();
            _tasks = _tasks.remove!( x => x.exec(this) );
            Thread.sleep( dur!"msecs"( sleepDuration ) );
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
