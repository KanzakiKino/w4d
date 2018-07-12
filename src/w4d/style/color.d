// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module w4d.style.color;
import g4d.math.vector;

struct ColorSet
{
    vec4 fgColor     = vec4(0,0,0,1),
         bgColor     = vec4(0,0,0,0),
         borderColor = vec4(0,0,0,0);
}
