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
#if trilateral_includeSegments
import trilateralXtra.segment.SixteenSeg;
import trilateralXtra.segment.SevenSeg;
#end
@:enum
abstract EndLineCurve( Int ){
    var no = 0;
    var begin = 1;
    var end = 2;
    var both = 3;
}
class Contour {
    // only relevant if debug parameters are set.
    // public var debugOn:         Bool;
    public var pointsClock:     Array<Float> = [];
    public var pointsAnti:      Array<Float> = [];
    public var penultimateCX:   Float;
    public var penultimateCY:   Float;
    public var lastClockX:      Float;
    public var lastClockY:      Float;
    public var penultimateAX:   Float;
    public var penultimateAY:   Float;
    public var lastAntiX:       Float;
    public var lastAntiY:       Float; 
    
    var triArr: TrilateralArray;
    var endLine: EndLineCurve;
    var ax: Float; // 0
    var ay: Float; // 0
    var bx: Float; // 1
    var by: Float; // 1
    var cx: Float; // 2
    var cy: Float; // 2
    var dx: Null<Float>; // 3     // computeDE checks null
    var dy: Null<Float>; // 3
    var ex: Null<Float>; // 4
    var ey: Null<Float>; // 4
    
    /*var fx: Float; // q0
    var fy: Float;
    var gx: Float; // q1
    var gy: Float;*/
    
    var dxPrev: Null<Float>; // computeDE checks null
    var dyPrev: Null<Float>;
    var exPrev: Null<Float>;
    var eyPrev: Null<Float>;
    var dxOld: Null<Float>;
    var dyOld: Null<Float>;
    var exOld: Null<Float>;
    var eyOld: Null<Float>;
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
    public var angle1: Null<Float>;  // triangleJoin checks null
    public var angle2: Float;
    inline static var smallDotScale = 0.07;
    
