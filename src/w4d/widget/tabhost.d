// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module w4d.widget.tabhost;
import w4d.layout.lineup,
       w4d.parser.theme,
       w4d.style.scalar,
       w4d.style.widget,
       w4d.widget.base,
       w4d.widget.button,
       w4d.widget.panel,
       w4d.exception;
import g4d.ft.font;
import std.algorithm,
       std.array,
       std.conv;

class TabHostWidget : Widget
{
    protected class TabHeaderWidget : ButtonWidget
    {
        const int id;

        this ( int i )
        {
            super();
            id = i;

            parseThemeFromFile!"theme/tabheader.yaml"( style );
        }

        override void handleButtonPress ()
        {
            super.handleButtonPress();
            activateTab( findTabWithId(id) );
        }
    }

    protected class TabHeaderPanelWidget : PanelWidget
    {
        override @property Widget[] children ()
        {
            return _tabs.map!( x => x.header ).array.to!(Widget[]);
        }
        this ()
        {
            super();
            setLayout!( HorizontalLineupLayout );
            style.box.size.height = Scalar(40,ScalarUnit.Pixel);
        }
        override void layout ()
        {
            if ( children.length ) {
                auto width = 100f/children.length;
                foreach ( c; children ) {
                    c.style.box.size.width = Scalar(width,ScalarUnit.Percent);
                }
            }
            super.layout();
        }
    }

    protected class Tab
    {
        protected TabHeaderWidget _header;
        protected Widget          _contents;

        @property header   () { return _header; }
        @property contents () { return _contents; }

        @property id () { return _header.id; }

        this ( int id, dstring title, Widget w )
        {
            _header = new TabHeaderWidget( id );
            this.title = title;

            _contents = w;
        }

        @property title ( dstring v )
        {
            _header.setText( v, _fontface );
        }
    }

    protected FontFace _fontface;

    protected Tab[] _tabs;
    protected long  _activatedIndex;

    protected TabHeaderPanelWidget _headers;

    override @property Widget[] children ()
    {
        Widget[] result = [_headers];
        if ( auto tab = activatedTab ) {
            result ~= tab.contents;
        }
        return result;
    }

    this ()
    {
        super();
        _tabs = [];

        setLayout!( VerticalLineupLayout );
        _headers = new TabHeaderPanelWidget;
    }

    void setFontFace ( FontFace face )
    {
        _fontface = face;
    }

    protected long indexOf ( Tab t )
    {
        return _tabs.countUntil!"a is b"(t);
    }
    protected long indexOf ( int id )
    {
        return _tabs.countUntil!"a.id == b"(id);
    }

    @property activatedTab ()
    {
        if ( _activatedIndex >= 0 ) {
            return _tabs[_activatedIndex.to!uint];
        }
        return null;
    }

    Tab findTabWithId ( int id )
    {
        auto index = indexOf( id );
        return index >= 0? _tabs[index.to!uint]: null;
    }

    void addTab ( int id, dstring title, Widget contents )
    {
        enforce( indexOf(id) < 0, "Id is duplicated." );

        _tabs ~= new Tab( id, title, contents );
        if ( _activatedIndex < 0 ) {
            activateTab( _tabs[0] );
        }
    }
    void deleteTab ( Tab t )
    {
        _tabs = _tabs.remove!( x => x is t );
    }

    void activateTab ( Tab t )
    {
        auto index = indexOf(t);
        enforce( index >= 0, "Tab doesn't belong to this host." );

        _activatedIndex = index;

        _tabs.each!( x => x.header.disableState( WidgetState.Selected ) );
        t.header.enableState( WidgetState.Selected );
        requestLayout();
    }
}
