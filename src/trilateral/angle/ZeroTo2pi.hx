package trilateral.angle;
import trilateral.angle.Fraction;
@forward
abstract ZeroTo2pi( Float ) to Float {
    // private can't create directly
    inline 
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
        var f: Float = this + b;
        var p: ZeroTo2pi = f;
        return p; 
    }
    @:op(A - B)
    public function subtractionPi( b: ZeroTo2pi ): ZeroTo2pi {
        var f: Float = this;
        var f2: Float = b;
        f -= f2;
        var p: ZeroTo2pi = f;
        return p;
    }
    @:op(A / B)
    public function dividePi( b: ZeroTo2pi ): ZeroTo2pi {
        var f: Float = this;
        var f2: Float = b;
        f /= f2;
        var p: ZeroTo2pi = f;
        return p; 
    }
    @:op(A * B)
    public function timesPi( b: ZeroTo2pi ): ZeroTo2pi {
        var f: Float = this;
        var f2: Float = b;
        f *= f2;
        var p: ZeroTo2pi = f;
        return p; 
    }
    @:op(A + B)
    public function addition( b: Float ): ZeroTo2pi {
        var f: Float = this;
        f += b;
        var p: ZeroTo2pi = f;
        return p; 
    }
    @:op(A - B)
    public function subtraction( b: Float ): ZeroTo2pi {
        var f: Float = this;
        f -= b;
        var p: ZeroTo2pi = f;
        return p; 
    }
    @:op(A / B)
    public function divide( b: Float ): ZeroTo2pi {
        var f: Float = this;
        f /= b;
        var p: ZeroTo2pi = f;
        return p; 
    }
    @:op(A * B)
    public function times( b: Float ): ZeroTo2pi {
        var f: Float = this;
        f *= b;
        var p: ZeroTo2pi = f;
        return p; 
    }
    public var degrees( get, set ): Float;
    public inline 
    function get_degrees(): Float{
        var f: Float = this;
        return f*180/Math.PI;
    }
    public inline 
    function set_degrees( val: Float ): Float {
        this = Math.PI*val/180;
        return val;
    }
    @:from
    inline static
    function fromFraction( val: Fraction ):ZeroTo2pi {
        return new ZeroTo2pi( val.toFloat()*Math.PI );
    }
    @:to
    inline function tofraction(): Fraction {
        var f: Float = this;
        var frac: Fraction = this/Math.PI;
        return frac;
    }
    @:from
    inline static
    function fromString( val: String ):ZeroTo2pi {
        var frac: Fraction = val;
        return new ZeroTo2pi( frac.toFloat()*Math.PI );
    }
}