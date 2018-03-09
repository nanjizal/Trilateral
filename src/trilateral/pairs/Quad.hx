package trilateral.pairs;
import trilateral.geom.Algebra;
import trilateral.geom.Point;
import trilateral.tri.Trilateral;
import trilateral.tri.TrilateralPair;
import trilateral.tri.TrilateralArray;
// defines a Rectangle without a colour.
class Quad {
    // TODO: add support for rotated rectangle
    public inline static
    function rectangle( x: Float, y: Float, w: Float, h: Float ): TrilateralPair {
        var ax = x;
        var ay = y;
        var bx = x + w;
        var by = ay;
        var cx = bx;
        var cy = ay + h;
        var dx = x;
        var dy = cy;
        return { t0: new Trilateral( ax, ay, bx, by, dx, dy )
            ,    t1: new Trilateral( bx, by, cx, cy, dx, dy ) };
    }
    //    a  b
    //    d  c
    public static inline
    function squareOutline( px: Float, py: Float, radius: Float, thick: Float, ?theta: Float = 0 ): TrilateralArray {
        var out = new TrilateralArray();
        var ax = 0.;
        var ay = 0.;
        var bx = 0.;
        var by = 0.;
        var cx = 0.;
        var cy = 0.;
        var dx = 0.;
        var dy = 0.;
        var a0x = 0.;
        var a0y = 0.;
        var b0x = 0.;
        var b0y = 0.;
        var c0x = 0.;
        var c0y = 0.;
        var d0x = 0.;
        var d0y = 0.;
        if( theta != 0 ){
            var pi = Math.PI;
            var pi4 = pi/4;
            var pi2 = pi/2;
            var sqrt2 = Math.sqrt( 2 );
            var r = radius*sqrt2;
            //    a
            // d     b
            //    c
            var aTheta = -pi + theta - pi4;
            var dTheta = -pi + theta + pi/2 - pi/4;
            var cTheta = theta - pi4;
            var bTheta = -pi + theta - pi2 - pi4;
            var as = Math.sin( aTheta );
            var ac = Math.cos( aTheta );
            var bs = Math.sin( bTheta );
            var bc = Math.cos( bTheta );
            var cs = Math.sin( cTheta );
            var cc = Math.cos( cTheta );
            var ds = Math.sin( dTheta );
            var dc = Math.cos( dTheta );
            var r0 = r - thick;
            ax = px + r * as;
            ay = py + r * ac;
            bx = px + r * bs;
            by = py + r * bc;
            cx = px + r * cs;
            cy = py + r * cc;
            dx = px + r * ds;
            dy = py + r * dc;
            a0x = px + r0 * as;
            a0y = py + r0 * ac;
            b0x = px + r0 * bs;
            b0y = py + r0 * bc;
            c0x = px + r0 * cs;
            c0y = py + r0 * cc;
            d0x = px + r0 * ds;
            d0y = py + r0 * dc;
        } else {
            ax = px - radius;
            ay = py - radius;
            var lx = radius*2;
            var ly = lx;
            bx = ax + lx;
            by = ay;
            cx = bx;
            cy = ay + ly;
            dx = ax;
            dy = cy;
            var radius0 = radius - thick;
            a0x = px - radius0;
            a0y = py - radius0;
            var l0x = radius0*2;
            var l0y = l0x;
            b0x = a0x + l0x;
            b0y = a0y;
            c0x = b0x;
            c0y = a0y + l0y;
            d0x = a0x;
            d0y = c0y;
        }// top 
        // c bx, b0y
        // d ax, a0y
        out.add( new Trilateral( ax, ay, bx, by, a0x, a0y ) );
        out.add( new Trilateral( bx, by, b0x, b0y, a0x, a0y ) );
        // bottom
        // a dx d0y
        // b cx c0y
        out.add( new Trilateral( d0x, d0y, c0x, c0y, dx, dy ) );
        out.add( new Trilateral( c0x, c0y, cx, cy, dx, dy ) );
        // left
        out.add( new Trilateral( ax, ay, a0x, a0y, d0x, d0y ) );
        out.add( new Trilateral( ax, ay, d0x, d0y, dx, dy ) );
        // right
        out.add( new Trilateral( b0x, b0y, bx, by, c0x, c0y ) );
        out.add( new Trilateral( bx, by, cx, cy, c0x, c0y ) );
        return out;
    }
    //    a  b
    //    d  c
    public static inline
    function square( px: Float, py: Float, radius: Float, ?theta: Float = 0 ): TrilateralPair {
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
            dx = px + r * Math.sin( dTheta );
            dy = py + r * Math.cos( dTheta );
        } else {
            ax = px - radius;
            ay = py - radius;
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
    function diamond( x: Float, y: Float, radius: Float, ?theta: Float = 0 ): TrilateralPair {
        return square( x, y, radius, Math.PI/4 + theta );
    }
    public static inline 
    function diamondOutline( x: Float, y: Float, thick: Float, radius: Float, ?theta: Float = 0 ): TrilateralArray {
        return squareOutline( x, y, radius, thick, Math.PI/4 + theta );
    }
}