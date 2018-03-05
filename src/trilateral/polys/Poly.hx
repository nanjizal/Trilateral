package trilateral.polys;
import trilateral.tri.Trilateral;
import trilateral.tri.TrilateralArray;
import trilateral.geom.Algebra;
import trilateral.geom.Point;
import fracs.Angles;
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
    function circle( pos: Point, radius: Float, ?sides: Int = 36 ): TrilateralArray {
        var out = new TrilateralArray();
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
            out.add( new Trilateral( ax, ay, bx, by, cx, cy ) );
        }
        return out;
    }
    /**
     * When calling Pie you can specify the DifferencePreference of what should be colored in terms of the two angles provided.
     * For example for drawing a packman shape you would want the use DifferencePreference.LARGE .
     **/
    public static inline
    function pie( ax: Float, ay: Float, radius: Float, beta: Float, gamma: Float, prefer: DifferencePreference, ?mark: Bool = false, ?sides: Int = 36 ): TrilateralArray {
        // choose a step size based on smoothness ie number of sides expected for a circle
        var out = new TrilateralArray();
        var pi = Math.PI;
        var step = pi*2/sides;
        var dif = Angles.differencePrefer( beta, gamma, prefer );
        var positive = ( dif >= 0 );
        var totalSteps = Math.ceil( Math.abs( dif )/step );
        // adjust step with smaller value to fit the angle drawn.
        var step = dif/totalSteps;
        trace( 'step ' + step + ' ' + totalSteps );
        var angle: Float = beta;
        var cx: Float;
        var cy: Float;
        var bx: Float = 0;
        var by: Float = 0;
        for( i in 0...totalSteps+1 ){
            cx = ax + radius*Math.sin( angle );
            cy = ay + radius*Math.cos( angle );
            if( i != 0 ){ // start on second iteration after b is populated.
                //var t = ( positive )? new Trilateral( ax, ay, bx, by, cx, cy ): new Trilateral( ax, ay, cx, cy, bx, by );
                var t = new Trilateral( ax, ay, bx, by, cx, cy ); // don't need to reorder corners and Trilateral can do that!
                out.add( t );
                //if( i == 1 ) t.mark = true;
                if( mark ) t.mark = true;
            }
            angle = angle + step;
            bx = cx;
            by = cy;
        }
        return out;
    }
    // useful for debugging
    public static inline
    function circleMarked( pos: Point, radius: Float, ?sides: Int = 36 ): TrilateralArray {
        var out = new TrilateralArray();
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
            var t = new Trilateral( ax, ay, bx, by, cx, cy );
            out.add( t );
            t.mark = true;
        }
        return out;
    }
    public static inline
    function circleOnSide( pos: Point, radius: Float, ?sides: Int = 36 ): TrilateralArray {
        var out = new TrilateralArray();
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
            out.add( new Trilateral( ax, ay, bx, by, cx, cy ) );
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