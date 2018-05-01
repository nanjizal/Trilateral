package trilateral.parsing.svg;
abstract SharpColor( Int ) from Int to Int {
    public inline function new( val: Int ){
        this = val;
    }
    @:from
    static public function fromString( s: String ): SharpColor {
        var temp: String;
        var out: Int = 0;
        if( s.length == 4 ){
            var r = s.substr( 1, 1 );
            var g = s.substr( 2, 1 );
            var b = s.substr( 3, 1 );
            temp = '0xFF'+r+r+g+g+b+b;
            out = Std.parseInt( temp );
        } else if( s.length == 7 ){
            temp = '0xFF' + s.substr( 1, 6 );
            out = Std.parseInt( temp );
        }
        return new SharpColor( out );
    }
}