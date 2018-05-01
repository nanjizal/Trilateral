package trilateral.parsing.svg;
abstract FloatString( Float ) from Float to Float {
    public inline function new( val: Float ){
        this = val;
    }
    @:from
    static public function fromString( s: String ): FloatString {
        return new FloatString( Std.parseFloat( s ) );
    }
}