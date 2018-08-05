// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module w4d.widget.mdi.client;
import w4d.layout.lineup,
       w4d.style.rect,
       w4d.style.scalar,
       w4d.task.window,
       w4d.widget.mdi.host,
       w4d.widget.mdi.titlebar,
       w4d.widget.base,
       w4d.widget.panel,
       w4d.widget.root,
       w4d.widget.text;
import g4d.ft.font,
       g4d.math.vector;

class MdiClientWidget : PanelWidget, MdiClient
{
    mixin TitleBar;

    protected MdiHostWidget _host;

    protected TitleBarWidget _titlebar;
    protected RootWidget     _root;

    protected vec2 _pos;
    @property vec2 pos () { return _pos; }

    protected vec2 _size;
    @property vec2 size () { return _size; }

    this ()
    {
        super();
        style.box.paddings = Rect(1.mm);
        colorset.bgColor = vec4(0.4,0.4,0.4,1);
        setLayout!VerticalLineupLayout;

        _host = null;

        _titlebar = new TitleBarWidget;
        addChild( _titlebar );

        _root = new RootWidget;
        _root.style.box.size.width  = Scalar.Auto;
        _root.style.box.size.height = Scalar.Auto;
        _root.colorset.bgColor = vec4(1,1,1,1); // TODO
        addChild( _root );

        _pos  = vec2(0,0);
        _size = vec2(320,240);
    }

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

    override vec2 layout ( vec2 basept, vec2 size )
    {
        return super.layout( basept+_pos, _size );
    }
}
