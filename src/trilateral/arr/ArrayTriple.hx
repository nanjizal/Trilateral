package trilateral.arr;

abstract ArrayTriple<T>( Array<T> ) {
    public function new( arr: Array<T> ):Void this = arr;
    public var length( get, never ):Int;
    inline function get_length() return Std.int( this.length/3 );
    @:arrayAccess inline function access( key: Int ): { a: T, b: T, c: T } {
        var i: Int = Std.int( key*3 );
        return { a: this[ i ], b: this[ i + 1 ], c: this[ i + 2] };
    }
    public inline function reverse(): Array<T>{
        var arr = [];
        for( i in new ArrayTriple( this ) ){
            arr.unshift( i.c );
            arr.unshift( i.b );
            arr.unshift( i.a );
        }
        this = arr;
        return arr;
    }
}