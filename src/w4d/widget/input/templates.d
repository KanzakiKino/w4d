// Written in the D programming language.
/++
 + Authors: KanzakiKino
 + Copyright: KanzakiKino 2018
 + License: LGPL-3.0
++/
module w4d.widget.input.templates;

/// A template for lockable widgets.
template Lockable ()
{
    protected bool _locked;
    @property isLocked () { return _locked; }

    void lock ()
    {
        _locked = true;
    }
    void unlock ()
    {
        _locked = false;
    }
}
