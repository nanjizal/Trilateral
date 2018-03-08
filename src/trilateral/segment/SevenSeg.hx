package trilateral.segment;
import trilateral.tri.Trilateral;
import trilateral.tri.TrilateralArray;
// Used to emulate 7 segment display, can be used for rough letters.
class SevenSeg{
    public var width:  Float = 0.10;
    public var height: Float = 0.18;
    public var unit: Float   = 0.01;
    public var x: Float;
    public var y: Float;
    public var gap: Float;
    public var spacing: Float;
    public var triArr: TrilateralArray;
    public function new( width_: Float, height_: Float, ?trilateralArray_: TrilateralArray = null ){
        height = height_;
        width  = width_;
        unit = width_ * (1/10);
        gap = unit/5;
        spacing = width + unit*1.5;
        triArr = ( trilateralArray_ == null )? new Array<Trilateral>(): trilateralArray_;
    } 
    public inline 
    function numberWidth( val: Int ): Float {
        var str = Std.string( val );
        return stringWidth( str );
    }
    public inline
    function stringWidth( str: String ): Float {
        var l = str.length;
        var space = 0.;
        for( i in 0...l ){
            space += spacing;
        }
        return space;
    }
    public inline
    function addNumber( val: Int, x_: Float, y_: Float, ?centre: Bool = false ){
        var str = Std.string( val );
        addString( str, x_, y_, centre );
    }
    public inline
    function addString( str: String, x_: Float, y_: Float, ?centre: Bool = false ){
        var l = str.length;
        var space = 0.;
        if( centre ){
            for( i in 0...l ){
                space += spacing;
            }
            space -= unit*1.5;// centreX makes assumption for simplicity see spacing in constructor.
            space = -space/2;
            y_ = y_ - height/2;
        }
        for( i in 0...l ){
            addDigit( Std.parseInt( str.substr( i, 1 ) ), x_ + space, y_ );
            space += spacing;
        }
    }
    public inline function addDigit( hexCode: Int, x_: Float, y_: Float ){
        x = x_;
        y = y_;
        switch( hexCode ){
            case 0:
                a();
                b();
                c();
                d();
                e();
                f();
            case 1:
                b();
                c();
            case 2:
                a();
                b();
                g();
                e();
                d();
            case 3:
                a();
                b();
                g();
                c();
                d();
            case 4:
                f();
                g();
                b();
                c();
            case 5:
                a();
                f();
                g();
                c();
                d();
            case 6:
                a();
                f();
                g();
                c();
                d();
                e();
            case 7:
                a();
                b();
                c();
            case 8:
                a();
                b();
                c();
                d();
                e();
                f();
                g();
            case 9: 
                g();
                f();
                a();
                b();
                c();
            case 10: // A
                e();
                f();
                a();
                b();
                c();
                g();
            case 11: // b
                f();
                g();
                c();
                d();
                e();
            case 12: // C
                a();
                f();
                e();
                d();
            case 13: // d
                b();
                g();
                e();
                d();
                c();
            case 14: // E
                a();
                f();
                g();
                e();
                d();
            case 15: // F
                a();
                f();
                g();
                e();
        }
    }
    inline
    function a(){
        horiSeg( x, y );
    }
    inline
    function b(){
        vertSeg( x + width - 2*unit, y );
    }
    inline
    function c(){
        var hi = height/2;
        vertSeg( x + width - 2*unit, y + hi - unit );
    }
    inline
    function d(){
        horiSeg( x, y + height - 2*unit );
    }
    inline
    function e(){
        var hi = height/2;
        vertSeg( x, y + hi - unit );
    }
    inline
    function f(){
        vertSeg( x, y );
    }
    inline
    function g(){
        var hi = height/2;
        horiSeg( x, y + hi - unit );
    }
    inline
    function dp(){
        // not implemented
    }
    inline
    function triFactory( ax: Float, ay: Float, bx: Float, by: Float, cx: Float, cy: Float ): Trilateral {
        return new Trilateral( ax, ay, bx, by, cx, cy );
    }
    inline
    function horiSeg( x_, y_ ){
        var tri = triArr;
        var l = tri.length;
        tri[ l ] = triFactory( x_ + unit + gap, y_ + unit, x_ + 2*unit, y_, x_ + width - unit - gap, y_ + unit );
        l++;
        tri[ l ] = triFactory( x_ + 2*unit, y_, x_ + width - 2*unit, y_, x_ + width - unit - gap, y_ + unit );
        l++;
        tri[ l ] = triFactory( x_ + unit + gap, y_ + unit, x_ + width - unit - gap, y_  + unit, x_ + width - 2*unit, y_ + 2*unit );
        l++;
        tri[ l ] = triFactory( x_ + unit + gap, y_ + unit, x_ + width - 2*unit, y_  + 2*unit, x_ + 2*unit, y_ + 2*unit );
    }
    inline
    function vertSeg( x_, y_ ){
        var tri = triArr;
        var l = tri.length;
        var hi = height/2;
        tri[ l ] = triFactory( x_, y_ + 2*unit, x_ + unit, y_ + hi - gap, x_, y_ + hi - unit + gap );
        l++;
        tri[ l ] = triFactory( x_, y_ + 2*unit, x_ + unit, y_ + unit + gap, x_ + unit, y_ + hi - gap );
        l++;
        tri[ l ] = triFactory( x_ + unit, y_ + unit + gap, x_ + 2*unit, y_  + hi - unit, x_ + unit, y_ + hi - gap );
        l++;
        tri[ l ] = triFactory( x_ + unit, y_ + unit + gap, x_ + 2*unit, y_  + 2*unit, x_ + 2*unit, y_ + hi - unit );
    }
}