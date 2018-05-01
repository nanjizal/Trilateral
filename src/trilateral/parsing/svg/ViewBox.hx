package trilateral.parsing.svg;
typedef ViewBox_ = { x: Int, y: Int, width: Int, height: Int }
abstract ViewBox( ViewBox_) from ViewBox_ to ViewBox_ {
    public inline function new( val: ViewBox ){
        this = val;
    }
    @:from
    static public function fromString( s: String ): ViewBox {
        var arr = s.split(' ');
        return new ViewBox( 
            { x:        Std.parseInt( arr[ 0 ] )
            , y:        Std.parseInt( arr[ 1 ] )
            , width:    Std.parseInt( arr[ 2 ] )
            , height:   Std.parseInt( arr[ 3 ] ) 
            }
        );
    }
}