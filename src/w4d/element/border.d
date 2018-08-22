// Written in the D programming language.
/++
 + Authors: KanzakiKino
 + Copyright: KanzakiKino 2018
 + License: LGPL-3.0
++/
module w4d.element.border;
import w4d.style.box;
import g4d.element.shape.rect,
       g4d.element.base,
       g4d.gl.buffer,
       g4d.shader.base;
import gl3n.linalg;
import std.algorithm;

/// An element of border.
/// 0:top, 1:right, 2:bottom, 3:left
class BoxBorderElement : Element
{
    enum Indices = [0,1,2,3,4,5,6,7,0,1];

    protected vec3 _pos;
    protected bool _isZero;

    protected ElementArrayBuffer _indicesBuf;
    protected ArrayBuffer        _posBuf;

    ///
    this ()
    {
        _pos    = vec3(0,0,0);
        _isZero = true;

        _indicesBuf = new ElementArrayBuffer( Indices );
        _posBuf     = new ArrayBuffer( new float[8*4] );
    }

    ///
    void resize ( BoxStyle box )
    {
        const insz = box.borderInsideSize;
        const float iright  = insz.x/2;
        const float ileft   = -iright;
        const float itop    = insz.y/2;
        const float ibottom = -itop;

        const bwidth  = box.borderWidth;
        const leftw   = bwidth.left.calced;
        const topw    = bwidth.top.calced;
        const rightw  = bwidth.right.calced;
        const bottomw = bwidth.bottom.calced;

        if ( leftw+topw+rightw+bottomw == 0 ) {
            _isZero = true;
            return;
        }
        _isZero = false;

        _posBuf.overwrite( [
            ileft-leftw, itop-topw, 0f, 1f,
            ileft      , itop     , 0f, 1f,

            iright+rightw, itop-topw, 0f, 1f,
            iright       , itop     , 0f, 1f,

            iright+rightw, ibottom+bottomw, 0f, 1f,
            iright       , ibottom        , 0f, 1f,

            ileft-leftw, ibottom+bottomw, 0f, 1f,
            ileft      , ibottom        , 0f, 1f,
        ] );

        _pos = vec3(box.collisionSize/2, 0);
    }

    ///
    void clear ()
    {
        _isZero = true;
    }

    ///
    void draw ( Shader s )
    {
        if ( _isZero ) return;

        s.matrix.late = s.matrix.late+_pos;

        s.uploadPositionBuffer( _posBuf );
        s.drawElementsStrip( _indicesBuf, 10 );
    }
}
