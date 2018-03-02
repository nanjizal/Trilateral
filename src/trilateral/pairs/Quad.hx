package trilateral.pairs;
import trilateral.geom.Algebra;
import trilateral.geom.Point;
import trilateral.tri.Trilateral;
// defines a Rectangle without a colour.
class Quad {
    // TODO: add support for rotated rectangle
    public inline static
    function rectangle( pos: Point, dim: Point ): TrilateralPair {
        var ax = pos.x;
        var ay = pos.y;
        var lx = dim.x;
        var ly = dim.y;
        var bx = ax + lx;
        var by = ay;
        var cx = bx;
        var cy = ay + ly;
        var dx = ax;
        var dy = cy;
        return { t0: new Trilateral( ax, ay, bx, by, dx, dy )
            ,    t1: new Trilateral( bx, by, cx, cy, dx, dy ) };
    }
    //    a  b
    //    d  c
    public static inline
    function square( pos: Point, radius: Float, ?theta: Float = 0 ): TrilateralPair {
        var ax = 0.;
        var ay = 0.;
        var bx = 0.;
        var by = 0.;
        var cx = 0.;
        var cy = 0.;
        var dx = 0.;
        var dy = 0.;
        if( theta != 0 ){
            var pi = Math.PI;
            var pi4 = pi/4;
            var pi2 = pi/2;
            var sqrt2 = Math.sqrt( 2 );
            var r = radius*sqrt2;
            var px = pos.x;
            var py = pos.y;
            //    a
            // d     b
            //    c
            var aTheta = -pi + theta - pi4;
            var dTheta = -pi + theta + pi/2 - pi/4;
            var cTheta = theta - pi4;
            var bTheta = -pi + theta - pi2 - pi4;
            ax = px + r * Math.sin( aTheta );
            ay = py + r * Math.cos( aTheta );
            bx = px + r * Math.sin( bTheta );
            by = py + r * Math.cos( bTheta );
            cx = px + r * Math.sin( cTheta );
            cy = py + r * Math.cos( cTheta );
            dx = px + r * Math.sin( dTheta);
            dy = py + r * Math.cos( dTheta );
        } else {
            ax = pos.x - radius;
            ay = pos.y - radius;
            var lx = radius*2;
            var ly = lx;
            bx = ax + lx;
            by = ay;
            cx = bx;
            cy = ay + ly;
            dx = ax;
            dy = cy;
        }
        return { t0: new Trilateral( ax, ay, bx, by, dx, dy )
            ,    t1: new Trilateral( bx, by, cx, cy, dx, dy ) };
    }
    public static inline 
    function diamond( pos: Point, radius: Float, ?theta: Float = 0 ): TrilateralPair {
        return square( pos, radius, Math.PI/4 + theta );
    }
}