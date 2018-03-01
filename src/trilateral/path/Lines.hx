package trilateral.path;
import trilateral.Trilateral;
import trilateral.Algebra;
import trilateral.TrilateralArray;
// Rethink name!
@:enum
abstract EndLineCurve( Int ){
    var no = 0;
    var begin = 1;
    var end = 2;
    var both = 3;
}
// based on justTriangles
class Lines {
    var ax: Float; // 0
    var ay: Float; // 0
    var bx: Float; // 1
    var by: Float; // 1
    var cx: Float; // 2
    var cy: Float; // 2
    var dx: Float; // 3
    var dy: Float; // 3
    var ex: Float; // 4
    var ey: Float; // 4
    
    var d_x: Float;
    var d_y: Float;
    var e_x: Float;
    var e_y: Float;
    var d_2x: Float;
    var d_2y: Float;
    var e_2x: Float;
    var e_2y: Float;
    /*
    public var angleA: Float; // smallest angle between lines
    var cosA: Float;
    var b2: Float;
    var c2: Float;
    var a2: Float;
    var b: Float; // first line length
    var c: Float; // second line length
    var a: Float;
    var clockwiseP2: Bool;
    var angleD: Float;
    */
    public var halfA: Float;
    public var beta: Float;
    var r: Float;
    public var _theta: Float;
    public var angle1: Float;
    public var angle2: Float;
    /*
    // need to rethink thickness to width ?
    public var thickRatio: Float = 1024;
    var _thick: Float;
    public static var thickness: Float;
    public static var thick( get, set ): Float;
    public static function set_thick( val: Float ):Float{
        if( val < 0 ) val = 0.00001; // TODO: check if this is reasonable lower limit.
        thickness = val/1024;
        return thickness;
    }
    public static function get_thick(): Float {
        return thickness;
    }
    public static function thickSame( val: Float ): Bool {
        return( thickness == val/1024 );
    }
    */
    /*public function width: Float;
    */
    public function new( ){}
    public inline 
    function line( ax_: Float, ay_: Float, bx_: Float, by_: Float, width_: Float, ?endLineCurve: EndLineCurve ): TrilateralPair /*TrilateralArray*/ {
                    // thick
        ax = bx_;
        ay = by_;
        bx = ax_;
        by = ay_;
        halfA = Math.PI/2;
        // thickness
        beta = Math.PI/2 - halfA;
        r = ( width_/2 )*Math.cos( beta );
        // 
        de();
        var d_x_ = dx;
        var d_y_ = dy;
        var e_x_ = ex;
        var e_y_ = ey;
        //switch lines round to get other side but make sure you finish on p1 so that p3 and p4 are useful
        ax = ax_;
        ay = ay_;
        bx = bx_;
        by = by_;
        de();
        /*
        switch( endLineCurve ){
            case no: // don't draw ends
            case begin: // draw curve at beginning
                drawCurveEnd( p0x, p0y, draw.angle1, thick );
            case end: // draw curve at end
                drawCurveEnd( p1x, p1y, draw.angle1 + Math.PI, thick );
            case both: // draw curve at beginning and end
                draw2CurveEnd( p0x, p0y, p1x, p1y, draw.angle1, thick );
            case _: //
        }*/
        return { t0: new Trilateral( d_x_, d_y_, dx, dy, e_x_, e_y_ )
            ,    t1: new Trilateral( d_x_, d_y_, dx, dy, ex, ey ) };
    }
    public inline 
    function de(){
        _theta = theta( ax, ay, bx, by );
        if( _theta > 0 ){
            if( halfA < 0 ){
                angle2 = _theta + halfA + Math.PI/2;
                angle1 =  _theta - halfA;
            } else {
                angle1 =  _theta + halfA - Math.PI;
                angle2 =  _theta + halfA;
            }
        } else {
            if( halfA > 0 ){
                angle1 =  _theta + halfA - Math.PI;
                angle2 =  _theta + halfA;
            } else {
                angle2 = _theta + halfA + Math.PI/2;
                angle1 =  _theta - halfA;
            }
        }
        if( d_x != null ) d_2x = d_x;
        if( e_x != null ) e_2x = e_x;
        if( dx != null ) e_x = dx;
        if( ex != null ) e_x = ex;
        dx = bx + r * Math.cos( angle1 );
        dy = by + r * Math.sin( angle1 );
        ex = bx + r * Math.cos( angle2 );
        ey = by + r * Math.sin( angle2 );
    }
    /*
    public inline 
    function setThickness( val: Float ){
        _thick = val;
        beta = Math.PI/2 - halfA;
        //if( cosA == -1  )
        //r = ( _thick/2 );Math.cos( beta )
        r = ( _thick/2 )*Math.cos( beta );
        //trace( ' r ' + r );
    }
    */
    public static inline 
    function theta( px: Float, py: Float, qx: Float, qy: Float ): Float {
        return Math.atan2( py - qy, px - qx );
    }
    public static inline 
    function dist( px: Float, py: Float, qx: Float, qy: Float  ): Float {
        var x = px - qx;
        var y = py - qy;
        return x*x + y*y;
    }
    
}