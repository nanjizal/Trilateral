package trilateral.angle;
import trilateral.angle.Pi2pi;
import trilateral.angle.ZeroTo2pi;
enum DifferencePreference {
    CLOCKWISE;
    ANTICLOCKWISE;
    SMALL;
    LARGE;
}
class Angles{
    public inline static function pi2pi( angle: Float ): Float {
        return if( angle <= Math.PI && angle > -Math.PI ){
            angle; // don't really want any maths to touch it if it's within range as it may effect value slightly
        } else {
            var a = ( angle + Math.PI ) % ( 2 * Math.PI );
            ( a >= 0 )? a - Math.PI: a + Math.PI;
        }
    }
    public inline static function zeroto2pi( angle: Float ): Float {
        return if( angle >= 0 && angle > Math.PI ){
            angle; // don't really want any maths to touch it if it's within range as it may effect value slightly
        } else {
            var a = angle % ( 2 * Math.PI );
            return ( a >= 0 )? a : ( a + 2 * Math.PI );
        }
    }
    public inline static function zerotoMinus2pi( angle: Float ): Float {
        return if( angle <= 0 && angle > -Math.PI ){
            angle; // don't really want any maths to touch it if it's within range as it may effect value slightly
        } else {
            var a = angle % ( 2 * Math.PI );
            var a = ( a >= 0 )? a: ( a + 2 * Math.PI );
            -( Math.PI*2 - a );
        }
    }
    public inline static function differencePrefer( a: Float, b: Float, prefer: DifferencePreference ){
        return switch( prefer ){
            case CLOCKWISE:
                differenceClockWise( a, b );
            case ANTICLOCKWISE:
                differenceAntiClockwise( a, b );
            case SMALL:
                differenceSmall( a, b );
            case LARGE:
                differenceLarge( a, b );
        }
    }  
    public inline static function difference( a: Float, b: Float ): Float {
        var za: ZeroTo2pi = a;
        var zb: ZeroTo2pi = b;
        var fa: Float = za;
        var fb: Float = zb;
        var theta = Math.abs( fa - fb );
        var clockwise = a < b;
        return ( clockwise )? theta: -theta;
    }    
    public inline static function differenceClockWise( a: Float, b: Float ): Float {
        var dif = difference( a, b );
        return ( dif > 0 )? dif: 2 * Math.PI + dif; 
    }
    public inline static function differenceAntiClockwise( a: Float, b: Float ): Float {
        var dif = difference( a, b );
        return ( dif < 0 )? dif: -2 * Math.PI + dif; 
    }
    public inline static function differenceSmall( a: Float, b: Float ): Float {
        var za: ZeroTo2pi = a;
        var zb: ZeroTo2pi = b;
        var fa: Float = za;
        var fb: Float = zb;
        var theta = Math.abs( fa - fb );
        var smallest = ( theta <= Math.PI ); // smallest or equal!
        var clockwise = a < b;
        var dif = ( clockwise )? theta: -theta;
        return if( smallest ) {
            dif;
        } else {
            ( clockwise )? -( 2 * Math.PI - theta ): 2 * Math.PI - theta;
        }
    }
    public inline static function differenceLarge( a: Float, b: Float ): Float {
        var za: ZeroTo2pi = a;
        var zb: ZeroTo2pi = b;
        var fa: Float = za;
        var fb: Float = zb;
        var theta = Math.abs( fa - fb );
        var largest = ( theta > Math.PI );
        var clockwise = a < b;
        var dif = ( clockwise )? theta: -theta;
        return if( largest ) {
            dif;
        } else {
            ( clockwise )? -( 2 * Math.PI - theta ): 2 * Math.PI - theta;
        }
    }
    public inline static function differenceSmallLarge( a: Float, b: Float ):{ small: Float, large: Float }{
        var za: ZeroTo2pi = a;
        var zb: ZeroTo2pi = b;
        var fa: Float = za;
        var fb: Float = zb;
        var theta = Math.abs( fa - fb );
        var smallest = ( theta <= Math.PI ); // smallest or equal!
        var clockwise = a < b;
        var dif = ( clockwise )? theta: -theta;
        var other = ( clockwise )? -( 2 * Math.PI - theta ): 2 * Math.PI - theta;
        return if( smallest ) {
                    { small: dif, large: other };
                } else {
                    { small: other, large: dif };
                }
    }
}
