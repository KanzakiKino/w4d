// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module imgbrowser.util.htmlimg;
import std.net.curl,
       std.conv,
       std.string;

unittest
{
    auto searcher = new ImgSearcher( "http://moeimg.net/12029.html" );
    while ( true ) {
        auto url = searcher.pop;
        if ( url == "" ) break;

        import std.stdio;
        url.writeln;
    }
}

class ImgSearcher
{
    const string source;

    protected size_t _index;

    this ( string url )
    {
        source = url.get().to!string;
        clear();
    }
    this ( char[] src )
    {
        source = src.to!string;
        clear();
    }

    protected bool seekTo ( string v )
    {
        auto i = source.indexOf( v, _index );
        if ( i < 0 ) return false;

        _index = i.to!size_t + v.length;
        return true;
    }

    string pop ()
    {
        if ( !seekTo( "<img"   ) ) return "";
        if ( !seekTo( "src=\"" ) ) return "";

        auto start = _index;
        if ( !seekTo( "\"" ) ) return "";
        return source[start.._index-1];
    }

    void clear ()
    {
        _index = 0;
    }
}
