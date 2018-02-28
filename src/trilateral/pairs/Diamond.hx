package trilateral.pairs;
import trilateral.Algebra;
import trilateral.Trilateral;
// use two triangles to create a quick diamond ( square on side ), lighter than say a circle for denoting a point.
class Diamond{
    public inline static
    function create( pos: Point, radius: Float, ?theta: Float = 0 ): TrilateralPair {
        var sin: Float;
        var cos: Float;
        var pi = Math.PI;
        // a
        //    b
        // c
        var omega: Float = -pi + theta;
        var a0x: Float = pos.x + radius * Math.sin( omega );
        var a0y: Float = pos.y + radius * Math.cos( omega );
        omega += pi/2;
        var b0x: Float = pos.x + radius * Math.sin( omega );
        var b0y: Float = pos.y + radius * Math.cos( omega );
        omega += pi/2;
        var c0x: Float = pos.x + radius * Math.sin( omega );
        var c0y: Float = pos.y + radius * Math.cos( omega );
        //    a
        //  c
        //    b
        omega = -pi + theta;
        var a1x: Float = pos.x + radius * Math.sin( omega );
        var a1y: Float = pos.y + radius * Math.cos( omega );
        omega -= pi/2;// divide by 2 not sure if right?
        var b1x: Float = pos.x + radius * Math.sin( omega );
        var b1y: Float = pos.y + radius * Math.cos( omega );
        omega -= pi/2;
        var c1x: Float = pos.x + radius * Math.sin( omega );
        var c1y: Float = pos.y + radius * Math.cos( omega );
        
        return { t0: new Trilateral( a0x, a0y, b0x, b0y, c0x, c0y ), t1: new Trilateral( a1x, a1y, b1x, b1y, c1x, c1y ) };
    }
}