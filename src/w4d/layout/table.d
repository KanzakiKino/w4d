// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module w4d.layout.table;
import w4d.layout.base,
       w4d.layout.exception,
       w4d.layout.fill;
import gl3n.linalg;

class TableLayout : FillLayout
{
    protected const size_t _columns;
    protected const size_t _rows;

    protected @property childWidth ()
    {
        auto width = style.box.size.width.calced;
        return width / _columns;
    }
    protected @property childHeight ()
    {
        auto height = style.box.size.height.calced;
        return height / _rows;
    }
    protected @property childSize ()
    {
        return vec2( childWidth, childHeight );
    }

    this ( Layoutable owner, size_t cols, size_t rows )
    {
        enforce( cols > 0 && rows > 0,
                "Cols and Rows must be natural number(!=0)." );
        super( owner );

        _columns = cols;
        _rows    = rows;
    }

    override void place ( vec2 basePoint, vec2 parentSize )
    {
        fill( basePoint, parentSize );

        auto   size      = childSize;
        auto   children  = children;
        auto   translate = style.clientLeftTop;
        size_t index     = 0;

        for ( auto y = 0; y < _rows; y++ ) {
            for ( auto x = 0; x < _columns; x++ ) {
                if ( index >= children.length ) return;

                auto pos = vec2( size.x*x, size.y*y );
                pos     += translate;
                children[index++].layout( pos, size );
            }
        }
    }
}
