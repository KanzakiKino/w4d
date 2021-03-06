// Written in the D programming language.
/++
 + Authors: KanzakiKino
 + Copyright: KanzakiKino 2018
 + License: LGPL-3.0
++/
module w4d.app;
import w4d.event,
       w4d.log;
import std.algorithm,
       std.stdio;
import core.thread;
static import g4d;

/// A handler type to catch the exception thrown at inside of main loop.
alias ExceptionHandler = EventHandler!( bool, Exception );

/// An object of application.
/// Manages all tasks executing.
class App
{
    protected Task[]   _tasks;

    /// Duration in milliseconds to sleep in each frames.
    uint sleepDuration;
    /// Status code that main function returns.
    int returnCode;

    // Arguments of main function.
    immutable string[] args;

    /// A handler to catch the exception thrown at inside of main loop.
    ExceptionHandler onThrown;

    ///
    this ( in string[] args )
    {
        this.args     = args.idup;
        sleepDuration = 10;
    }

    /// Checks if 1 or more tasks are executing.
    const @property alive () { return !!_tasks.length; }

    /// Adds the task.
    Task addTask ( Task newTask )
    {
        _tasks ~= newTask;
        Log.trace( newTask, "was added as Task." );
        return newTask;
    }

    /// Enters main loop.
    /// Returns: Status code.
    int exec ()
    {
        while ( alive ) {
            try {
                // Adding tasks is possible inside of remove template.
                auto temp = _tasks;
                _tasks    = [];
                _tasks   ~= temp.remove!( x => x.exec(this) );

                g4d.Window.pollEvents();
                Thread.sleep( dur!"msecs"( sleepDuration ) );

            } catch ( Exception e ) {
                if ( !onThrown.call( e ) ) {
                    Log.info( "An exception wasn't caught by anyone." );
                    throw e;
                }
            }
        }
        return returnCode;
    }

    /// Terminates all tasks forcibly.
    /// Escapes from main loop because all tasks will be deleted.
    void terminate ()
    {
        _tasks = [];
        Log.warn( "App is terminating forcibly." );
    }
}

/// An interface of task that App does.
interface Task
{
    /// Returns true to notify to finish the task.
    bool exec ( App );
}
