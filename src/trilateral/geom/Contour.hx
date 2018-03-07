package trilateral.geom;
import trilateral.tri.Trilateral;
import trilateral.geom.Algebra;
import trilateral.tri.TrilateralArray;
import trilateral.tri.TrilateralPair;
import trilateral.polys.Poly;
import fracs.Pi2pi;
import fracs.Fraction;
//import fracs.ZeroTo2pi;
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
    }
    //TODO: create lower limit for width   0.00001; ?
    public var count = 0;
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
            var theta0: Float;
            var theta1: Float;
            
            if( clockWise ){
                theta0 = thetaCompute( ax_, ay_, dxOld, dyOld );
                theta1 = thetaCompute( ax_, ay_, exPrev, eyPrev );
            } else {
                theta0 = thetaCompute( ax_, ay_, exOld, eyOld );
                theta1 = thetaCompute( ax_, ay_, dxPrev, dyPrev );
            }
            
            var dif = Angles.differencePrefer( -theta0 - Math.PI/2, -theta1 - Math.PI/2, SMALL );
            var gamma = Math.abs( dif )/2;
            var h = ( width_ ) * Math.sin( gamma );
            var start: Pi2pi = -theta0 - Math.PI/2 ;
            var start2: Float = start;
            var delta = start2 + dif/2 + Math.PI;
            var jx = ax_ + h * Math.sin( delta );
            var jy = ay_ + h * Math.cos( delta );
            
            if( curveEnds ){
                //joinArc
                triArr.addArray( Poly.pie( ax_, ay_, width_/2, -theta0 - Math.PI/2, -theta1 - Math.PI/2, SMALL ) );  // calculates dif in the pie
            } else { /* should be in here, but there are some gaps when using curve so use the next part to fill.*/
            // straight line between lines    
            // don't draw the first one???
                connectQuads( triArr, ax_, ay_, clockWise );
            }
            addQuads( triArr, ax_, ay_, jx, jy, clockWise );
        // addDot( triArr, ax_, ay_, 1 );
        // addDot( triArr, jx, jy, 4 );
        // triArr.addArray( Poly.arc( ax_, ay_, h, 0.008, 0, 2*Math.PI, CLOCKWISE, 5 ) );
        //triArr.addArray( Poly.circleMarked( { x: bx_, y: by_ }, 0.01 ) );
        addSmallTriangles( triArr, jx, jy, clockWise );
        jxOld = jx;
        jyOld = jy;
        lastClock = clockWise;
        count++;
        return triArr;
    }
    var lastClock: Bool;
    var jxOld: Float;
    var jyOld: Float;
    inline function addDot( triArr: TrilateralArray, x: Float, y: Float, color: Int ){
        triArr.addArray( Poly.circleMarked( { x: x, y: y }, 0.008, color ) );
    }
    inline function addSmallTriangles( triArr: TrilateralArray, jx: Float, jy: Float, clockWise: Bool ){
        //if( count == 3 ){
        if( clockWise ){
            var t0 = new Trilateral( ax, ay, dxOld, dyOld, jx, jy );
                #if trilateral_debug t0.mark = 1; #end
            triArr.add( t0 );
            var t1 = new Trilateral( ax, ay, exPrev, eyPrev, jx, jy );
                #if trilateral_debug t1.mark = 5; #end
            triArr.add( t1 );
            //triArr.addArray( Poly.circleMarked( { x: dxOld, y: dyOld }, 0.01 , 3 ) );
            //triArr.addArray( Poly.circleMarked( { x: exPrev, y: eyPrev }, 0.01 , 3) );
        } else {
            var t0 = new Trilateral( ax, ay, exOld, eyOld, jx, jy );
                #if trilateral_debug t0.mark = 1; #end
            triArr.add( t0 );
            var t1 = new Trilateral( ax, ay, dxPrev, dyPrev, jx, jy  );
                #if trilateral_debug t1.mark = 5; #end
            triArr.add( t1 );
            //triArr.addArray( Poly.circleMarked( { x: exOld, y: eyOld }, 0.01, 4 ) );
            //triArr.addArray( Poly.circleMarked( { x: dxPrev, y: dyPrev }, 0.01 , 3) );
        }
        //}
    }
    // The triangle between quads
    inline function connectQuads( triArr: TrilateralArray, x: Float, y: Float, clockWise: Bool ){
        if( clockWise ){
            triArr.add( new Trilateral( dxOld, dyOld, exPrev, eyPrev, x, y ) );
        } else {
            triArr.add( new Trilateral( exOld, eyOld, dxPrev, dyPrev, x, y ) );
        }
    }
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
    
    // these are Quads that don't use the inner connection so they overlap
    // draw these first and replace them?
    inline function genericQuads( triArr: TrilateralArray, jx: Float, jy: Float, clockWise ){
        //These get replaced as drawing only to leave the last one
        var t0: Trilateral;
        var t1: Trilateral;
        quadIndex = triArr.length;
        if( count == 0 ){ // first line
            t1 = new Trilateral( dxPrev, dyPrev, dx, dy, exPrev, eyPrev );
                #if trilateral_debug t1.mark = 12; #end // white
            triArr.add( t1 );
            t0 = new Trilateral( dxPrev, dyPrev, dx, dy, ex, ey );
                #if trilateral_debug t0.mark = 8; #end
            triArr.add( t0 );
        } else {
            if( clockWise && !lastClock ){ // DONE
                t1 = new Trilateral( jx, jy, dx, dy, exPrev, eyPrev );
                    #if trilateral_debug t1.mark = 12; #end// white
                triArr.add( t1 );
                t0 = new Trilateral( jx, jy, dx, dy, ex, ey );
                    #if trilateral_debug t0.mark = 8; #end // grey
                triArr.add( t0 );
            }
            if( clockWise && lastClock ){
                t1 = new Trilateral( jx, jy, dx, dy, exPrev, eyPrev );
                    #if trilateral_debug t1.mark = 12; #end// white
                triArr.add( t1 );
                // dxPrev, dyPrev, dx, dy, ex, ey 
                t0 = new Trilateral( jx, jy, dx, dy, ex, ey  );
                    #if trilateral_debug t0.mark = 8; #end
                triArr.add( t0 );
            }
            if( !clockWise && !lastClock ){
                t1 = new Trilateral( dxPrev, dyPrev, dx, dy, ex, ey );
                    #if trilateral_debug t1.mark = 12; #end// white
                triArr.add( t1 );
                t0 = new Trilateral( dxPrev, dyPrev, dx, dy, jx, jy );
                    #if trilateral_debug t0.mark = 8; #end// grey
                triArr.add( t0 );
            }
            if( !clockWise && lastClock ){
                t1 = new Trilateral( dxPrev, dyPrev, jx, jy, ex, ey );
                    #if trilateral_debug t1.mark = 12; #end// white
                triArr.add( t1 );
                t0 = new Trilateral( jx, jy, dx, dy, ex, ey );
                    #if trilateral_debug t0.mark = 8; #end
                triArr.add( t0 );
            }
            
        }
    }

    // main section of triangleJoin line
    inline function addQuads( triArr: TrilateralArray, x: Float, y: Float, jx: Float, jy: Float, clockWise: Bool ){
        var t0: Trilateral;
        var t1: Trilateral;
        
        if( clockWise && !lastClock ){
            t1 = new Trilateral( kax, kay, kbx, kby, jx, jy );
                #if trilateral_debug t1.mark = 6; #end// purple
            triArr[ quadIndex ] = t1;
            if( count == 1 ){// deals with first case
                t0 = new Trilateral( nax, nay, nbx, nby, ncx, ncy );
                    #if trilateral_debug t0.mark = 7; #end
                triArr[ quadIndex + 1 ] = t0;
            } else {
                t0 = new Trilateral( nax, nay, nbx, nby, jxOld, jyOld );
                    #if trilateral_debug t0.mark = 7; #end
                triArr[ quadIndex + 1 ] = t0;
            }
        }
        if( clockWise && lastClock ){
            if( count == 1 ){
                t1 = new Trilateral( kax, kay, kbx, kby, jx, jy );
                    #if trilateral_debug t1.mark = 6; #end // purple
                triArr[ quadIndex ] = t1;
                t0 = new Trilateral( nax, nay, nbx, nby, ncx, ncy );
                    #if trilateral_debug t0.mark = 7; #end
                triArr[ quadIndex + 1 ] = t0;
            } else {
                t1 = new Trilateral( jxOld, jyOld, kbx, kby, jx, jy );
                    #if trilateral_debug t1.mark = 6; #end// purple
                triArr[ quadIndex ] = t1;
                t0 = new Trilateral( jxOld, jyOld, nbx, nby, ncx, ncy );
                    #if trilateral_debug t0.mark = 7; #end
                triArr[ quadIndex + 1 ] = t0;
            }
        }
        if( !clockWise && !lastClock ){
            t1 = new Trilateral( kax, kay, jx, jy, kcx, kcy );
                #if trilateral_debug t1.mark = 6; #end// purple
            triArr[ quadIndex ] = t1;
            if( count == 1 ){
                t0 = new Trilateral( nax, nay, jx, jy, ncx, ncy );//jxOld, jyOld );
                    #if trilateral_debug t0.mark = 7; #end
                triArr[ quadIndex + 1 ] = t0;
            } else {
                t0 = new Trilateral( nax, nay, jx, jy, jxOld, jyOld );
                    #if trilateral_debug t0.mark = 7; #end
                triArr[ quadIndex + 1 ] = t0;
            }
            
        }
        if( !clockWise && lastClock ){
            if( count == 1 ){
                t1 = new Trilateral( kax, kay, jx, jy, kcx, kcy );
                    #if trilateral_debug t1.mark = 6; #end // purple
                triArr[ quadIndex ] = t1;
                t0 = new Trilateral( nax, nay, jx, jy, ncx, ncy );
                    #if trilateral_debug t0.mark = 7; #end
                triArr[ quadIndex + 1 ] = t0;
            } else {
                t1 = new Trilateral( jxOld, jyOld, jx, jy, kcx, kcy );
                    #if trilateral_debug t1.mark = 6; #end // purple
                triArr[ quadIndex ] = t1;
                t0 = new Trilateral(jxOld, jyOld, jx, jy, ncx, ncy );
                    #if trilateral_debug t0.mark = 7; #end
                triArr[ quadIndex + 1 ] = t0;
            }
        }
        genericQuads( triArr, jx, jy, clockWise );
        storeLastQuads();
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
    /*
    var q0x: Float;
    var q0y: Float;
    var q1x: Float;
    var q1y: Float;
    
    public inline 
    function poly( triArr: TrilateralArray, p: Array<Float>, width_: Float ){
        q0x = p[0];
        q0y = p[1];
        q1x = p[2];
        q1y = p[3]; 
        firstQuad( triArr, p, 0, width_ );
        for( i in 2...( p.length - 4 ) ) {
            if( i%2 == 0 ) otherQuad( triArr, p, i, width_ ); 
        }// Have to get loop right
    }
    inline
    function firstQuad( triArr: TrilateralArray, p: Array<Float>, i: Int, width_: Float ) {
        create2Lines( p[ i ], p[ i + 1 ], p[ i + 2 ], p[ i + 3 ], p[ i + 4 ], p[ i + 5 ], width_ );
        q0x = dx;
        q0y = dy;
        q1x = ex;
        q1y = ey;
    }
    // assumes that firstQuad is drawn.
    inline
    function otherQuad( triArr: TrilateralArray, p: Array<Float>, i: Int, width_: Float ){
        ax = bx;
        ay = by;
        bx = cx;
        by = cy;
        cx = p[ i + 4];
        cy = p[ i + 5];
        computeDE();
        var q3x = dx;
        var q3y = dy;
        var q4x = ex;
        var q4y = ey;
        addDot( triArr, q0x, q0y );
        addDot( triArr, q1x, q1y );
        addDot( triArr, q3x, q3y );
        addDot( triArr, q4x, q4y );
        triArr.add( new Trilateral(q1x, q1y , q3x, q3y, q0x, q0x ) );
        triArr.add( new Trilateral( q1x, q1x, q3x, q3y, q4x, q4y ) );
        q0x = q3x;
        q0y = q3y;
        q1x = q4x;
        q1y = q4y;
    }
    public
    function create2Lines( ax_: Float, ay_: Float, bx_: Float, by_: Float, cx_: Float, cy_: Float, width_: Float ){
        ax = ax_;
        bx = bx_;
        cx = cx_;
        ay = ay_;
        by = by_;
        cy = cy_;
        var b2 = dist( ax, ay, bx, by );
        var c2 = dist( bx, by, cx, cy );
        var a2 = dist( ax, ay, cx, cy );
        var b = Math.sqrt( b2 );
        var c = Math.sqrt( c2 );
        var a = Math.sqrt( a2 );
        var cosA = ( b2 + c2 - a2 )/ ( 2*b*c );
        // clamp cosA between ±1
        if( cosA > 1 ) {
            cosA = 1;
        } else if( cosA < -1 ){
            cosA = -1;
        }
        angleA = Math.acos( cosA )+Math.PI;
        // angleD = Math.PI - angleA;
        halfA = angleA/2;
        // thickness
        beta = Math.PI/2 - halfA;
        r = ( width_/2 )*Math.cos( beta );
        // 
        computeDE();
    }
    */
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