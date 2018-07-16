// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module w4d.parser.theme;
import w4d.parser.exception,
       w4d.style.color,
       w4d.style.widget;
import g4d.math.vector;
import dyaml;
import std.format,
       std.uni;

unittest
{
    auto style = new WidgetStyle;
    parseThemeFromFile!"theme/normal.yaml"( style );

//    import std.stdio; style.colorsets.writeln;
}

private WidgetState toState ( string str )
{
    switch ( str.toLower ) with ( WidgetState )
    {
        case "default" : return None;
        case "disabled": return Disabled;
        case "enabled" : return Enabled;
        case "hovered" : return Hovered;
        case "pressed" : return Pressed;
        case "tracked" : return Tracked;
        case "focused" : return Focused;

        default: throw new ParsingException(
                    "WidgetState specification is invalid." );
    }
}

vec4 parseColor ( Node seq )
{
    enforce( seq.isSequence, "Color specification.is invalid." );

    auto arr = seq.sequence!float;
    switch ( arr.length ) {
        case 1:
            return vec4( arr[0], arr[0], arr[0], 1f );
        case 3:
            return vec4( arr[0], arr[1], arr[2], 1f );
        case 4:
            return vec4( arr[0], arr[1], arr[2], arr[3] );
        default:
            throw new ParsingException( "Color specification is invalid." );
    }
}

ColorSet parseColorSet ( Node root, ColorSet base )
{
    auto result = base;
    ref vec4 getProperty ( string name )
    {
        switch ( name.toLower )
        {
            case "background": return result.bgColor;
            case "foreground": return result.fgColor;
            case "border"    : return result.borderColor;

            default: throw new ParsingException(
                             "Property specification is invalid." );
        }
    }

    foreach ( string name, Node node; root ) {
        getProperty(name) = parseColor( node );
    }
    return result;
}

void parseTheme ( Node root, WidgetStyle w )
{
    bool     first = true;
    ColorSet base;

    foreach ( string strst, Node node; root ) {
        auto state = strst.toState;
        enforce( !first || state == WidgetState.None, "First state must be 'default'." );

        w.colorsets[state] = node.parseColorSet( base );

        if ( first ) {
            base  = w.colorsets[WidgetState.None];
            first = false;
        }
    }
    enforce( !first, "Theme must have one colorsets of each state or more." );
}
void parseTheme ( string yaml, WidgetStyle w )
{
    Loader.fromString(yaml).load().parseTheme( w );
}

void parseThemeFromFile (string path) ( WidgetStyle w )
{
    try {
        import(path).parseTheme( w );
    } catch ( Exception e ) {
        auto mes = "Failed parsing '%s': %s".format( path, e.msg );
        throw new ParsingException( mes );
    }
}
void parseThemeFromFile ( string path, WidgetStyle w )
{
    try {
        Loader.fromFile(path).load().parseTheme( w );
    } catch ( Exception e ) {
        auto mes = "Failed parsing '%s': %s".format( path, e.msg );
        throw new ParsingException( mes );
    }
}
