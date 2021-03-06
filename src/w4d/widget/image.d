// Written in the D programming language.
/++
 + Authors: KanzakiKino
 + Copyright: KanzakiKino 2018
 + License: LGPL-3.0
++/
module w4d.widget.image;
import w4d.style.color,
       w4d.style.scalar,
       w4d.task.window,
       w4d.widget.base;
import g4d.element.shape.rect,
       g4d.gl.texture,
       g4d.shader.base,
       g4d.util.bitmap;
import gl3n.linalg;
import std.algorithm,
       std.math;

/// A widget of image.
class ImageWidget : Widget
{
    protected RectElement _imageElm;
    protected Tex2D       _texture;
    protected vec2        _imageSize;
    protected vec2        _uv;

    ///
    override @property vec2 wantedSize ()
    {
        return _imageSize;
    }

    ///
    this ()
    {
        super();

        _imageElm  = new RectElement;
        _texture   = null;
        _imageSize = vec2(0,0);
        _uv        = vec2(0,0);
    }

    /// Sets new image.
    void setImage (B) ( B bmp, bool compress = true )
        if ( isBitmap!B )
    {
        if ( !bmp ) {
            _texture   = null;
            _imageSize = vec2(0,0);
            _uv        = vec2(0,0);
            return;
        }

        _texture = new Tex2D( bmp, compress );

        _uv.x      = bmp.width*1f / _texture.size.x;
        _uv.y      = bmp.rows *1f / _texture.size.y;
        _imageSize = vec2(bmp.width,bmp.rows);
        requestLayout();
    }

    protected void resizeElement ()
    {
        if ( _texture ) {
            auto sz = style.box.clientSize;
            _imageElm.resize( sz, _uv );
        }
    }
    ///
    override vec2 layout ( vec2 pos, vec2 size )
    {
        if ( style.box.size.width.isNone && style.box.size.height.isNone ) {
            const w = _imageSize.x, h = _imageSize.y;
            const ratio = w/h;
            const maxsz = size;

            size.x = ratio * size.y;
            if ( size.x > maxsz.x ) {
                size.x = maxsz.x;
                size.y = (1f/ratio) * size.x;
            }
        }

        scope(success) resizeElement();
        return super.layout( pos, size );
    }
    ///
    override void draw ( Window w, in ColorSet parent )
    {
        super.draw( w, parent );

        if ( _texture ) {
            auto  shader = w.shaders.rgba3;
            const saver  = ShaderStateSaver( shader );
            const late   = style.clientLeftTop + style.box.clientSize/2;

            shader.use();
            shader.matrix.late = vec3( late, 0 );
            shader.matrix.rota = vec3( PI, 0, 0 );
            shader.uploadTexture( _texture );
            _imageElm.draw( shader );
        }
    }

    ///
    override @property bool trackable () { return false; }
    ///
    override @property bool focusable () { return false; }
}
