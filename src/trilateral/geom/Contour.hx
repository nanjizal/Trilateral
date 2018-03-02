package trilateral.geom;
import trilateral.tri.Trilateral;
import trilateral.geom.Algebra;
import trilateral.tri.TrilateralArray;
import trilateral.tri.TrilateralPair;
// Rethink name!
@:enum
abstract EndLineCurve( Int ){
    var no = 0;
    var begin = 1;
    var end = 2;
    var both = 3;
}
// based on justTriangles ( no point version properties have been renamed to be shorter thickness is replaced with width ).
class Contour {
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
    
    var dxPrev: Float;
    var dyPrev: Float;
    var exPrev: Float;
    var eyPrev: Float;
    var dxOld: Float;
    var dyOld: Float;
    var exOld: Float;
    var eyOld: Float;    
    var endContour: Contour;
    /*
    // currently only used in static?
    var b2: Float;
    var c2: Float;
    var a2: Float;    
    
    var b: Float; // first line length
    var c: Float; // second line length
    var a: Float;
    */
    
    var angleD: Float;
    public var angleA: Float; // smallest angle between lines
    var cosA: Float;

    //var clockwiseP2: Bool;
    
    public var halfA: Float;
    public var beta: Float;
    var r: Float;
    public var theta: Float;
    public var angle1: Float;
    public var angle2: Float;
    
    //TODO: create lower limit for width   0.00001; ?
    
