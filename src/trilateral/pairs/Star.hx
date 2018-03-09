package trilateral.pairs;
import trilateral.geom.Algebra;
import trilateral.geom.Point;
import trilateral.tri.Trilateral;
import trilateral.tri.TrilateralPair;
// use two overlapping triangles to create a quick star, lighter than say a circle for denoting a point.
class Star{
    public inline static
    function create( px: Float, py: Float, radius: Float, ?theta: Float = 0 ): TrilateralPair {
        var pi = Math.PI;
        var omega: Float = -pi + theta;
        var a0x: Float = px + radius * Math.sin( omega );
        var a0y: Float = py + radius * Math.cos( omega );
        omega += pi/3;
        var a1x: Float = px + radius * Math.sin( omega );
        var a1y: Float = py + radius * Math.cos( omega );
        omega += pi/3;
        var b0x: Float = px + radius * Math.sin( omega );
        var b0y: Float = py + radius * Math.cos( omega );
        omega += pi/3;
        var b1x: Float = px + radius * Math.sin( omega );
        var b1y: Float = py + radius * Math.cos( omega );
        omega += pi/3;
        var c0x: Float = px + radius * Math.sin( omega );
        var c0y: Float = py + radius * Math.cos( omega );
        omega += pi/3;
        var c1x: Float = px + radius * Math.sin( omega );
        var c1y: Float = py + radius * Math.cos( omega );
        return { t0: new Trilateral( a0x, a0y, b0x, b0y, c0x, c0y ), t1: new Trilateral( a1x, a1y, b1x, b1y, c1x, c1y ) };
    }
}