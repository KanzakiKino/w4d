// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module demo.context;

class AppContext
{
    protected static AppContext _instance;
    static @property instance () { return _instance; }

    this ()
    {
        assert( !_instance,
                "AppContext is already created." );
        _instance = this;
    }
}
