// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module w4d.widget.mdi.client;
import w4d.layout.gravity,
       w4d.layout.lineup,
       w4d.layout.split,
       w4d.style.rect,
       w4d.style.scalar,
       w4d.task.window,
       w4d.widget.mdi.host,
       w4d.widget.mdi.titlebar,
       w4d.widget.mdi.window,
       w4d.widget.base,
       w4d.widget.button,
       w4d.widget.panel,
       w4d.widget.text,
       w4d.exception;
import g4d.ft.font,
       g4d.glfw.cursor,
       g4d.math.vector;
import std.algorithm;

class MdiClientWidget : PanelWidget, MdiClient
{
    mixin TitleBar;

    protected MdiHostWidget _host;

    protected TitleBarWidget _titlebar;
    protected PanelWidget    _contents;

    this ()
    {
        super();
        style.box.paddings = Rect(1.mm);
        colorset.bgColor = vec4(0.4,0.4,0.4,1);
        setLayout!VerticalSplitLayout;

        _host = null;

        _titlebar = new TitleBarWidget;
        addChild( _titlebar );

        _contents = new PanelWidget;
        _contents.style.box.size.width  = Scalar.Auto;
        _contents.style.box.size.height = Scalar.Auto;
        _contents.colorset.bgColor = vec4(1,1,1,1); // TODO
        addChild( _contents );

        _maxSize = vec2(int.max,int.max);
        _minSize = vec2(0,0);

        _pos  = vec2(0,0);
        _size = vec2(320,240);
    }

    mixin WindowOperations;

    @property Widget widget ()
    {
        return cast(Widget) this;
    }
    void setHost ( MdiHostWidget host )
    {
        _host = host;
    }

    void loadText ( dstring v, FontFace face = null )
    {
        _titlebar._title.loadText( v, face );
    }

    override void requestLayout ()
    {
        super.requestLayout();
        requestRedraw();
    }
    override vec2 layout ( vec2 basept, vec2 size )
    {
        return super.layout( basept+_pos, _size );
    }

    override @property bool trackable () { return true; }
}
