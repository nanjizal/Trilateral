package trilateral.angle;
import trilateral.angle.Fraction;
@forward
abstract ZeroTo2pi( Float ) to Float {
    inline // private can't create directly
    function new( f: Float ){
        this = f;
    }
    @:from
    static inline public 
    function fromFloat( f: Float ) {
        return new ZeroTo2pi( Angles.zeroto2pi( f ) );
    }
    @:op(A > B) static function gt( a:ZeroTo2pi, b:ZeroTo2pi ) : Bool;
    @:op(A < B) static function lt( a:ZeroTo2pi, b:ZeroTo2pi ) : Bool;
    @:op(A == B) static function et( a:ZeroTo2pi, b:ZeroTo2pi ) : Bool;
    @:op(A >= B) static function gte( a:ZeroTo2pi, b:ZeroTo2pi ) : Bool;
    @:op(A <= B) static function lte( a:ZeroTo2pi, b:ZeroTo2pi ) : Bool;
    @:op(A + B)
    public function additionPi( b: ZeroTo2pi ): ZeroTo2pi {
        return ( this: Float ) + ( b: Float ); 
    }
    @:op(A - B)
    public function subtractionPi( b: ZeroTo2pi ): ZeroTo2pi {
        return ( this: Float ) - ( b: Float ) ;
    }
    @:op(A / B)
    public function dividePi( b: ZeroTo2pi ): ZeroTo2pi {
        return ( this: Float ) / ( b: Float ); 
    }
    @:op(A * B)
    public function timesPi( b: ZeroTo2pi ): ZeroTo2pi {
        return ( this: Float ) * ( b: Float ); 
    }
    @:op(A + B)
    public function addition( b: Float ): ZeroTo2pi {
        return ( this: Float ) + b; 
    }
    @:op(A - B)
    public function subtraction( b: Float ): ZeroTo2pi {
        return ( this: Float ) - b; 
    }
    @:op(A / B)
    public function divide( b: Float ): ZeroTo2pi {
        return ( this: Float ) / b; 
    }
    @:op(A * B)
    public function times( b: Float ): ZeroTo2pi {
        return ( this: Float ) * b; 
    }
    public var degrees( get, set ): Float;
    public inline 
    function get_degrees(): Float{
        return ( this: Float )*180/Math.PI;
    }
    public inline 
    function set_degrees( val: Float ): Float {
        this = Math.PI*val/180;
        return val;
    }
    @:from
    inline static
    function fromFraction( val: Fraction ):ZeroTo2pi {
        return val.toFloat()*Math.PI;
    }
    @:to
    inline function tofraction(): Fraction {
        return ( this: Float )/Math.PI;
    }
    @:from
    inline static
    function fromString( val: String ):ZeroTo2pi {
        var frac: Fraction = val;
        return frac.toFloat()*Math.PI;
    }
    @:to
    inline public
    function toString(): String {
        return Std.string( ( this: Float ) );
    }
}
