package trilateral;
import trilateral.Triangle;
import trilateral.Point;
import trilateral.Trilateral;
typedef QuadPoint = { A: Point, B: Point, C: Point, D: Point };
typedef TrianglePair = { t0: Triangle, t1: Triangle };
typedef TrilateralPair = { t0: Trilateral, t1: Trilateral }
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
}