package trilateral.angle; 
import trilateral.angle.Fraction;
// numerator/denominator
// perhaps need to add sign?
typedef Fractional = {
    public var positive:       Bool;
    public var numerator:      Int;
    public var denominator:    Int;
    public var value:          Null<Float>;
}
@:arrayAccess
@:forward
abstract FractionArray( Array<Fraction> ) from Array<Fraction> to Array<Fraction> {
    public inline function new( ?val: Array<Fraction> ){
        this = ( val == null )? new Array<Fraction>(): val;
    }
    public inline function add( val: Fraction ){
        //trace( 'adding ' + val.verbose() );
        this[ this.length ] = val;
    }
    @:to
    public inline
    function toString():String{
        var l = this.length;
        var str = '';
        for( i in 0...l ) str = str + '\n' + this[ i ];
        return str;
    }
}

abstract Fraction( Fractional ) to Fractional from Fractional {
    public inline
    function new( numerator: Int, denominator: Int, ?positive: Bool = true, value: Null<Float> = null ){
        var numNeg = numerator < 0;
        var denoNeg = denominator < 0;
        if( value == null ) value = ( positive )? numerator/denominator: -numerator/denominator;
        if( numNeg || denoNeg ) {
            if( !(numNeg && denoNeg) ) positive = !positive;
            if( numNeg ) numerator = -numerator;
            if( denoNeg ) denominator = -denominator;
        }
        this = { numerator: numerator, denominator: denominator, positive: positive, value: value };
    }
    inline
    function optimize(){
        return fromFloat( this.value );
    }
    inline
    function optimizeFraction(){
        return fromFloat( toFloat() );
    }
    @:to
    public inline
    function toFloat():Float {
        return if( this.positive ) {
            this.numerator/this.denominator;
        } else {
            -this.numerator/this.denominator;
        }
    }
    public inline
    function float():Float {
        return this.value;
    }
    public inline
    function verbose(): String {
        return ('{ numerator:' + this.numerator +', denominator: '+ this.denominator + ', positive: ' + this.positive + ', value: ' + this.value + " }" );
    }
    @:from 
    public static inline
    function fromString( val: String ): Fraction {
        var i = val.indexOf( '/' );
        var frac: Fraction = if( i != -1 ){
            new Fraction( Std.parseInt( val.substr( 0, i ) ), Std.parseInt( val.substr( i + 1, val.length ) ) );
        } else {
            Std.parseFloat( val );
        }
        return frac;
    }
    @:to
    public inline
    function toString():String {
        var n = this.numerator;
        var d = this.denominator;
        var out = if( n == 0 ){ 
            '0';
        } else if ( n == d ) {
            '1';
        } else if( d == 1 ){
            ( this.positive )? '$n': '-$n';
        } else {
            ( this.positive )? '$n/$d': '-$n/$d';
        }
        return out;
    }
    @:from
    static inline
    public function fromFloat( f: Float ): Fraction {
        var arr = Fracs.approximateFractions( f );
        var dist: Float = Math.POSITIVE_INFINITY;
        var dif: Float;
        var l = arr.length;
        var fracFloat: Float;
        var frac: Fraction;
        var fracStore = arr[0];
        // finds closest
        for( i in 0...l  ){
            var frac = arr[i];
            fracFloat = frac;
            dif = Math.abs( fracFloat - f );
            if( dif < dist ) {
                dist = dif;
                fracStore = frac;
            }
        }
        return fracStore;
    }
    static inline
    public function firstFloat( f: Float ): Fraction {
        var arr = Fracs.approximateFractions( f );
        var fracStore = arr[0];
        return fracStore;
    }
    // if your stepping by say 1/10's you can ask for the nearest fraction in this form.
    inline
    public function byDenominator( val: Int ): String {
        var out: String = toString();
        if( this.denominator == val || out == '0' || out == '1' ){
        } else {
            var dom = Math.round( this.value*val );
            var frac = new Fraction( dom, val );
            out = frac.toString();
        }
        return out;
    }
    static inline
    public function all( f: Float ): FractionArray {
        return Fracs.approximateFractions( f );
    }
    inline 
    public function similarToFraction(): FractionArray{
        var f: Float = toFloat();
        return Fracs.approximateFractions( f );
    }
    inline 
    public function similarToValue(): FractionArray{
        return Fracs.approximateFractions( this.value );
    }
}
// use only from Fraction
class Fracs {
    // probably not needed?
    static inline
    function grabDecimalInput( decimalVal: String ):Float {
        var decimal = Math.abs( Std.parseFloat( decimalVal ) );
        return Math.isNaN(decimal)? 0. : decimal;
    }
    @:allow(trilateral.angle.Fraction)
    static
    function approximateFractions( f: Float ):FractionArray{
        var positive = ( f <= 0 )? false: true;
        var numerators = [ 0, 1 ];
        var denominators = [ 1, 0 ];
        var f2 = ( f <= 0 )? -f: f;
        var maxNumerator = getMaxNumerator( f2 );
        var d2 = f2;
        var calcD: Float;
        var prevCalcD: Null<Float> = null;
        var arrFraction = new FractionArray();
        var j: Int = 0;
        for( i in 2...1000 ){
            var L2 = Math.floor( d2 );
            numerators[ i ] = Std.int( L2 * numerators[ i - 1 ] + numerators[ i - 2 ] );
            if( Math.abs( numerators[ i ] ) > maxNumerator ) break;
            denominators[ i ] = Std.int( L2 * denominators[ i - 1 ] + denominators[ i - 2 ] );
            calcD = numerators[ i ] / denominators[ i ];
            if( calcD == prevCalcD ) break;
            arrFraction.add( new Fraction( numerators[ i ], denominators[ i ], positive, f ) );
            if( calcD == f2 ) break;
            prevCalcD = calcD;
            d2 = 1/( d2 - L2 );
        }
        return arrFraction;
    }
    static inline
    function getMaxNumerator( f: Float ): Float {
        var fStr = Std.string( f );
        var digits = '';
        var ix = fStr.indexOf(".");
        if( ix == -1 ){
            digits = fStr;
        } else if( ix == 0 ) {
            digits = fStr.substr( 1, fStr.length );
        } else if( ix < fStr.length ){
            digits = fStr.substr( 0, ix ) + fStr.substr( ix + 1, fStr.length );
        }
        var LStr = digits;
        var numDigits = LStr.length;
        var L2 = f;
        var numIntDigits = Std.string( L2 ).length;
        if( L2 == 0 ) numIntDigits = 0;
        var numDigitsPastDecimal = numDigits - numIntDigits;
        var i = numDigitsPastDecimal;
        var L = Std.parseFloat( digits );
        while( i > 0 && L%2 == 0 ){
            L/=2;
            i--;
        }
        i = numDigitsPastDecimal;
        while( i > 0 && L%5 == 0 ){
            L/=5;
            i--;
        }
        return L;
    }
    // perhaps not used!!!
    // String versions for use with exponents?
    static inline
    function extractDigitStr( fStr: String  ): String {
        var f2 = '';
        var ixe = fStr.indexOf( "E" );
        if( ixe==-1 ) ixe = fStr.indexOf( "e" );
        if( ixe == -1 ) {
            f2 = fStr;
        } else {
            f2 = fStr.substr( 0, ixe );
        }
        var digits = '';
        var ix = f2.indexOf(".");
        if( ix == -1 ){
            digits = f2;
        } else if( ix == 0 ) {
            digits = f2.substr( 1, f2.length );
        } else if( ix < f2.length ){
            digits = f2.substr( 0, ix ) + f2.substr( ix + 1, f2.length );
        }
        return digits;
    }
    static inline
    function getMaxNumeratorStr( fStr: String ): Float {
        var LStr = extractDigitStr( fStr );
        var numDigits = LStr.length;
        var L2 = fStr;
        var numIntDigits = L2.length;
        if( L2 == '0' ) numIntDigits = 0;
        var numDigitsPastDecimal = numDigits - numIntDigits;
        var i = numDigitsPastDecimal;
        var L = Std.parseFloat( fStr );
        while( i > 0 && L%2 == 0 ){
            L/=2;
            i--;
        }
        i = numDigitsPastDecimal;
        while( i > 0 && L%5 == 0 ){
            L/=5;
            i--;
        }
        return L;
    }
   
}