    public function reset(){
        angleA = 0; //null;
        count = 0;
        kax = 0; //null;
        kay = 0; //null;
        kbx = 0; //null;
        kby = 0; //null;
        kcx = 0; //null; 
        kcy = 0; //null;
        nax = 0; //null;
        nay = 0; //null;
        nbx = 0; //null;
        nby = 0; //null;
        ncx = 0; //null;
        ncy = 0; //null;
        ax = 0; //null;
        ay = 0; //null;
        bx = 0; //null;
        by = 0; //null;
        cx = 0; //null;
        cy = 0; //null;
        
        dx = null;
        dy = null;
        ex = null;
        ey = null;
        
        /*fx = null;
        fy = null;
        gx = null;
        gy = null;*/
        #if ( haxe_ver < "4.0.0" )
            pointsClock = [];
            pointsAnti = [];
        #else
            pointsClock.resize( 0 );
            pointsAnti.resize( 0 );
        #end
    }
    //TODO: create lower limit for width   0.00001; ?
    public var count = 0;
    public function new( triArr_: TrilateralArray, endLine_: EndLineCurve = no ){
        triArr = triArr_;
        endLine = endLine_;
    }
    public inline
    function triangleJoin( ax_: Float, ay_: Float, bx_: Float, by_: Float, width_: Float, curveEnds: Bool = false, overlap: Bool = false ){
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
            
            if( count == 0 && ( endLine == begin || endLine == both ) ) addPieXstart( ax, ay, width_/2, -angle1 - Math.PI/2, -angle1 - Math.PI/2 + Math.PI, SMALL );
            /*
            if( curveEnds ){
                //joinArc
                if( clockWise ){
                    addArray( Poly.pieDifX( ax_, ay_, width_/2, theta0, dif, pointsClock ) );
                } else {
                    addArray( Poly.pieDifX( ax_, ay_, width_/2, theta0, dif, pointsAnti ) );
                }
            } else {
            // straight line between lines    
                if( count != 0 ){
                    if( overlap ){ // just draw down to a as overlapping quads
                        connectQuadsWhenQuadsOverlay( clockWise, width_ );
                    } else {
                        connectQuads( clockWise, width_ );
                    }
                }
            }
            */
            if( overlap ){
                overlapQuad(); // not normal
            }else {
                if( count != 0 ) addQuads( clockWise, width_ );
                addInitialQuads( clockWise, width_ );
            }
            
            if( curveEnds ){
                //joinArc
                if( clockWise ){
                    addArray( Poly.pieDifX( ax_, ay_, width_/2, theta0, dif, pointsClock ) );
                } else {
                    addArray( Poly.pieDifX( ax_, ay_, width_/2, theta0, dif, pointsAnti ) );
                }
            } else {
            // straight line between lines    
                if( count != 0 ){
                    if( overlap ){ // just draw down to a as overlapping quads
                        connectQuadsWhenQuadsOverlay( clockWise, width_ );
                    } else {
                        connectQuads( clockWise, width_ );
                    }
                }
            }
            
            
            storeLastQuads();
            
            
        if( curveEnds && !overlap && count != 0 ) addSmallTriangles( clockWise, width_ );
        #if trilateral_includeSegments
        #if trilateral_debugNumbers
            addNumbering( jx, jy, counter, width_ );
            counter++;
        #end
        #end
        
        
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
        endEdges();
        if( count != 0 ) addPieX( bx, by, width_/2, -angle1 - Math.PI/2, -angle1 - Math.PI/2 - Math.PI, SMALL );
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
    function addTri( ax_: Float, ay_: Float, bx_: Float, by_: Float, cx_: Float, cy_: Float, mark_: Int = 0 ){
        triArr.add( new Trilateral( ax_, ay_, bx_, by_, cx_, cy_, mark_ ) );
    }
    inline
    function addPieXstart( ax: Float, ay: Float, radius: Float, beta: Float, gamma: Float, prefer: DifferencePreference, ?mark: Int = 0, ?sides: Int = 36 ){
        var temp = new Array<Float>();
        triArr.addArray( Poly.pieX( ax, ay, radius, beta, gamma, prefer, temp, mark, sides ) );
        var pA = pointsAnti.length;
        var len = Std.int( temp.length/2 );
        var p4 = Std.int( temp.length/4 );
        for( i in 0...p4 ){
            pointsAnti[ pA++ ] = temp[ len - 2*i + 1];
            pointsAnti[ pA++ ] = temp[ len - 2*i ];
        }
        var pC = pointsClock.length;
        for( i in 0...p4 ){
            pointsClock[ pC++ ] = temp[ i*2 + len + 1];
            pointsClock[ pC++ ] = temp[ i*2 + len ];
        }
    }
    
    inline
    function addPieX( ax: Float, ay: Float, radius: Float, beta: Float, gamma: Float, prefer: DifferencePreference, ?mark: Int = 0, ?sides: Int = 36 ){
        var temp = new Array<Float>();
        triArr.addArray( Poly.pieX( ax, ay, radius, beta, gamma, prefer, temp, mark, sides ) );
        var pA = pointsAnti.length;
        var len = Std.int( temp.length/2 );
        for( i in 0...len + 2 ){
            pointsAnti[ pA++ ] = temp[ i ];
        }
        var pC = pointsClock.length;
        for( i in 1...Std.int( len/2 + 1 ) ){
            pointsClock[ pC++ ] = temp[ temp.length - 2*i ];
            pointsClock[ pC++ ] = temp[ temp.length - 2*i - 1 ];
        }
    }
    
    inline
    function addPie( ax: Float, ay: Float, radius: Float, beta: Float, gamma: Float, prefer: DifferencePreference, ?mark: Int = 0, ?sides: Int = 36 ){
        triArr.addArray( Poly.pie( ax, ay, radius, beta, gamma, prefer, mark, sides ) );
    }
    inline
    function computeJ( width_: Float, theta0: Float, dif: Float ){
        var gamma = Math.abs( dif )/2;
        var h = ( width_/2 )/Math.cos( gamma );
        var start: Pi2pi = theta0;
        var start2: Float = start;
        var delta = start2 + dif/2 + Math.PI;
        jx = ax + h * Math.sin( delta );
        jy = ay + h * Math.cos( delta );
    }
    inline 
    function addDot( x: Float, y: Float, color: Int, width_: Float ){
        var w = width_ * smallDotScale;
        addArray( Poly.circleMarked( x, y, w, color ) );
    }
    #if trilateral_debug
    inline
    function addDebugLine( x0: Float, y0: Float, x1: Float, y1: Float, width_: Float, col: Int, colStart: Int = 1 ){
        var w = width_*smallDotScale/2;
        var dx = (x1 - x0);
        var dy = (y1 - y0);
        var len = Std.int( Math.min( 100, Math.max( dx, dy ) ) );
        dx = dx/len;
        dy = dy/len;
        for( i in 0...len ){
            if( i < 5 ){
                addArray( Poly.circleMarked( x0 + dx*i, y0 + dy*i, w*2, colStart ) );
            } else {
                addArray( Poly.circleMarked( x0 + dx*i, y0 + dy*i, w, col ) );
            }
        }
    }
    #end
    inline
    function addSmallTriangles( clockWise: Bool, width_: Float ){
        if( clockWise ){
            addTri( ax, ay, dxOld,  dyOld,  jx, jy #if trilateral_debug ,1 #end );
            addTri( ax, ay, exPrev, eyPrev, jx, jy #if trilateral_debug ,3 #end );
            #if trilateral_debugPoints addTriangleCorners( dxOld, dyOld, exPrev, eyPrev, width_ ); #end
        } else {
            addTri( ax, ay, exOld, eyOld, jx, jy #if trilateral_debug ,1 #end );
            addTri( ax, ay, dxPrev, dyPrev, jx, jy #if trilateral_debug ,3 #end );
            #if trilateral_debugPoints addTriangleCorners( exOld, eyOld, dxPrev, dyPrev, width_ ); #end
        }
    }
    inline
    function addTriangleCorners( oldx_: Float, oldy_: Float, prevx_: Float, prevy_: Float, width_: Float ){
        var w = width_ * smallDotScale;
        addArray( Poly.circleMarked( oldx_, oldy_, w, 4 ) );
        addArray( Poly.circleMarked( prevx_, prevy_, w, 3 ) );
        addArray( Poly.circleMarked( ax, ay, w, 10 ) );
        addArray( Poly.circleMarked( jx, jy, w, 5 ) );
    }
    inline
    function addTriangleCornersLess( oldx_: Float, oldy_: Float, prevx_: Float, prevy_: Float, width_: Float ){
        var w = width_ * smallDotScale;
        addArray( Poly.circleMarked( oldx_, oldy_, w , 4 ) );
        addArray( Poly.circleMarked( prevx_, prevy_, w, 3 ) );
        addArray( Poly.circleMarked( jx, jy, w, 5 ) );
    }
    // The triangle between quads
    inline
    function connectQuadsWhenQuadsOverlay( clockWise: Bool, width_: Float ){
        if( clockWise ){
            addTri( dxOld, dyOld, exPrev, eyPrev, ax, ay );
            #if trilateral_debugPoints addTriangleCornersLess( dxOld, dyOld, exPrev, eyPrev, width_ ); #end
        } else {
            addTri( exOld, eyOld, dxPrev, dyPrev, ax, ay );
            #if trilateral_debugPoints addTriangleCornersLess( exOld, eyOld, dxPrev, dyPrev, width_ ); #end
        }
    }
    // The triangle between quads
    inline
    function connectQuads( clockWise: Bool, width_: Float ){
        if( clockWise ){
            addTri( dxOld, dyOld, exPrev, eyPrev, jx, jy );
            #if trilateral_debugPoints addTriangleCornersLess( dxOld, dyOld, exPrev, eyPrev, width_ ); #end
        } else {
            addTri( exOld, eyOld, dxPrev, dyPrev, jx, jy );
            #if trilateral_debugPoints addTriangleCornersLess( exOld, eyOld, dxPrev, dyPrev, width_ ); #end
        }
    }
    // these are Quads that don't use the second inner connection so they overlap at the end
    // draw these first and replace them?
    inline 
    function addInitialQuads( clockWise: Bool, width_: Float ){
        //These get replaced as drawing only to leave the last one
        quadIndex = triArr.length;
        if( count == 0 ){ // first line
            penultimateAX = dxPrev;
            penultimateAY = dyPrev;
            lastAntiX     = ex;
            lastAntiY     = ey; 
            penultimateCX = dx;
            penultimateCY = dy;
            lastClockX    = exPrev;
            lastClockY    = eyPrev;
            addTri( dxPrev, dyPrev, dx, dy, ex, ey #if trilateral_debug ,8 #end );
            addTri( dxPrev, dyPrev, dx, dy, exPrev, eyPrev #if trilateral_debug ,12 #end );
        } else {
            if( clockWise && !lastClock ){
                penultimateAX = jx;
                penultimateAY = jy;
                lastAntiX     = ex;
                lastAntiY     = ey;
                penultimateCX = dx;
                penultimateCY = dy;
                lastClockX    = exPrev;
                lastClockY    = eyPrev;
                // FIXED
                addTri( jx, jy, dx, dy, ex, ey #if trilateral_debug ,8 #end );
                addTri( jx, jy, dx, dy, exPrev, eyPrev #if trilateral_debug ,12 #end );
            }
            if( clockWise && lastClock ){
                penultimateAX = jx;
                penultimateAY = jy;
                lastAntiX     = ex;
                lastAntiY     = ey;
                penultimateCX = dx;
                penultimateCY = dy;
                lastClockX    = exPrev;
                lastClockY    = eyPrev;
                // FIXED 
                addTri( jx, jy, dx, dy, ex, ey #if trilateral_debug ,8 #end );
                addTri( jx, jy, dx, dy, exPrev, eyPrev #if trilateral_debug ,12 #end );
            }
            if( !clockWise && !lastClock ){
                penultimateCX = dx;
                penultimateCY = dy;
                lastClockX    = jx;
                lastClockY    = jy;
                penultimateAX = dxPrev;
                penultimateAY = dyPrev;
                lastAntiX     = ex;
                lastAntiY     = ey;
                // FIXED 
                addTri( dxPrev, dyPrev, dx, dy, jx, jy #if trilateral_debug ,8 #end );
                addTri( dxPrev, dyPrev, dx, dy, ex, ey #if trilateral_debug ,12 #end );
            }
            if( !clockWise && lastClock ){                
                penultimateAX = dxPrev;
                penultimateAY = dyPrev;
                lastAntiX     = ex;
                lastAntiY     = ey;
                
                penultimateCX = jx;
                penultimateCY = jy;
                lastClockX    = dx;
                lastClockY    = dy;
                
                addTri( jx, jy, dx, dy, ex, ey #if trilateral_debug ,8 #end );
                addTri( dxPrev, dyPrev, jx, jy, ex, ey #if trilateral_debug ,12 #end );
            }
        }
    }
    
    public function endEdges(){
        var pC = pointsClock.length;
        var pA = pointsAnti.length;
        pointsClock[ pC++ ] = penultimateCX;
        pointsClock[ pC++ ] = penultimateCY;
        pointsClock[ pC++ ] = lastClockX;
        pointsClock[ pC++ ] = lastClockY;
        pointsAnti[  pA++ ] = penultimateAX;
        pointsAnti[  pA++ ] = penultimateAY;
        pointsAnti[  pA++ ] = lastAntiX;
        pointsAnti[  pA++ ] = lastAntiY; 
    }
    
    #if trilateral_includeSegments
    inline
    function addNumbering( x0: Float, y0: Float, num: Int, width_: Float ){
        var w = width_*smallDotScale*4;
        var seven = new SevenSeg( w, (12/8)*w );
        seven.addNumber( num, x0 - width_/3, y0 );
        addArray( seven.triArr );
    }
    #end
    var counter = 0;
    // replace the section quads with quads with both inner points
    // inline 
    function addQuads( clockWise: Bool, width_: Float ){
        //return;
        // 7 = clock side
        // 6 = antiClock side
        var pC = 0;
        var pA = 0;
        if( clockWise && !lastClock ){
            if( count == 1 ){ // deals with first case
                pA = pointsAnti.length;//6
                pointsAnti[ pA++ ] = kax;
                pointsAnti[ pA++ ] = kay;
                pointsAnti[ pA++ ] = jx;
                pointsAnti[ pA++ ] = jy;
                pC = pointsClock.length;//7
                pointsClock[ pC++ ] = nbx;
                pointsClock[ pC++ ] = nby;
                pointsClock[ pC++ ] = ncx;
                pointsClock[ pC++ ] = ncy; 
                triArr[ quadIndex + 1 ] = new Trilateral( nax, nay, nbx, nby, ncx, ncy #if trilateral_debug ,7 #end );
                // untested
                // addDebugLine( nbx, nby, ncx, ncy, width_, 3 ); 
            } else {
                pA = pointsAnti.length;//6
                pointsAnti[ pA++ ] = kax;
                pointsAnti[ pA++ ] = kay;
                pointsAnti[ pA++ ] = jx;
                pointsAnti[ pA++ ] = jy;
                pC = pointsClock.length;//7
                pointsClock[ pC++ ] = jxOld;
                pointsClock[ pC++ ] = jyOld;
                pointsClock[ pC++ ] = nbx;
                pointsClock[ pC++ ] = nby;
                triArr[ quadIndex + 1 ] = new Trilateral( nax, nay, nbx, nby, jxOld, jyOld #if trilateral_debug ,7 #end );
                //addDebugLine( nbx, nby,jxOld, jyOld, width_, 3 );
                //addDebugLine( jxOld, jyOld, nbx, nby, width_, 3 );
            }
            triArr[ quadIndex ] = new Trilateral( kax, kay, kbx, kby, jx, jy #if trilateral_debug ,6 #end );
            //addDebugLine( jx, jy, kax, kay, width_, 4 );
            //addDebugLine( kax, kay, jx, jy, width_, 4 );
        }
        if( clockWise && lastClock ){
            if( count == 1 ){
                // to check
                pA = pointsAnti.length;//6
                pointsAnti[ pA++ ] = jx;
                pointsAnti[ pA++ ] = jy;
                pointsAnti[ pA++ ] = kbx;
                pointsAnti[ pA++ ] = kby;
                pC = pointsClock.length;//7
                pointsClock[ pC++ ] = nax;
                pointsClock[ pC++ ] = nay;
                pointsClock[ pC++ ] = nbx;
                pointsClock[ pC++ ] = nby;
                triArr[ quadIndex ] = new Trilateral( kax, kay, kbx, kby, jx, jy #if trilateral_debug ,6 #end );
                // addDebugLine( kbx, kby, jx, jy, width_, 4 ); //NOT USED STILL TO TEST
                triArr[ quadIndex + 1 ] = new Trilateral( nax, nay, nbx, nby, ncx, ncy #if trilateral_debug ,7 #end );
            } else {
                pA = pointsAnti.length;//6
                pointsAnti[ pA++ ] = jxOld;
                pointsAnti[ pA++ ] = jyOld;
                pointsAnti[ pA++ ] = jx;
                pointsAnti[ pA++ ] = jy;
                pC = pointsClock.length;//7
                pointsClock[ pC++ ] = ncx;
                pointsClock[ pC++ ] = ncy;
                pointsClock[ pC++ ] = nbx;
                pointsClock[ pC++ ] = nby;
                triArr[ quadIndex ] = new Trilateral( jxOld, jyOld, kbx, kby, jx, jy #if trilateral_debug ,6 #end );
                // used reverse 3,4kax, kay,
                //addDebugLine( jx, jy, jxOld, jyOld, width_, 4 );
                triArr[ quadIndex + 1 ] = new Trilateral( jxOld, jyOld, nbx, nby, ncx, ncy #if trilateral_debug ,7 #end );
                // used reverse 3,4,5 ... does not go right in other direction
                //addDebugLine( nbx, nby, ncx, ncy , width_, 3 );
            }
        }
        
        if( !clockWise && !lastClock ){
            triArr[ quadIndex ] = new Trilateral( kax, kay, jx, jy, kcx, kcy #if trilateral_debug ,6 #end );
            // used 1,2,3 reverse 1, 2  correct :)
            //addDebugLine( kax, kay, kcx, kcy, width_, 4 );
            if( count == 1 ){
                pA = pointsAnti.length;//6
                pointsAnti[ pA++ ] = kax;
                pointsAnti[ pA++ ] = kay;
                pointsAnti[ pA++ ] = kcx;
                pointsAnti[ pA++ ] = kcy;
                pC = pointsClock.length;//7
                pointsClock[ pC++ ] = ncx;
                pointsClock[ pC++ ] = ncy;
                pointsClock[ pC++ ] = jx;
                pointsClock[ pC++ ] = jy;
                triArr[ quadIndex + 1 ] = new Trilateral( nax, nay, jx, jy, ncx, ncy #if trilateral_debug ,7 #end );
                //addDebugLine( ncx, ncy, jx, jy, width_, 3 );
            } else {
                pA = pointsAnti.length;//6
                pointsAnti[ pA++ ] = kax;
                pointsAnti[ pA++ ] = kay;
                pointsAnti[ pA++ ] = kcx;
                pointsAnti[ pA++ ] = kcy;
                pC = pointsClock.length;//7
                pointsClock[ pC++ ] = jxOld;
                pointsClock[ pC++ ] = jyOld;
                pointsClock[ pC++ ] = jx;
                pointsClock[ pC++ ] = jy;
                triArr[ quadIndex + 1 ] = new Trilateral( nax, nay, jx, jy, jxOld, jyOld #if trilateral_debug ,7 #end );
                //addDebugLine( jxOld, jyOld, jx, jy, width_, 3 );
            }
        }
        // NO IDEA IF THIS ONE WORKS!!!
        if( !clockWise && lastClock ){
            if( count == 1 ){
                pA = pointsAnti.length;//6
                pointsAnti[ pA++ ] = kay;
                pointsAnti[ pA++ ] = kax;
                pointsAnti[ pA++ ] = kcx;
                pointsAnti[ pA++ ] = kcy;
                pC = pointsClock.length;//7
                pointsClock[ pC++ ] = jx;
                pointsClock[ pC++ ] = jy;
                pointsClock[ pC++ ] = ncx;
                pointsClock[ pC++ ] = ncy;
                triArr[ quadIndex ] = new Trilateral( kax, kay, jx, jy, kcx, kcy #if trilateral_debug ,6 #end );
                triArr[ quadIndex + 1 ] = new Trilateral( nax, nay, jx, jy, ncx, ncy #if trilateral_debug ,7 #end );
            } else {
                pA = pointsAnti.length;//6
                pointsAnti[ pA++ ] = jxOld;
                pointsAnti[ pA++ ] = jyOld;
                pointsAnti[ pA++ ] = kcx;
                pointsAnti[ pA++ ] = kcy;
                pC = pointsClock.length;//7
                pointsClock[ pC++ ] = jx;
                pointsClock[ pC++ ] = jy;
                pointsClock[ pC++ ] = ncx;
                pointsClock[ pC++ ] = ncy;
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
    function line( ax_: Float, ay_: Float, bx_: Float, by_: Float, width_: Float, ?endLineCurve: EndLineCurve = no ){
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
            case EndLineCurve.no: 
                // don't draw ends
            case EndLineCurve.begin: 
                addPie( ax_, ay_, width_/2, -angle1 - Math.PI/2, -angle1 - Math.PI/2 + Math.PI, SMALL );
            case EndLineCurve.end:
                addPie( bx_, by_, width_/2, -angle1 - Math.PI/2, -angle1 - Math.PI/2 - Math.PI, SMALL );
            case EndLineCurve.both:
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