package trilateral.angle;
import trilateral.angle.Fraction;
@forward
abstract Pi2pi( Float ) to Float {
    inline // private can't create directly
    function new( f: Float ){
        this = f;
    }
    @:from
    static inline public 
    function fromFloat( f: Float ) {
        return new Pi2pi( Angles.pi2pi( f ) );
    }
    @:op(A > B) static function gt( a:Pi2pi, b:Pi2pi ) : Bool;
    @:op(A < B) static function lt( a:Pi2pi, b:Pi2pi ) : Bool;
    @:op(A == B) static function et( a:Pi2pi, b:Pi2pi ) : Bool;
    @:op(A >= B) static function gte( a:Pi2pi, b:Pi2pi ) : Bool;
    @:op(A <= B) static function lte( a:Pi2pi, b:Pi2pi ) : Bool;
    @:op(A + B)
    public function additionPi( b: Pi2pi ): Pi2pi {
        return ( this: Float ) + ( b: Float );
    }
    @:op(A - B)
    public function subtractionPi( b: Pi2pi ): Pi2pi {
        return ( this: Float ) - ( b: Float );
    }
    @:op(A / B)
    public function dividePi( b: Pi2pi ): Pi2pi {
        return ( this: Float ) / ( b: Float ); 
    }
    @:op(A * B)
    public function timesPi( b: Pi2pi ): Pi2pi {
        return ( this: Float ) * ( b: Float ); 
    }
    @:op(A + B)
    public function addition( b: Float ): Pi2pi {
        return ( this: Float ) + b; 
    }
    @:op(A - B)
    public function subtraction( b: Float ): Pi2pi {
        return ( this: Float ) - b; 
    }
    @:op(A / B)
    public function divide( b: Float ): Pi2pi {
        return ( this: Float )/b; 
    }
    @:op(A * B)
    public function times( b: Float ): Pi2pi {
        return ( this: Float )*b; 
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
    function fromFraction( val: Fraction ):Pi2pi {
        return val.toFloat()*Math.PI;
    }
    @:to
    inline function tofraction(): Fraction {
        return ( this: Float )/Math.PI;
    }
    @:from
    inline static
    function fromString( val: String ):Pi2pi {
        var frac: Fraction = val;
        return frac.toFloat()*Math.PI;
    }
    @:to
    inline public
    function toString(): String {
        return Std.string( ( this: Float ) );
    }
}
