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
// based on justTriangles ( no point version properties have been renamed to be shorter thickness is replaced with width ).
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
    
    var fx: Float; // q0
    var fy: Float;
    var gx: Float; // q1
    var gy: Float;
    
    var d_x: Float;
    var d_y: Float;
    var e_x: Float;
    var e_y: Float;
    var d_2x: Float;
    var d_2y: Float;
    var e_2x: Float;
    var e_2y: Float;    
    
    var b2: Float;
    var c2: Float;
    var a2: Float;    
    
    var b: Float; // first line length
    var c: Float; // second line length
    var a: Float;
    var angleD: Float;
    public var angleA: Float; // smallest angle between lines
    var cosA: Float;
    /*
    public var angleA: Float; // smallest angle between lines
    var cosA: Float;


    var clockwiseP2: Bool;
    
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
    function triangleJoin( trilateralArray: TrilateralArray, ax_: Float, ay_: Float, bx_: Float, by_: Float, width_: Float, ?curveEnds: Bool = false ){
        var oldAngle = ( dx != null )? angle1: null;
        halfA = Math.PI/2;
        //  if( d_2x != null ){  ///!!!!!!! thickSame    && thickSame( thick ) ???
            // dx dy ex ey
        // } else {
            // only calculate p3, p4 if missing - not sure if there are any strange cases this misses, seems to work and reduces calculations
            ax = bx_;
            ay = by_;
            bx = ax_;
            by = ay_;
            // thickness
            beta = Math.PI/2 - halfA;
            r = ( width_/2 )*Math.cos( beta );
            // 
            de();
        // }
        //switch lines round to get other side but make sure you finish on p1 so that p3 and p4 are useful
        ax = ax_;
        ay = ay_;
        bx = bx_;
        by = by_;
        de();
        //if( d_2x != null ){ //d_2x != null
            var clockWise = dist( d_2x, d_2y, bx_, by_ ) > dist( e_2x, e_2y, bx_, by_ );
            if( curveEnds ){
                // arc between lines
                if( oldAngle != null ){
                    var dif = Math.abs( angle1 - oldAngle );
                    if( dif > 0.1 ) { // protect against angles where not worth drawing arc which fails due to distance calculations?
                        var oldWidth = width_;
                        width_ = width_/2;
                        var omega = if( clockWise ) {
                                        angle1;
                                    } else {
                                        dif = -dif;
                                        angle2;
                                    }
                        var p = Algebra.arc_internal( ax_, ay_, width_, omega, -dif, 240 );
                        outerPoly( trilateralArray, ax_, ay_, width_, p );  // TODO: Draw the inverse pie shape instead.
                        width_ = oldWidth;
                    }
                }
            }
            //} else { /* should be in here, but there are some gaps when using curve so use the next part to fill.*/ }
            // straight line between lines    
            if( clockWise ){
                   trilateralArray.add( new Trilateral( d_2x, d_2y, e_x, e_y, ax_, ay_ ) );
            } else {
                   trilateralArray.add( new Trilateral( e_2x, e_2y, d_x, d_y, ax_, ay_ ) );
            }
         ///  }
        var t0 = new Trilateral( d_x, d_y, dx, dy, e_x, e_y );
        trilateralArray.add( t0 );
        var t1 = new Trilateral( d_x, d_y, dx, dy,  ex, ey );
        trilateralArray.add( t1 );
        return TrilateralArray;
    }
    public inline
    function create2Lines( ax_: Float, ay_: Float, bx_: Float, by_: Float, cx_: Float, cy_: Float, width_: Float ){
        ax = ax_;
        bx = bx_;
        cx = cx_;
        ay = ay_;
        by = by_;
        cy = cy_;
        b2 = dist( ax, ay, bx, by );
        c2 = dist( bx, by, cx, cy );
        a2 = dist( ax, ay, cx, cy );
        b = Math.sqrt( b2 );
        c = Math.sqrt( c2 );
        a = Math.sqrt( a2 );
        cosA = ( b2 + c2 - a2 )/ ( 2*b*c );
        // clamp cosA between ±1
        if( cosA > 1 ) {
            cosA = 1;
        } else if( cosA < -1 ){
            cosA = -1;
        }
        angleA = Math.acos( cosA );
        // angleD = Math.PI - angleA;
        halfA = angleA/2;
        // thickness
        beta = Math.PI/2 - halfA;
        r = ( width_/2 )*Math.cos( beta );
        // 
        de();
    }
    
    private inline 
    function firstQuad( p: Array<Float>, width_, i: Int ) {
        create2Lines( p[ i ], p[ i + 1 ], p[ i + 2 ], p[ i + 3 ], p[ i + 4 ], p[ i + 5 ], width_ );
        fx = dx;
        fy = dy;
        gx = ex;
        gy = ey;
    }
    public inline 
    function outerPoly( trilateralArray: TrilateralArray, centreX: Float, centreY: Float, width_: Float, p: Array<Float> ){
        fx = p[0];
        fy = p[1];
        gx = p[0];
        gy = p[1];
        firstQuad( p, width_, 0 );
        for( i in 1...Std.int( p.length/2 - 2 ) ) outerFilledTriangles( trilateralArray, centreX, centreY, p, i*2 );
    }
    private inline 
    function outerFilledTriangles( trilateralArray: TrilateralArray, centreX: Float, centreY: Float, p: Array<Float>, i: Int ){
        rebuildAsPoly( p[ i*2 ], p[ i*2 + 1 ] );
        var _x = cx;
        var _y = cy;
        var t = new Trilateral(  fx, fy, _x, _y, centreX, centreY );
        t.mark = true;
        trilateralArray.add( t );
        fx = _x;
        fy = _y;
    }
    public inline 
    function rebuildAsPoly( cx_: Float, cy_: Float ){
        ax = bx;
        ay = by;
        bx = cx;
        by = cy;
        cx = cx_;
        cy = cy_;
        de();
    }
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
        if( d_y != null ) d_2y = d_y;
        if( e_x != null ) e_2x = e_x;
        if( e_y != null ) e_2y = e_y;
        if( dx != null ) d_x = dx;
        if( dy != null ) d_y = dy;
        if( ex != null ) e_x = ex;
        if( ey != null ) e_y = ey;
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