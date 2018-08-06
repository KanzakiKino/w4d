// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module w4d.widget.mdi.titlebar;

template TitleBar ()
{
    protected class CloseButtonWidget : ButtonWidget
    {
        override void handleButtonPress ()
        {
            close();
            super.handleButtonPress();
        }
        this ()
        {
            super();
            style.box.paddings    = Rect(0.mm);
            style.box.size.width  = 4.mm;
            style.box.size.height = 4.mm;
            setLayout!GravityLayout( vec2(1,0) );
        }
    }

    protected class TitleBarWidget : PanelWidget
    {
        TextWidget        _title;
        CloseButtonWidget _close;

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

            style.box.size.width = Scalar.Auto;
            setLayout!HorizontalSplitLayout;

            _title = new TextWidget;
            addChild( _title );

            _close = new CloseButtonWidget;
            addChild( _close );
        }

        override @property bool trackable () { return true; }
    }
}
