// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module w4d.widget.base.context;

template Context ()
{
    class WindowContext
    {
        this ()
        {
            _tracked = null;
            _focused = null;
            _popup   = null;
        }

        protected bool _needRedraw;
        @property needRedraw () { return _needRedraw; }

        void requestRedraw ()
        {
            _needRedraw = true;
        }
        void setNoNeedRedraw ()
        {
            _needRedraw = false;
        }


        protected Widget _tracked;

        @property tracked ()
        {
            return _popup? _popup: _tracked;
        }
        void setTracked ( Widget w )
        {
            auto temp = _tracked;
            _tracked = w;

            if ( w !is temp ) {
                if ( temp ) temp.handleTracked( false );
                if ( w    ) w   .handleTracked( true  );
            }
        }


        protected Widget _focused;

        @property focused ()
        {
            return _popup? _popup: _focused;
        }
        void setFocused ( Widget w )
        {
            auto temp = _focused;
            _focused = w;

            if ( w !is temp ) {
                if ( temp ) temp.handleFocused( false );
                if ( w    ) w   .handleFocused( true  );
            }
        }


        protected Widget _popup;

        @property popup () { return _popup; }

        void setPopup ( Widget w )
        {
            auto temp = _popup;
            _popup = w;

            if ( w !is temp ) {
                if ( temp ) temp.handlePopup( false, this );
                if ( w    ) w   .handlePopup( true , this );
            }
        }


        void forget ( Widget w )
        {
            if ( tracked is w ) {
                setTracked( null );
            }
            if ( focused is w ) {
                setFocused( null );
            }
            if ( popup is w ) {
                setPopup( null );
            }
        }
    }
}
