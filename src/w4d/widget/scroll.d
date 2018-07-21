// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module w4d.widget.scroll;
import w4d.layout.lineup,
       w4d.layout.split,
       w4d.task.window,
       w4d.widget.panel,
       w4d.widget.scrollbar;
import g4d.math.matrix,
       g4d.math.vector,
       g4d.shader.base;

class ScrollPanelWidget(bool Horizon) : PanelWidget
{
    protected class CustomScrollBarWidget : ScrollBarWidget!Horizon
    {
        this ()
        {
            super();
        }

        override void handleScroll ( float v )
        {
            super.handleScroll( v );

            _contents.scroll = vec2(0,0);
            static if ( Horizon ) {
                _contents.scroll.x = v*_contents.size.x;
            } else {
                _contents.scroll.y = v*_contents.size.y;
            }
        }
    }
    protected class CustomPanelWidget : PanelWidget
    {
        vec2 scroll;
        vec2 size;

        override bool handleMouseScroll ( vec2 amount, vec2 pos )
        {
            if ( super.handleMouseScroll( amount, pos ) ) return true;
            return _scrollbar.handleMouseScroll( amount, pos );
        }

        this ()
        {
            super();
            scroll = vec2(0,0);
            size   = vec2(0,0);

            setLayout!( LineupLayout!Horizon );
        }

        override void layout ()
        {
            super.layout();

            auto clientSize = style.box.clientSize;

            if ( children.length ) {
                auto last = children[$-1];
                size = last.style.translate +
                    last.style.box.collisionSize;
            } else {
                size = clientSize;
            }

            static if ( Horizon ) {
                _scrollbar.setBarLength( clientSize.x/size.x );
            } else {
                _scrollbar.setBarLength( clientSize.y/size.y );
            }
        }

        override void draw ( Window w )
        {
            w.basePoint -= scroll;
            w.clip( vec2i(style.clientLeftTop), vec2i(style.box.clientSize) );

            super.draw( w );

            w.basePoint += scroll;
            w.clip( vec2i(0,0), w.size ); // FIXME: Nested ScrollPanel makes an issue.
        }
    }

    protected CustomPanelWidget     _contents;
    protected CustomScrollBarWidget _scrollbar;

    @property PanelWidget contents () { return _contents; }

    this ()
    {
        super();
        setLayout!( SplitLayout!(!Horizon) );

        _contents  = new CustomPanelWidget;
        _scrollbar = new CustomScrollBarWidget;

        // Order of widgets is different between vertical and horizontal.
        static if ( Horizon ) {
            addChild( _contents  );
            addChild( _scrollbar );
        } else {
            addChild( _scrollbar );
            addChild( _contents  );
        }
    }

}
