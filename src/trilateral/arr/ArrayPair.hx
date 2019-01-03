package trilateral.arr;

abstract ArrayPairs<T>( Array<T> ) {
    public function new( arr: Array<T> ):Void this = arr;
    public var length( get, never ):Int;
    inline function get_length() return Std.int( this.length/2 );
    @:arrayAccess inline function access( key: Int ): { x: T, y: T } {
        var i: Int = Std.int( key*2 );
        return { x: this[ i ], y: this[ i + 1 ] };
    }
    public inline function reverse(): Array<T>{
        var arr = [];
        for( i in new ArrayPairs( this ) ){
            arr.unshift( i.y );
            arr.unshift( i.x );
        }
        this = arr;
        return arr;
    }
}