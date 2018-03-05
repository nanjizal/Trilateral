package trilateral.geom;
import trilateral.tri.Triangle;
import trilateral.geom.Point;
import trilateral.tri.Trilateral;
import trilateral.tri.TrilateralPair;
import fracs.Fraction;
import fracs.Pi2pi;
typedef QuadPoint = { A: Point, B: Point, C: Point, D: Point };
class Algebra {
    public inline static
    function theta( p0: Point, p1: Point ): Float {
        var dx: Float = p0.x - p1.x;
        var dy: Float = p0.y - p1.y;
        return Math.atan2( dy, dx );
    }
    public static inline
    function dist( p0: Point, p1: Point  ): Float {
        var dx: Float = p0.x - p1.x;
        var dy: Float = p0.y - p1.y;
        return dx*dx + dy*dy;
    }
    // A B C, you can find the winding by computing the cross product (B - A) x (C - A)
    public static inline
    function adjustWinding( A_: Point, B_: Point, C_: Point ): Bool{
        var val: Bool = !( cross( subtract( B_, A_ ), subtract( C_, A_ ) ) < 0 );
        return val;
    }
    // subtract
    public static inline
    function subtract( p0: Point, p1: Point ) : Point {
        return { x: p0.x - p1.x, y: p0.y - p1.y };
    }
    // to get the cross product
    public static inline
    function cross( p0: Point, p1: Point ) : Float {
        return p0.x*p1.y - p0.y*p1.x;
    }
    public static inline
    function sign( n: Float ): Int {
        return Std.int( Math.abs( n )/n );
    }
    //Bezier
    public static inline
    function quadratic ( t: Float, s: Float, c: Float, e: Float ): Float {
        var u = 1 - t;
        return Math.pow( u, 2 )*s + 2*u*t*c + Math.pow( t, 2 )*e;
    }
    public static inline
    function cubic( t: Float, s: Float, c1: Float, c2: Float, e: Float ): Float {
        var u = 1 - t;
        return  Math.pow( u, 3 )*s + 3*Math.pow( u, 2 )*t*c1 + 3*u*Math.pow( t, 2 )*c2 + Math.pow( t, 3 )*e;
    }
    public static
    var quadStep: Float = 0.03;
    // Create Quadratic Curve
    public static inline
    function quadCurve( p: Array<Float>, ax: Float, ay: Float, bx: Float, by: Float, cx: Float, cy: Float ): Array<Float> {
        var step = calculateQuadStep( ax, ay, bx, by, cx, cy );
        var l = p.length;
        p[ l++ ] = ax;
        p[ l++ ] = ay;
        var t = step;
        while( t < 1. ){
            p[ l++ ] = quadratic( t, ax, bx, cx );
            p[ l++ ] = quadratic( t, ay, by, cy );
            t += step;
        }
        p[ l++ ] =  cx;
        p[ l++ ] =  cy;
        return p;
    }
    public static
    var cubicStep: Float = 0.03;
    // Create Cubic Curve
    public static inline 
    function cubicCurve( p: Array<Float>, ax: Float, ay: Float, bx: Float, by: Float, cx: Float, cy: Float, dx: Float, dy: Float ): Array<Float> {
        var step = calculateCubicStep( ax, ay, bx, by, cx, cy, dx, dy );
        var l = p.length;
        p[ l++ ] = ax;
        p[ l++ ] = ay;
        var t = step;
        while( t < 1. ){
            p[ l++ ] = cubic( t, ax, bx, cx, dx );
            p[ l++ ] = cubic( t, ay, by, cy, dy );
            t += step;
        }
        p[ l++ ] =  dx;
        p[ l++ ] =  dy;
        return p;
    }
    public static inline
    function calculateQuadStep( ax: Float, ay: Float, bx: Float, by: Float, cx: Float, cy: Float ): Float {
        var approxDistance = distance( ax, ay, bx, by ) + distance( bx, by, cx, cy );
        if( approxDistance == 0 ) approxDistance = 0.000001;
        return Math.min( 1/( approxDistance*0.707 ), quadStep );
    }
    public static inline
    function calculateCubicStep( ax: Float, ay: Float, bx: Float, by: Float, cx: Float, cy: Float, dx: Float, dy: Float ): Float {
        var approxDistance = distance( ax, ay, bx, by ) + distance( bx, by, cx, cy ) + distance( cx, cy, dx, dy );
        if( approxDistance == 0 ) approxDistance = 0.000001;
        return Math.min( 1/( approxDistance*0.707 ), cubicStep );
    }
    // Create Arc Points
    public static inline
    function arc_internal( dx: Float, dy: Float, radius: Float, start: Float, dA: Float, sides: Int ): Array<Float> {
        var p = new Array<Float>();         
        var angle: Pi2pi = 0;
        var angleInc: Float = ( Math.PI*2 )/sides;
        var sides = Math.round( sides );
        var nextAngle: Pi2pi;
        var l = 0;
        p[ l++ ] = dy + radius * Math.sin( start );
        p[ l++ ] = dx + radius * Math.cos( start );
        if( dA < 0 ){
            trace( 'dA < 0 ________' + dA );
            var i = -1;
            while( true ){
                angle = i*angleInc;
                var f: Fraction = angle;
                i--;
                nextAngle = angle + start;
                p[ l++ ] = dy + radius * Math.sin( nextAngle );
                p[ l++ ] = dx + radius * Math.cos( nextAngle );
                if( angle < ( dA - angleInc ) ) break; // turn down this is top of turn.
            } 
            p.reverse();
        } else {
            trace( 'dA > 0 ________' + dA );
            var i = -1;
            while( true ){
                angle = i*angleInc;
                var f: Fraction = angle;
                trace( f + 'pi');
                
                i++;
                nextAngle = angle + start; 
                if( angle >=  ( dA ) ) break; 
                
                
                // after so that reverse works..
                p[ l++ ] = dx + radius * Math.cos( nextAngle );
                p[ l++ ] = dy + radius * Math.sin( nextAngle );
                
            }
        }
        return p;
    }
    // may not be most optimal
    public inline static
    function lineAB( A: Point, B: Point, width: Float ){
        var dx: Float = A.x - B.x;
        var dy: Float = A.y - B.y;
        var P = { x:A.x - width/2, y:A.y };
        var omega = thetaCheap( dx, dy ); // may need angle correction.
        var dim: Point = { x: width, y: distCheap( dx, dy ) };
        return rotateVectorLine( P, dim, omega, A.x + width/2, A.y );
    }
    // may not be most optimal
    public inline static
    function lineABCoord( ax: Float, ay: Float, bx: Float, by: Float, width: Float ){
        var dx: Float = ax - bx;
        var dy: Float = ay - by;
        var P = { x:ax - width/2, y:ay };
        var omega = thetaCheap( dx, dy ); // may need angle correction.
        var dim: Point = { x: width, y: distCheap( dx, dy ) };
        return rotateVectorLine( P, dim, omega, ax + width/2, ay );
    }
    
