package trilateral.geom;
import trilateral.tri.Trilateral;
import trilateral.geom.Algebra;
import trilateral.tri.TrilateralArray;
import trilateral.tri.TrilateralPair;
import trilateral.polys.Poly;
import trilateral.angle.Pi2pi;
import trilateral.angle.Fraction;
//import trilateral.angle.ZeroTo2pi;
import trilateral.angle.Angles;

@:enum
abstract EndLineCurve( Int ){
    var no = 0;
    var begin = 1;
    var end = 2;
    var both = 3;
}
class Contour {
    var triArr: TrilateralArray;
    var endLine: EndLineCurve;
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
    var jx: Float;
    var jy: Float;
    var lastClock: Bool;
    var jxOld: Float;
    var jyOld: Float;
    
    var kax: Float;
    var kay: Float;
    var kbx: Float;
    var kby: Float;
    var kcx: Float;
    var kcy: Float;
    var nax: Float;
    var nay: Float;
    var nbx: Float;
    var nby: Float;
    var ncx: Float;
    var ncy: Float;
    var quadIndex: Int;
    
    //var angleD: Float;
    public var angleA: Float; // smallest angle between lines
    //var cosA: Float;

    //var clockwiseP2: Bool;
    
    public var halfA: Float;
    public var beta: Float;
    var r: Float;
    public var theta: Float;
    public var angle1: Float;
    public var angle2: Float;
    
