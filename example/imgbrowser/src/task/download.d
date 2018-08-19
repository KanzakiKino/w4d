// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module imgbrowser.task.download;
import w4d.event,
       w4d;
import g4d;
import std.net.curl,
       std.stdio;
import core.thread;

alias DownloadFinishHandler = EventHandler!( void, char[] );

class DownloadTask : Thread, Task
{
    const string url;

    protected char[] _result;

    DownloadFinishHandler onFinish;

    this ( string url )
    {
        super( &task );

        this.url = url;

        start();
    }
    protected void task ()
    {
        try {
            _result = url.get();
        } catch ( Exception e ) {
            _result = [];
            Log.info( "Failed to download from", url );
        }
    }

    bool exec ( App )
    {
        if ( !isRunning ) {
            onFinish.call( _result );
            return true;
        }
        return false;
    }
}
