// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module w4d.widget.input.templates;

template Lockable ()
{
    protected bool _locked;
    const @property isLocked () { return _locked; }

    void lock ()
    {
        _locked = true;
    }
    void unlock ()
    {
        _locked = false;
    }
}
