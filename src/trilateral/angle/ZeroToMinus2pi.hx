package trilateral.angle;
import trilateral.angle.Fraction;
@forward
abstract ZeroToMinus2pi( Float ) to Float {
    inline // private can't create directly
    function new( f: Float ){
        this = f;
    }
    @:from
    static inline public 
    function fromFloat( f: Float ) {
        return new ZeroToMinus2pi( Angles.zerotoMinus2pi( f ) );
    }
    @:op(A > B) static function gt( a:ZeroToMinus2pi, b:ZeroToMinus2pi ) : Bool;
    @:op(A < B) static function lt( a:ZeroToMinus2pi, b:ZeroToMinus2pi ) : Bool;
    @:op(A == B) static function et( a:ZeroToMinus2pi, b:ZeroToMinus2pi ) : Bool;
    @:op(A >= B) static function gte( a:ZeroToMinus2pi, b:ZeroToMinus2pi ) : Bool;
    @:op(A <= B) static function lte( a:ZeroToMinus2pi, b:ZeroToMinus2pi ) : Bool;
    @:op(A + B)
    public function additionPi( b: ZeroToMinus2pi ): ZeroToMinus2pi {
        return ( this: Float ) + ( b: Float ); 
    }
    @:op(A - B)
    public function subtractionPi( b: ZeroToMinus2pi ): ZeroToMinus2pi {
        return ( this: Float) - ( b: Float );
    }
    @:op(A / B)
    public function dividePi( b: ZeroToMinus2pi ): ZeroToMinus2pi {
        return ( this: Float ) / ( b: Float ); 
    }
    @:op(A * B)
    public function timesPi( b: ZeroToMinus2pi ): ZeroToMinus2pi {
        return ( this: Float ) * ( b: Float );
    }
    @:op(A + B)
    public function addition( b: Float ): ZeroToMinus2pi {
        return ( this: Float ) + b; 
    }
    @:op(A - B)
    public function subtraction( b: Float ): ZeroToMinus2pi {
        return ( this: Float ) - b; 
    }
    @:op(A / B)
    public function divide( b: Float ): ZeroToMinus2pi {
        return ( this: Float ) / b; 
    }
    @:op(A * B)
    public function times( b: Float ): ZeroToMinus2pi {
        return ( this: Float ) * b; 
    }
    public var degrees( get, set ): Float;
    public inline 
    function get_degrees(): Float{
        return ( this: Float )*180/Math.PI;
    }
    public inline 
    function set_degrees( val:Float ): Float {
        this = Math.PI*val/180;
        return val;
    }
    @:from
    inline static
    function fromFraction( val: Fraction ):ZeroToMinus2pi {
        return val.toFloat()*Math.PI;
    }
    @:to
    inline function tofraction(): Fraction {
        return ( this: Float )/Math.PI;
    }
    @:from
    inline static
    function fromString( val: String ):ZeroToMinus2pi {
        var frac: Fraction = val;
        return frac.toFloat()*Math.PI;
    }
    @:to
    inline public
    function toString(): String {
        return Std.string( ( this: Float ) );
    }
}
