package trilateral.parsing.svg;
abstract Stroke_Width( Float ) from Float to Float {
    public inline function new( val: Float ){
        this = val;
    }
    @:from
    static public function fromString( s: String ): Stroke_Width {
        return new Stroke_Width( Std.parseFloat( s ) );
    }
}