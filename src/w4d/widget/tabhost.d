// Written in the D programming language.
/++
 + Authors: KanzakiKino
 + Copyright: KanzakiKino 2018
 + License: LGPL-3.0
++/
module w4d.widget.tabhost;
import w4d.layout.lineup,
       w4d.layout.split,
       w4d.parser.colorset,
       w4d.style.rect,
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

/// A widget of host for tabs.
class TabHostWidget : Widget
{
    protected class TabHeaderWidget : ButtonWidget
    {
        const int id;

        this ( int i )
        {
            super();
            id = i;

            parseColorSetsFromFile!"colorset/tabheader.yaml"( style );
            style.box.size.width     = Scalar.None;
            style.box.size.height    = Scalar.None;
            style.box.margins.bottom = 0.mm;
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
            setLayout!( HorizontalMonospacedSplitLayout );
            style.box.size.height = 10.mm;
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
            _header.loadText( v, _fontface );
        }
    }

    protected FontFace _fontface;

    protected Tab[] _tabs;
    protected long  _activatedIndex;

    protected TabHeaderPanelWidget _headers;

    ///
    override @property Widget[] children ()
    {
        Widget[] result = [_headers];
        if ( auto tab = activatedTab ) {
            result ~= tab.contents;
        }
        return result;
    }

    ///
    this ()
    {
        super();
        _tabs = [];

        setLayout!( VerticalSplitLayout );
        _headers = new TabHeaderPanelWidget;
    }

    /// Changes the font of tab headers.
    void setFontFace ( FontFace face )
    {
        _fontface = face;
    }

    protected long indexOf ( in Tab t )
    {
        return _tabs.countUntil!"a is b"(t);
    }
    protected long indexOf ( int id )
    {
        return _tabs.countUntil!"a.id == b"(id);
    }

    /// A tab that is activated.
    @property activatedTab ()
    {
        if ( _activatedIndex >= 0 ) {
            return _tabs[_activatedIndex.to!uint];
        }
        return null;
    }

    /// Finds a tab that matched the id.
    Tab findTabWithId ( int id )
    {
        auto index = indexOf( id );
        return index >= 0? _tabs[index.to!uint]: null;
    }

    /// Adds the tab.
    void addTab ( int id, dstring title, Widget contents )
    {
        enforce( indexOf(id) < 0, "Id is duplicated." );

        _tabs ~= new Tab( id, title, contents );
        if ( _activatedIndex < 0 ) {
            activateTab( _tabs[0] );
        }
    }
    /// Removes the tab.
    void removeTab ( in Tab t )
    {
        _tabs = _tabs.remove!( x => x is t );
    }

    /// Activates the tab.
    void activateTab ( Tab t )
    {
        auto index = indexOf(t);
        enforce( index >= 0, "Tab doesn't belong to this host." );

        _activatedIndex = index;

        _tabs.each!( x => x.header.disableState( WidgetState.Selected ) );
        t.header.enableState( WidgetState.Selected );

        _context.setFocused( null ); // drop the focus focibly
        requestLayout();
    }

    ///
    override @property bool trackable () { return false; }
    ///
    override @property bool focusable () { return false; }
}
