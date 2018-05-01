package trilateral.parsing.svg;
abstract Matrix( Matrix_ ) from Matrix_ to Matrix_ {
    public inline function new( val: Matrix_ ){
        this = val;
    }
    @:from
    static public function fromString( s: String ): Matrix {
        var start = s.indexOf('(') +1;
        var end = s.indexOf(')') -1; 
        s = s.substr( start, end-start );
        var arr = s.split(',');
        return new Matrix( {    a: arr[ 0 ]
                            ,   b: arr[ 1 ]
                            ,   c: arr[ 2 ]
                            ,   d: arr[ 3 ]
                            ,   e: arr[ 4 ]
                            ,   f: arr[ 5 ]
                            } );
    }
}
typedef Matrix_ = {
        a: FloatString
    ,   b: FloatString
    ,   c: FloatString
    ,   d: FloatString
    ,   e: FloatString
    ,   f: FloatString
}