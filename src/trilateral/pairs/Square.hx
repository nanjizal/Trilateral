package trilateral.pairs;
import trilateral.Algebra;
import trilateral.Trilateral;
// use two triangles to create a quick square, lighter than say a circle for denoting a point ( centred unlike rectangle )
class Square{
    public inline static
    function create( pos: Point, radius: Float ): TrilateralPair {
        var ax = pos.x - radius;
        var ay = pos.y - radius;
        var lx = radius*2;
        var ly = lx;
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