// Written in the D programming language.
/++
 + Authors: KanzakiKino
 + Copyright: KanzakiKino 2018
 + License: LGPL-3.0
++/
module w4d.widget.base.context;

/// A template that declares WindowContext.
template Context ()
{
    enum Modkey
    {
        None  = 0b00,

        Ctrl  = 0b01,
        Shift = 0b10,
    }

    class WindowContext
    {
        this ()
        {
            _tracked = null;
            _focused = null;
            _popup   = null;
        }

        protected bool _needRedraw;
        const @property needRedraw () { return _needRedraw; }

        void requestRedraw ()
        {
            _needRedraw = true;
        }
        void setNoNeedRedraw ()
        {
            _needRedraw = false;
        }


        protected uint _modkey;

        const @property ctrl ()
        {
            return !!( _modkey & Modkey.Ctrl );
        }
        const @property shift ()
        {
            return !!( _modkey & Modkey.Shift );
        }

        void setModkeyStatus ( Modkey key, bool press )
        {
            if ( press ) {
                _modkey |= key;
            } else {
                _modkey &= ~key;
            }
        }


        protected Widget _tracked;

        inout @property tracked ()
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

        inout @property focused ()
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

        inout @property popup () { return _popup; }

        void setPopup ( Widget w )
        {
            auto temp = _popup;
            _popup = w;

            if ( w !is temp ) {
                if ( temp ) temp.handlePopup( false, this );
                if ( w    ) w   .handlePopup( true , this );
            }
        }


        void forget ( in Widget w )
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