    public function new( ){}
    public inline
    function triangleJoin( triArr: TrilateralArray, ax_: Float, ay_: Float, bx_: Float, by_: Float, width_: Float, ?curveEnds: Bool = false ){
        var oldAngle = ( dx != null )? angle1: null;  // I am not sure I can move this to curveJoins because angle1 is set by computeDE
        halfA = Math.PI/2;
        //  if( dxOld != null ){  ///!!!!!!! thickSame    && thickSame( thick ) ???
            // dx dy ex ey
        // } else {
            // only calculate p3, p4 if missing - not sure if there are any strange cases this misses, seems to work and reduces calculations
            ax = bx_;
            ay = by_;
            bx = ax_;
            by = ay_;
            beta = Math.PI/2 - halfA;           // thickness
            r = ( width_/2 )*Math.cos( beta );  // thickness
            computeDE();
        // }
        //switch lines round to get other side but make sure you finish on p1 so that p3 and p4 are useful
        ax = ax_;
        ay = ay_;
        bx = bx_;
        by = by_;
        computeDE();
        //if( dxOld != null ){ //dxOld != null
            var clockWise = isClockwise( bx_, by_ );
            if( curveEnds ){
                // Broken!!!
                curveJoins( triArr, ax_, ay_, width_, oldAngle, clockWise );
            }
            //} else { /* should be in here, but there are some gaps when using curve so use the next part to fill.*/ }
            // straight line between lines    
            // don't draw the first one???
            connectQuads( triArr, ax_, ay_, clockWise );
         ///  }
        addQuads( triArr );
        return triArr;
    }
    // curveJoins is for currently 'finest' connection where it adds a pie at the end, 
    // since draw commands are not reversed now it's broken providing packman rather than pie segment fill.
    inline function curveJoins( triArr: TrilateralArray, x: Float, y: Float, width_: Float, oldAngle: Float, clockWise: Bool ){
        // needs to use a new Contour perhaps or reset after use as it messes the variables up.
        // arc between lines
        if( oldAngle != null ){
            var dif = Math.abs( angle1 - oldAngle );
            if( dif > 0.1 ) { // protect against angles where not worth drawing arc which fails due to distance calculations?
                var oldWidth = width_;
                //width_ = width_/2;
                var omega = if( clockWise ) {
                                angle1;
                            } else {
                                dif = -dif;
                                angle2;
                            }
                var p = Algebra.arc_internal( x, y, width_/2, omega, dif, 240 );
                outerPoly( triArr, x, y, width_/2, p );
                //width_ = oldWidth;
            }
        }
    }
    // The triangle between quads
    inline function connectQuads( triArr: TrilateralArray, x: Float, y: Float, clockWise: Bool ){
        if( clockWise ){
            triArr.add( new Trilateral( dxOld, dyOld, exPrev, eyPrev, x, y ) );
        } else {
            triArr.add( new Trilateral( exOld, eyOld, dxPrev, dyPrev, x, y ) );
        }
    }
    // main section of triangleJoin line
    inline function addQuads( triArr: TrilateralArray ){
        triArr.add( new Trilateral( dxPrev, dyPrev, dx, dy, exPrev, eyPrev ) );
        triArr.add( new Trilateral( dxPrev, dyPrev, dx, dy,  ex, ey ) );
    }
    inline function isClockwise( x: Float, y: Float ): Bool {
         return dist( dxOld, dyOld, x, y ) > dist( exOld, eyOld, x, y );
    }
    public inline
    function create2Lines( ax_: Float, ay_: Float, bx_: Float, by_: Float, cx_: Float, cy_: Float, width_: Float ){
        ax = ax_;
        bx = bx_;
        cx = cx_;
        ay = ay_;
        by = by_;
        cy = cy_;
        cosA = computeCosA( ax, ay, bx, by, cx, cy );
        angleA = Math.acos( cosA );
        // angleD = Math.PI - angleA;  // old code??
        halfA = angleA/2;
        beta = Math.PI/2 - halfA;           // thickness
        r = ( width_/2 )*Math.cos( beta );  // thickness
        computeDE();
    }
    inline 
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
        computeDE();
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
        computeDE();
        var dxPrev_ = dx;
        var dyPrev_ = dy;
        var exPrev_ = ex;
        var eyPrev_ = ey;
        //switch lines round to get other side but make sure you finish on p1 so that p3 and p4 are useful
        ax = ax_;
        ay = ay_;
        bx = bx_;
        by = by_;
        computeDE();
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
        return { t0: new Trilateral( dxPrev_, dyPrev_, dx, dy, exPrev_, eyPrev_ )
            ,    t1: new Trilateral( dxPrev_, dyPrev_, dx, dy, ex, ey ) };
    }
    public inline 
    function computeDE(){
        anglesCompute();
        if( dxPrev != null ) dxOld = dxPrev;
        if( dyPrev != null ) dyOld = dyPrev;
        if( exPrev != null ) exOld = exPrev;
        if( eyPrev != null ) eyOld = eyPrev;
        if( dx != null ) dxPrev = dx;
        if( dy != null ) dyPrev = dy;
        if( ex != null ) exPrev = ex;
        if( ey != null ) eyPrev = ey;
        dx = bx + r * Math.cos( angle1 );
        dy = by + r * Math.sin( angle1 );
        ex = bx + r * Math.cos( angle2 );
        ey = by + r * Math.sin( angle2 );
    }
    inline
    function anglesCompute(){
        theta = thetaCompute( ax, ay, bx, by );
        if( theta > 0 ){
            if( halfA < 0 ){
                angle2 = theta + halfA + Math.PI/2;
                angle1 =  theta - halfA;
            } else {
                angle1 =  theta + halfA - Math.PI;
                angle2 =  theta + halfA;
            }
        } else {
            if( halfA > 0 ){
                angle1 =  theta + halfA - Math.PI;
                angle2 =  theta + halfA;
            } else {
                angle2 = theta + halfA + Math.PI/2;
                angle1 =  theta - halfA;
            }
        }
    }
    public static inline
    function computeCosA( ax: Float, ay:Float, bx: Float, by: Float, cx: Float, cy: Float ){
        var b2 = dist( ax, ay, bx, by );
        var c2 = dist( bx, by, cx, cy );
        var a2 = dist( ax, ay, cx, cy );
        var b = Math.sqrt( b2 );
        var c = Math.sqrt( c2 );
        var a = Math.sqrt( a2 );
        var cosA = ( b2 + c2 - a2 )/ ( 2*b*c ); // cosA
        // clamp cosA between ±1
        if( cosA > 1 ) {
            cosA = 1;
        } else if( cosA < -1 ){
            cosA = -1;
        }
        return cosA;
    }
    public static inline 
    function thetaCompute( px: Float, py: Float, qx: Float, qy: Float ): Float {
        return Math.atan2( py - qy, px - qx );
    }
    public static inline 
    function dist( px: Float, py: Float, qx: Float, qy: Float  ): Float {
        var x = px - qx;
        var y = py - qy;
        return x*x + y*y;
    }
    
}