    public function reset(){
        angleA = null;
        count = 0;
        kax = null;
        kay = null;
        kbx = null;
        kby = null;
        kcx = null; 
        kcy = null;
        nax = null;
        nay = null;
        nbx = null;
        nby = null;
        ncx = null;
        ncy = null;
        ax = null;
        ay = null;
        bx = null;
        by = null;
        cx = null;
        cy = null;
        dx = null;
        dy = null;
        ex = null;
        ey = null;
        fx = null;
        fy = null;
        gx = null;
        gy = null;
    }
    //TODO: create lower limit for width   0.00001; ?
    public var count = 0;
    public function new( triArr_: TrilateralArray, ?endLine_: EndLineCurve = no ){
        triArr = triArr_;
        endLine = endLine_;
    }
    public inline
    function triangleJoin( ax_: Float, ay_: Float, bx_: Float, by_: Float, width_: Float, ?curveEnds: Bool = false, ?overlap: Bool = false ){
        var oldAngle = ( dx != null )? angle1: null;  // I am not sure I can move this to curveJoins because angle1 is set by computeDE
        halfA = Math.PI/2;
        //if( dxOld != null ){  // this makes it a lot faster but a bit of path in some instance disappear needs more thought to remove....
            // dx dy ex ey
        //} else {
            // only calculate p3, p4 if missing - not sure if there are any strange cases this misses, seems to work and reduces calculations
            ax = bx_;
            ay = by_;
            bx = ax_;
            by = ay_;
            beta = Math.PI/2 - halfA;           // thickness
            r = ( width_/2 )*Math.cos( beta );  // thickness
            computeDE();
            //}
        //switch lines round to get other side but make sure you finish on p1 so that p3 and p4 are useful
        ax = ax_;
        ay = ay_;
        bx = bx_;
        by = by_;
        computeDE();
        //if( dxOld != null ){ //dxOld != null
            var clockWise = isClockwise( bx_, by_ );
            var theta0: Float;
            var theta1: Float;
            if( clockWise ){
                theta0 = thetaComputeAdj( dxOld, dyOld );
                theta1 = thetaComputeAdj( exPrev, eyPrev );
            } else {
                theta0 = thetaComputeAdj( exOld, eyOld );
                theta1 = thetaComputeAdj( dxPrev, dyPrev );
            }
            var dif = Angles.differencePrefer( theta0, theta1, SMALL );
            if( !overlap && count != 0 ) computeJ( width_, theta0, dif ); // don't calculate j if your just overlapping quads
            
            if( count == 0 && ( endLine == begin || endLine == both ) ) addPie( ax, ay, width_/2, -angle1 - Math.PI/2, -angle1 - Math.PI/2 + Math.PI, SMALL );
            
            if( curveEnds ){
                //joinArc
                addArray( Poly.pieDif( ax_, ay_, width_/2, theta0, dif ) );
            } else {
            // straight line between lines    
                if( count != 0 ){
                    if( overlap ){ // just draw down to a as overlapping quads
                        connectQuadsWhenQuadsOverlay( clockWise );
                    } else {
                        connectQuads( clockWise );
                    }
                }
            }
            if( overlap ){
                overlapQuad(); // not normal
            }else {
                if( count != 0 ) addQuads( clockWise );
                addInitialQuads( clockWise );
            }
            storeLastQuads();
        if( curveEnds && !overlap && count != 0 ) addSmallTriangles( clockWise );
        jxOld = jx;
        jyOld = jy;
        lastClock = clockWise;
        count++;
        return triArr;
    }
    inline
    function overlapQuad(){
        addTri( dxPrev, dyPrev, dx, dy, ex, ey #if trilateral_debug ,8 #end );
        addTri( dxPrev, dyPrev, dx, dy, exPrev, eyPrev #if trilateral_debug ,12 #end );
    }
    // call to add round end to line
    public inline
    function end( width_: Float ){
        addPie( bx, by, width_/2, -angle1 - Math.PI/2, -angle1 - Math.PI/2 - Math.PI, SMALL );
    }
    inline
    function add( trilateral: Trilateral ){
        triArr.add( trilateral );
    }
    inline
    function addArray( trilateralArray: TrilateralArray ){
        triArr.addArray( trilateralArray );
    }
    inline 
    function addTri( ax_: Float, ay_: Float, bx_: Float, by_: Float, cx_: Float, cy_: Float, ?mark_: Int = 0 ){
        triArr.add( new Trilateral( ax_, ay_, bx_, by_, cx_, cy_, mark_ ) );
    }
    inline
    function addPie( ax: Float, ay: Float, radius: Float, beta: Float, gamma: Float, prefer: DifferencePreference, ?mark: Int = 0, ?sides: Int = 36 ){
        triArr.addArray( Poly.pie( ax, ay, radius, beta, gamma, prefer, mark, sides ) );
    }
    inline
    function computeJ( width_: Float, theta0: Float, dif: Float ){
        var gamma = Math.abs( dif )/2;
        var h = ( width_ ) * Math.sin( gamma );
        var start: Pi2pi = theta0;
        var start2: Float = start;
        var delta = start2 + dif/2 + Math.PI;
        jx = ax + h * Math.sin( delta );
        jy = ay + h * Math.cos( delta );
    }
    inline 
    function addDot( x: Float, y: Float, color: Int ){
        addArray( Poly.circleMarked( x, y, 0.008, color ) );
    }
    inline
    function addSmallTriangles( clockWise: Bool ){
        if( clockWise ){
            addTri( ax, ay, dxOld,  dyOld,  jx, jy #if trilateral_debug ,1 #end );
            addTri( ax, ay, exPrev, eyPrev, jx, jy #if trilateral_debug ,3 #end );
            #if trilateral_debugPoints addTriangleCorners( dxOld, dyOld, exPrev, eyPrev ); #end
        } else {
            addTri( ax, ay, exOld, eyOld, jx, jy #if trilateral_debug ,1 #end );
            addTri( ax, ay, dxPrev, dyPrev, jx, jy #if trilateral_debug ,3 #end );
            #if trilateral_debugPoints addTriangleCorners( exOld, eyOld, dxPrev, dyPrev ); #end
        }
    }
    inline
    function addTriangleCorners( oldx_: Float, oldy_: Float, prevx_: Float, prevy_: Float ){
        addArray( Poly.circleMarked( oldx_, oldy_, 0.01 , 4 ) );
        addArray( Poly.circleMarked( prevx_, prevy_, 0.01 , 3 ) );
        addArray( Poly.circleMarked( ax, ay, 0.01 , 10 ) );
        addArray( Poly.circleMarked( jx, jy, 0.01 , 5 ) );
    }
    inline
    function addTriangleCornersLess( oldx_: Float, oldy_: Float, prevx_: Float, prevy_: Float ){
        addArray( Poly.circleMarked( oldx_, oldy_, 0.01 , 4 ) );
        addArray( Poly.circleMarked( prevx_, prevy_, 0.01 , 3 ) );
        addArray( Poly.circleMarked( jx, jy, 0.01 , 5 ) );
    }
    // The triangle between quads
    inline
    function connectQuadsWhenQuadsOverlay( clockWise: Bool ){
        if( clockWise ){
            addTri( dxOld, dyOld, exPrev, eyPrev, ax, ay );
            #if trilateral_debugPoints addTriangleCornersLess( dxOld, dyOld, exPrev, eyPrev ); #end
        } else {
            addTri( exOld, eyOld, dxPrev, dyPrev, ax, ay );
            #if trilateral_debugPoints addTriangleCornersLess( exOld, eyOld, dxPrev, dyPrev ); #end
        }
    }
    // The triangle between quads
    inline
    function connectQuads( clockWise: Bool ){
        if( clockWise ){
            addTri( dxOld, dyOld, exPrev, eyPrev, jx, jy );
            #if trilateral_debugPoints addTriangleCornersLess( dxOld, dyOld, exPrev, eyPrev ); #end
        } else {
            addTri( exOld, eyOld, dxPrev, dyPrev, jx, jy );
            #if trilateral_debugPoints addTriangleCornersLess( exOld, eyOld, dxPrev, dyPrev ); #end
        }
    }
    // these are Quads that don't use the second inner connection so they overlap at the end
    // draw these first and replace them?
    inline 
    function addInitialQuads( clockWise ){
        //These get replaced as drawing only to leave the last one
        quadIndex = triArr.length;
        if( count == 0 ){ // first line
            addTri( dxPrev, dyPrev, dx, dy, ex, ey #if trilateral_debug ,8 #end );
            addTri( dxPrev, dyPrev, dx, dy, exPrev, eyPrev #if trilateral_debug ,12 #end );
        } else {
            if( clockWise && !lastClock ){
                addTri( jx, jy, dx, dy, ex, ey #if trilateral_debug ,8 #end );
                addTri( jx, jy, dx, dy, exPrev, eyPrev #if trilateral_debug ,12 #end );
            }
            if( clockWise && lastClock ){
                addTri( jx, jy, dx, dy, ex, ey #if trilateral_debug ,8 #end );
                addTri( jx, jy, dx, dy, exPrev, eyPrev #if trilateral_debug ,12 #end );
            }
            if( !clockWise && !lastClock ){
                addTri( dxPrev, dyPrev, dx, dy, jx, jy #if trilateral_debug ,8 #end );
                addTri( dxPrev, dyPrev, dx, dy, ex, ey #if trilateral_debug ,12 #end );
            }
            if( !clockWise && lastClock ){
                addTri( jx, jy, dx, dy, ex, ey #if trilateral_debug ,8 #end );
                addTri( dxPrev, dyPrev, jx, jy, ex, ey #if trilateral_debug ,12 #end );
            }
        }
    }
    // replace the section quads with quads with both inner points
    inline 
    function addQuads( clockWise: Bool ){
        if( clockWise && !lastClock ){
            if( count == 1 ){ // deals with first case
                triArr[ quadIndex + 1 ] = new Trilateral( nax, nay, nbx, nby, ncx, ncy #if trilateral_debug ,7 #end );
            } else {
                triArr[ quadIndex + 1 ] = new Trilateral( nax, nay, nbx, nby, jxOld, jyOld #if trilateral_debug ,7 #end );
            }
            triArr[ quadIndex ] = new Trilateral( kax, kay, kbx, kby, jx, jy #if trilateral_debug ,6 #end );
        }
        if( clockWise && lastClock ){
            if( count == 1 ){
                triArr[ quadIndex ] = new Trilateral( kax, kay, kbx, kby, jx, jy #if trilateral_debug ,6 #end );
                triArr[ quadIndex + 1 ] = new Trilateral( nax, nay, nbx, nby, ncx, ncy #if trilateral_debug ,7 #end );
            } else {
                triArr[ quadIndex ] = new Trilateral( jxOld, jyOld, kbx, kby, jx, jy #if trilateral_debug ,6 #end );
                triArr[ quadIndex + 1 ] = new Trilateral( jxOld, jyOld, nbx, nby, ncx, ncy #if trilateral_debug ,7 #end );
            }
        }
        if( !clockWise && !lastClock ){
            triArr[ quadIndex ] = new Trilateral( kax, kay, jx, jy, kcx, kcy #if trilateral_debug ,6 #end );
            if( count == 1 ){
                triArr[ quadIndex + 1 ] = new Trilateral( nax, nay, jx, jy, ncx, ncy #if trilateral_debug ,7 #end );
            } else {
                triArr[ quadIndex + 1 ] = new Trilateral( nax, nay, jx, jy, jxOld, jyOld #if trilateral_debug ,7 #end );
            }
        }
        if( !clockWise && lastClock ){
            if( count == 1 ){
                triArr[ quadIndex ] = new Trilateral( kax, kay, jx, jy, kcx, kcy #if trilateral_debug ,6 #end );
                triArr[ quadIndex + 1 ] = new Trilateral( nax, nay, jx, jy, ncx, ncy #if trilateral_debug ,7 #end );
            } else {
                triArr[ quadIndex ] = new Trilateral( jxOld, jyOld, jx, jy, kcx, kcy #if trilateral_debug ,6 #end );
                triArr[ quadIndex + 1 ] = new Trilateral( jxOld, jyOld, jx, jy, ncx, ncy #if trilateral_debug ,7 #end );
            }
        }
    }
    inline function storeLastQuads(){
        nax = dxPrev;
        nay = dyPrev;
        nbx = dx;
        nby = dy;
        ncx = exPrev;
        ncy = eyPrev;
        kax = dxPrev;
        kay = dyPrev;
        kbx = dx;
        kby = dy;
        kcx = ex;
        kcy = ey;
    }
    inline function isClockwise( x: Float, y: Float ): Bool {
         return dist( dxOld, dyOld, x, y ) > dist( exOld, eyOld, x, y );
    }
    public inline 
    function line( ax_: Float, ay_: Float, bx_: Float, by_: Float, width_: Float, ?endLineCurve: EndLineCurve ){
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
            case no: 
                // don't draw ends
            case begin: 
                addPie( ax_, ay_, width_/2, -angle1 - Math.PI/2, -angle1 - Math.PI/2 + Math.PI, SMALL );
            case end:
                addPie( bx_, by_, width_/2, -angle1 - Math.PI/2, -angle1 - Math.PI/2 - Math.PI, SMALL );
            case both:
                addPie( ax_, ay_, width_/2, -angle1 - Math.PI/2, -angle1 - Math.PI/2 + Math.PI, SMALL );
                addPie( bx_, by_, width_/2, -angle1 - Math.PI/2, -angle1 - Math.PI/2 - Math.PI, SMALL );
        }
        addTri( dxPrev_, dyPrev_, dx, dy, exPrev_, eyPrev_ );
        addTri( dxPrev_, dyPrev_, dx, dy, ex, ey );
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
    inline
    function thetaComputeAdj( qx: Float, qy: Float ): Float {
        return -thetaCompute( ax, ay, qx, qy ) - Math.PI/2;
    }
    static inline 
    function thetaCompute( px: Float, py: Float, qx: Float, qy: Float ): Float {
        return Math.atan2( py - qy, px - qx );
    }
    static inline 
    function dist( px: Float, py: Float, qx: Float, qy: Float  ): Float {
        var x = px - qx;
        var y = py - qy;
        return x*x + y*y;
    }
    
}