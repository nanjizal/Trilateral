package trilateral.geom;
import trilateral.tri.Trilateral;
import trilateral.geom.Algebra;
import trilateral.tri.TrilateralArray;
import trilateral.tri.TrilateralPair;
import trilateral.polys.Poly;
import fracs.Pi2pi;
import fracs.Angles;

@:enum
abstract EndLineCurve( Int ){
    var no = 0;
    var begin = 1;
    var end = 2;
    var both = 3;
}
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
    
    var angleD: Float;
    public var angleA: Float; // smallest angle between lines
    //var cosA: Float;

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
        //  if( dxOld != null ){
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
                joinCurve( triArr, ax_, ay_, width_, clockWise );
            } else { /* should be in here, but there are some gaps when using curve so use the next part to fill.*/
            // straight line between lines    
            // don't draw the first one???
                connectQuads( triArr, ax_, ay_, clockWise );
            }
            addQuads( triArr );
        return triArr;
    }
    inline function joinCurve( triArr: TrilateralArray, x: Float, y: Float, width_: Float, clockWise: Bool ){
        if( clockWise ){
            var theta0 = thetaCompute( x, y, dxOld, dyOld );
            var theta1 = thetaCompute( x, y, exPrev, eyPrev );
            triArr.addArray( Poly.pie( x, y, width_/2, -theta0 - Math.PI/2, -theta1 - Math.PI/2, SMALL ) );
        } else {
            var theta0 = thetaCompute( x, y, exOld, eyOld );
            var theta1 = thetaCompute( x, y, dxPrev, dyPrev );
            triArr.addArray( Poly.pie( x, y, width_/2, -theta0 - Math.PI/2, -theta1 - Math.PI/2, SMALL ) );   
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
    function line( triArr: TrilateralArray, ax_: Float, ay_: Float, bx_: Float, by_: Float, width_: Float, ?endLineCurve: EndLineCurve ){
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
        switch( endLineCurve ){
            case no: // don't draw ends
            case begin: 
                triArr.addArray( Poly.pie( ax_, ay_, width_/2, -angle1 - Math.PI/2, -angle1 - Math.PI/2 + Math.PI, SMALL ) );
            case end:
                triArr.addArray( Poly.pie( bx_, by_, width_/2, -angle1 - Math.PI/2, -angle1 - Math.PI/2 - Math.PI, SMALL ) );
            case both:
                triArr.addArray( Poly.pie( ax_, ay_, width_/2, -angle1 - Math.PI/2, -angle1 - Math.PI/2 + Math.PI, SMALL ) );
                triArr.addArray( Poly.pie( bx_, by_, width_/2, -angle1 - Math.PI/2, -angle1 - Math.PI/2 - Math.PI, SMALL ) );
        }
        triArr.add( new Trilateral( dxPrev_, dyPrev_, dx, dy, exPrev_, eyPrev_ ) );
        triArr.add( new Trilateral( dxPrev_, dyPrev_, dx, dy, ex, ey ) );
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