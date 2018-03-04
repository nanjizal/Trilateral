package trilateral.helper;
//TODO: need to check color requirements for other targets from Quick
#if kha 
@:enum
abstract AppColors( Int ) to Int from Int {
    var Violet      = 0xFF9400D3;
    var Indigo      = 0xFF4b0082;
    var Blue        = 0xFF0000FF;
    var Green       = 0xFF00ff00;
    var Yellow      = 0xFFFFFF00;
    var Orange      = 0xFFFF7F00;
    var Red         = 0xFFFF0000;
    var Black       = 0xFF000000;
    var LightGrey   = 0xFF444444;
    var MidGrey     = 0xFF333333;
    var DarkGrey    = 0xFF0c0c0c;
    var NearlyBlack = 0xFF111111;
    var White       = 0xFFFFFFFF;
    var BlueAlpha   = 0xFF0000FF;
    var GreenAlpha  = 0xFF00FF00;
    var RedAlpha    = 0xFFFF0000;
}
#else
@:enum
abstract AppColors( Int ) to Int from Int {
    var Violet      = 0x9400D3;
    var Indigo      = 0x4b0082;
    var Blue        = 0x0000FF;
    var Green       = 0x00ff00;
    var Yellow      = 0xFFFF00;
    var Orange      = 0xFF7F00;
    var Red         = 0xFF0000;
    var Black       = 0x000000;
    var LightGrey   = 0x444444;
    var MidGrey     = 0x333333;
    var DarkGrey    = 0x0c0c0c;
    var NearlyBlack = 0x111111;
    var White       = 0xFFFFFF;
    var BlueAlpha   = 0x0000FF;
    var GreenAlpha  = 0x00FF00;
    var RedAlpha    = 0xFF0000;
}
#end
