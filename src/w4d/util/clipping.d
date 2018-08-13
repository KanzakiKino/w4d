// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module w4d.util.clipping;
import g4d;
import std.algorithm;

class ClipRect
{
    protected struct Rect
    {
        vec2 pos; // center of the rect.
        vec2 size;
    }

    protected Rect[]       _rcStack;
    protected RectElement  _elm;
    protected Fill3DShader _shader;

    this ( Fill3DShader s )
    {
        _rcStack = [];
        _elm     = new RectElement;
        _shader  = s;
    }

    @property isClipping ()
    {
        return !!_rcStack.length;
    }
    protected @property currentRect ()
    {
        if ( isClipping ) {
            return _rcStack[$-1];
        }
        return Rect( vec2(0,0), vec2(int.max,int.max) );
    }

    void pushRect ( vec2 pos, vec2 size )
    {
        auto left   = pos.x;
        auto top    = pos.y;
        auto right  = pos.x + size.x;
        auto bottom = pos.y + size.y;

        auto cur    = currentRect;
        auto curpos = cur.pos - cur.size/2;

        left   = max( left  , curpos.x );
        top    = max( top   , curpos.y );
        right  = min( right , curpos.x+cur.size.x );
        bottom = min( bottom, curpos.y+cur.size.y );

        auto rpos  = vec2(left,top);
        auto rsize = vec2(right,bottom) - pos;

        rpos     += rsize/2; // pos is center of rect
        _rcStack ~= Rect( rpos, rsize );
        apply();
    }

    void popRect ()
    {
        if ( isClipping ) {
            _rcStack = _rcStack[0..$-1];
        }
        apply();
    }

    void apply ()
    {
        if ( !isClipping ) {
            StencilBuffer.disable();
            return;
        }

        StencilBuffer.enable();
        StencilBuffer.clear( 0 );

        DepthBuffer.mask( false );
        ColorBuffer.mask( false, false, false, false );

        StencilBuffer.startModify( 1 );

        auto rc = currentRect;
        _elm.resize( rc.size );

        _shader.use();
        _shader.matrix.late = vec3( rc.pos, 0 );
        _elm.draw( _shader );

        StencilBuffer.startTest( 1 );
        DepthBuffer.mask( true );
        ColorBuffer.mask( true, true, true, true );
    }
}
