// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module imgbrowser.task.download;
import w4d.event,
       w4d;
import g4d;
import std.net.curl;
import core.thread;

alias DownloadFinishHandler = EventHandler!( void, char[] );

class DownloadTask : Task
{
    protected Server _server;

    DownloadFinishHandler onFinish;

    this ( string url )
    {
        _server = new Server(url);
        _server.start();
    }

    @property finished ()
    {
        return !_server.isRunning;
    }

    bool exec ( App )
    {
        if ( finished ) {
            onFinish.call( _server.result );
            return true;
        }
        return false;
    }
}

private class Server : Thread
{
    const string url;

    protected char[] _result;
    @property result () { return _result; }

    this ( string u )
    {
        super( &exec );
        url = u;
    }

    protected void exec ()
    {
        try {
            _result = url.get();
        } catch ( Exception e ) {
            _result = [];
        }
    }
}
