// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module imgbrowser.task.decode;
import w4d.event,
       w4d;
import g4d;
import core.thread;

alias DecodeFinishHandler = EventHandler!( void, BitmapRGBA );

class DecodeTask : Task
{
    protected Server _server;

    DecodeFinishHandler onFinish;

    this ( string url )
    {
        _server = new Server(url);
        _server.start();
    }

    @property finished ()
    {
        return !_server.isRunning;
    }

    override bool exec ( App )
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

    protected BitmapRGBA _result;
    @property result () { return _result; }

    this ( string u )
    {
        super( &exec );
        url = u;
    }

    protected void exec ()
    {
        try {
            auto media = new MediaFile( url );
            _result = media.decodeNextImage();
        } catch ( Exception e ) {
            _result = null;
        }
    }
}
