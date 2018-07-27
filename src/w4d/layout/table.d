// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module w4d.layout.table;
import w4d.layout.base,
       w4d.layout.exception,
       w4d.layout.fill,
       w4d.style.widget;
import g4d.math.vector;

class TableLayout : FillLayout
{
    protected const size_t _columns;
    protected const size_t _rows;

    protected size_t _index;

    protected @property childWidth ()
    {
        auto width = _style.box.size.width.calced;
        return width / _columns;
    }
    protected @property childHeight ()
    {
        auto height = _style.box.size.height.calced;
        return height / _rows;
    }
    protected @property childSize ()
    {
        return vec2( childWidth, childHeight );
    }

    this ( WidgetStyle style, size_t cols, size_t rows )
    {
        enforce( cols > 0 && rows > 0,
                "Cols and Rows must be natural number(!=0)." );
        super( style );

        _columns = cols;
        _rows    = rows;
    }

    override void push ( Layout l )
    {
        auto size = childSize;
        auto pos  = vec2( _index%_columns, _index/_rows );
        pos.x    *= size.x;
        pos.y    *= size.y;
        pos      += _style.clientLeftTop;

        l.move( pos, size );
        _index++;
    }
    override void fix ()
    {
        _index = 0;
    }
}