    public inline static
    function rotateVectorLine( pos: Point, dim: Point, omega: Float, pivotX: Float, pivotY: Float ): QuadPoint {
        //   A   B
        //   D   C
        var px = pos.x;
        var py = pos.y;
        var dx = dim.x;
        var dy = dim.y;
        var A_ = { x: px,            y: py };
        var B_ = { x: px + dx,   y: py };
        var C_ = { x: px + dx,   y: py + dy };
        var D_ = { x: px,            y: py + dy };
        if( omega != 0. ){
            var sin = Math.sin( omega );
            var cos = Math.cos( omega );
            A_ = Algebra.pivotCheap( A_, sin, cos, pivotX, pivotY );
            B_ = Algebra.pivotCheap( B_, sin, cos, pivotX, pivotY );
            C_ = Algebra.pivotCheap( C_, sin, cos, pivotX, pivotY );
            D_ = Algebra.pivotCheap( D_, sin, cos, pivotX, pivotY );
        }
        return { A:A_, B:B_, C:C_, D:D_ };
    }
    public inline static
    function pivotCheap( p: Point, sin: Float, cos: Float, pivotX: Float, pivotY: Float ){
        var px = p.x - pivotX;
        var py = p.y - pivotY;
        var px2 = px * cos - py * sin;
        py = py * cos + px * sin;
        return {    x: px2 + pivotX,   y: py + pivotY };
    }
    public inline static // not used?
    function pivot( p: Point, omega: Float, pivotX: Float, pivotY: Float ){
        var px = p.x - pivotX;
        var py = p.y - pivotY;
        var px2 = px * Math.cos( omega ) - py * Math.sin( omega );
        py = py * Math.cos( omega ) + px * Math.sin( omega );
        return {    x: px2 + pivotX,   y: py + pivotY };
    }
    public inline static
    function thetaCheap( dx: Float, dy: Float ): Float {
        return Math.atan2( dy, dx );
    }
    public static inline
    function distCheap( dx: Float, dy: Float  ): Float {
        return dx*dx + dy*dy;
    }
    public static inline
    function distance(  px: Float, py: Float, qx: Float, qy: Float ): Float {
        var x = px - qx;
        var y = py - qy;
        return Math.sqrt( x*x + y*y );
    }
}