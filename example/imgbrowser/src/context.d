// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module imgbrowser.context;
import w4d;
import std.file,
       std.path;

class AppContext
{
    enum appname   = "ImgBrowser";
    enum appver    = "v1.0.0";
    enum title     = appname~" - "~appver;
    enum copyright = " Copyright 2018 KanzakiKino";

    protected static AppContext _instance;
    static @property instance ()
    {
        return _instance;
    }

    static @property fontPath ()
    {
        auto dir = thisExePath.dirName;
        return dir~"/noto.ttf";
    }

    this ()
    {
        assert( !_instance );
        _instance = this;
    }


    protected MainTabHost _mainTabs;

    void setMainTabHost ( MainTabHost host )
    {
        assert( !_mainTabs );
        _mainTabs = host;
    }
    @property mainTabs () { return _mainTabs; }
}
alias ImgBrowser = AppContext.instance;

interface MainTabHost
{
    void openNewPage ( string );
}
