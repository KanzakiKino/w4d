// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module imgbrowser.task.decode;
import w4d.event,
       w4d;
import g4d;
import core.sync.mutex,
       core.thread;

alias DecodeFinishHandler = EventHandler!( void, BitmapRGBA );

class DecodeTask : Thread, Task
{
    immutable string[] urls;

    protected Mutex        _mutex;
    protected BitmapRGBA[] _stack;

    DecodeFinishHandler onDecode;

    this ( string[] urls )
    {
        super( &task );

        this.urls = urls.dup;
        _mutex    = new Mutex;
        _stack    = [];

        start();
    }
    protected void task ()
    {
        foreach ( url; urls ) {
            auto media = new MediaFile( url );
            auto bmp   = media.decodeNextImage();

            synchronized ( _mutex ) {
                _stack ~= bmp;
            }
            media.dispose();
        }
    }

    override bool exec ( App )
    {
        synchronized ( _mutex ) {
            foreach ( bmp; _stack ) {
                onDecode.call( bmp );
            }
            _stack = [];
        }
        return !isRunning;
    }
}
