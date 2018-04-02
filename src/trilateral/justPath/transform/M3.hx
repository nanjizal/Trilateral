package trilateral.justPath.transform;
// used for simple matrix translations, x and y locations are stored on it directly.
// minimal implementation.
typedef M3data = { ?x: Float, ?y: Float
                , _00: Float, _10: Float, _20: Float
                , _01: Float, _11: Float, _21: Float
                , _02: Float, _12: Float, _22: Float
}
@:forward
abstract M3( M3data ) from M3data to M3data {
    inline public function new( m3: M3data ){
        this = m3;
    }
    public static inline
    function transformation( ?tx: Float = 0, ?ty: Float = 0, ?sx: Float = 1, ?sy: Float = 1, ?theta: Float = 0 ): M3 {
        var m3 = if( theta != 0 ){
                    var sin = Math.sin( theta );
                    var cos = Math.cos( theta );
                    new M3( { x: 0, y: 0, _00: sx*cos, _10: -sin, _20: tx, _01: sin, _11: sy*cos, _21: ty, _02: 0, _12: 0, _22: 1 });
                } else {
                    new M3( { x: 0, y: 0, _00: sx, _10: 0, _20: tx, _01: 0, _11: sy, _21: ty, _02: 0, _12: 0, _22: 1 } );
                };
        return m3;
    }
    @:op(A * B) 
    public inline 
    function multmat( m: M3 ): M3 {
        // assumes to keep original x, y
        return this = {    x: this.x, y: this.y
                ,   _00: this._00*m._00 + this._10*m._01 + this._20*m._02
                ,   _10: this._00*m._10 + this._10*m._11 + this._20*m._12
                ,   _20: this._00*m._20 + this._10*m._21 + this._20*m._22
                ,   _01: this._01*m._00 + this._11*m._01 + this._21*m._02
                ,   _11: this._01*m._10 + this._11*m._11 + this._21*m._12
                ,   _21: this._01*m._20 + this._11*m._21 + this._21*m._22
                ,   _02: this._02*m._00 + this._12*m._01 + this._22*m._02
                ,   _12: this._02*m._10 + this._12*m._11 + this._22*m._12
                ,   _22: this._02*m._20 + this._12*m._21 + this._22*m._22 };
    }
    @:op(A + B)
    public inline
    function add( m: M3 ): M3 {
        // assumes to keep original x, y
        return this = { x: this.x, y: this.y
                    ,   _00: this._00 + m._00
                    ,   _10: this._10 + m._10
                    ,   _20: this._20 + m._20
                    ,   _01: this._01 + m._01
                    ,   _11: this._11 + m._11
                    ,   _21: this._21 + m._21
                    ,   _02: this._02 + m._02
                    ,   _12: this._12 + m._12
                    ,   _22: this._22 + m._22 };
    }
    @:op(A - B)
    public inline
    function minus( m: M3 ): M3 {
        // assumes to keep original x, y
        return this = { x: this.x, y: this.y
                    ,   _00: this._00 - m._00
                    ,   _10: this._10 - m._10
                    ,   _20: this._20 - m._20
                    ,   _01: this._01 - m._01
                    ,   _11: this._11 - m._11
                    ,   _21: this._21 - m._21
                    ,   _02: this._02 - m._02
                    ,   _12: this._12 - m._12
                    ,   _22: this._22 - m._22 };
    }
    // applies the matrix to a specific point
    public inline 
    function transform( x: Float, y: Float ){
        var w = this._02 * x + this._12 * y + this._22 * 1;
        this.x = ( this._00 * x + this._10 * y + this._20 * 1) / w;
        this.y = ( this._01 * x + this._11 * y + this._21 * 1) / w;
    }
}