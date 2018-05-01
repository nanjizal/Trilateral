package trilateral.parsing.svg;
abstract Version( Float ) from Float to Float {
    public inline function new( val: Float ){
        this = val;
    }
    @:from
    static public function fromString( s: String ): Version {
        return new Version( Std.parseFloat( s ) );
    }
    public function major(): Int {
        return Math.floor( this );
    }
    public function minor(): Int {
        return Std.parseInt( Std.string( this-major() ).split('.')[1] );
    }
}