package trilateral.polys;
@:enum
abstract PolySides( Int ) from Int to Int {
    var triangle        = 3;
    var quadrilateral   = 4;
    var square          = 4;
    var tetragon        = 4;
    var pentagon        = 5;
    var hexagon         = 6;
    var heptagon        = 7;
    var septagon        = 7;
    var octagon         = 8;
    var nonagon         = 9;
    var enneagon        = 9;
    var decagon         = 10;
    var hendecagon      = 11;
    var undecagon       = 11;
    var dodecagon       = 12;
    var triskaidecagon  = 13;
    var tetrakaidecagon = 14;
    var pentadecagon    = 15;
    var hexakaidecagon  = 16;
    var heptadecagon    = 17;
    var octakaidecagon  = 18;
    var enneadecagon    = 19;
    var icosagon        = 20;
    var triacontagon    = 30;
    var tetracontagon   = 40;
    var pentacontagon   = 50;
    var hexacontagon    = 60;
    var heptacontagon   = 70;
    var octacontagon    = 80;
    var enneacontagon   = 90;
    var hectagon        = 100;
    var chiliagon       = 1000;
    var myriagon        = 10000;
}
class Poly {
    public static inline
    function circle( pos: Point, radius: Float, ?sides: Int = 36 ): Array<Trilateral> {
        var out = new Array<Trilateral>();
        var pi = Math.PI;
        var theta = pi/2;
        var step = pi*2/sides;
        var ax = pos.x;
        var ay = pos.y;
        var bx: Float;
        var by: Float;
        var cx: Float;
        var cy: Float;
        for( i in 0...sides ){
            bx = ax + radius*Math.sin( theta );
            by = ay + radius*Math.cos( theta );
            theta += step;
            cx = ax + radius*Math.sin( theta );
            cy = ay + radius*Math.cos( theta );
            out[ out.length ] = new Trilateral( ax, ay, bx, by, cx, cy );
        }
        return out;
    }
    public static inline
    function circleOnSide( pos: Point, radius: Float, ?sides: Int = 36 ): Array<Trilateral> {
        var out = new Array<Trilateral>();
        var pi = Math.PI;
        var theta = pi/2;
        var step = pi*2/sides;
        theta -= step/2;
        var ax = pos.x;
        var ay = pos.y;
        var bx: Float;
        var by: Float;
        var cx: Float;
        var cy: Float;
        for( i in 0...sides ){
            bx = ax + radius*Math.sin( theta );
            by = ay + radius*Math.cos( theta );
            theta += step;
            cx = ax + radius*Math.sin( theta );
            cy = ay + radius*Math.cos( theta );
            out[ out.length ] = new Trilateral( ax, ay, bx, by, cx, cy );
        }
        return out;
    }
    public static inline
    function shape( pos: Point, radius: Float, p: PolySides ){
        return if( p & 1 == 0 ){
            circleOnSide( pos, radius, p );
        } else {
            circle( pos, radius, p );
        }
    }
}