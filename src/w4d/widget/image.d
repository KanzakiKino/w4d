// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module w4d.widget.image;
import w4d.task.window,
       w4d.widget.base;
import g4d.element.shape.rect,
       g4d.gl.texture,
       g4d.math.vector,
       g4d.util.bitmap;

class ImageWidget : Widget
{
    protected RectElement _imageElm;
    protected Tex2D       _texture;
    protected vec2        _imageSize;
    protected vec2        _uv;

    this ()
    {
        _imageElm = null;
        _texture  = null;
        _uv       = vec2(0,0);
    }

    void setImage (B) ( B bmp )
        if ( isBitmap!B )
    {
        if ( !bmp ) {
            _texture = null;
            _uv      = vec2(0,0);
            return;
        }

        _texture = new Tex2D( bmp );

        _imageSize = vec2(_texture.size);
        _uv.x      = bmp.width/_imageSize.x;
        _uv.y      = bmp.rows /_imageSize.y;
    }

    override void layout ()
    {
        if ( !_imageElm ) {
            _imageElm = new RectElement;
        }
        if ( _texture ) {
            auto sz = style.box.clientSize;
            _imageElm.resize( sz, _uv );
        }
        super.layout();
    }
    override void draw ( Window w )
    {
        super.draw( w );

        if ( _texture ) {
            auto shader = w.shaders.rgba3;
            auto late   = style.clientLeftTop + style.box.clientSize/2;

            shader.use();
            shader.setVectors( vec3(late,0) );
            shader.uploadTexture( _texture );
            _imageElm.draw( shader );
        }
    }
}
