package trilateral.pairs;
import trilateral.Algebra;
import trilateral.Trilateral;
// defines a Rectangle without a colour.
class Rectangle {
    public inline static
    function create( pos: Point, dim: Point ): TrilateralPair {
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
}