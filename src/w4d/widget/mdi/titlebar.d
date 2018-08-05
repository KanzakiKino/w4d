// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module w4d.widget.mdi.titlebar;

template TitleBar ()
{
    protected class TitleBarWidget : PanelWidget
    {
        TextWidget _title;

        protected vec2 _cursorOffset;

        override bool handleMouseMove ( vec2 pos )
        {
            if ( super.handleMouseMove( pos ) ) return true;

            if ( isTracked ) {
                pos -= _host.style.clientLeftTop;
                move( pos - _cursorOffset );
                return true;
            }
            return false;
        }

        override bool handleMouseButton ( MouseButton btn, bool status, vec2 pos )
        {
            if ( super.handleMouseButton(btn,status,pos) ) return true;

            if ( btn == MouseButton.Left && status ) {
                _cursorOffset = pos - style.translate;
                return true;
            }
            return false;
        }

        this ()
        {
            super();

            style.box.size.width  = Scalar.Auto;
            style.box.size.height = 7.mm;
            setLayout!HorizontalLineupLayout;

            _title = new TextWidget;
            addChild( _title );
        }

        override @property bool trackable () { return true; }
    }
}
