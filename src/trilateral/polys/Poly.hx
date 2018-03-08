package trilateral.polys;
import trilateral.tri.Trilateral;
import trilateral.tri.TrilateralArray;
import trilateral.geom.Algebra;
import trilateral.pairs.Quad;
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
    function circle( ax: Float, ay: Float, radius: Float, ?sides: Int = 36 ): TrilateralArray {
        var out = new TrilateralArray();
        var pi = Math.PI;
        var theta = pi/2;
        var step = pi*2/sides;
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
    function pie( ax: Float, ay: Float, radius: Float, beta: Float, gamma: Float, prefer: DifferencePreference, ?mark: Int = 0, ?sides: Int = 36 ): TrilateralArray {
        // choose a step size based on smoothness ie number of sides expected for a circle
        var out = new TrilateralArray();
        var pi = Math.PI;
        var step = pi*2/sides;
        var dif = Angles.differencePrefer( beta, gamma, prefer );
        var positive = ( dif >= 0 );
        var totalSteps = Math.ceil( Math.abs( dif )/step );
        // adjust step with smaller value to fit the angle drawn.
        var step = dif/totalSteps;
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
                if( mark != 0 ) t.mark = mark;
            }
            angle = angle + step;
            bx = cx;
            by = cy;
        }
        return out;
    }
    /**
     * Optimized Pie used in Contour, with dif pre-calculated
     **/
    public static inline
    function pieDif( ax: Float, ay: Float, radius: Float, beta: Float, dif: Float, ?mark: Int = 0, ?sides: Int = 36 ): TrilateralArray {
        // choose a step size based on smoothness ie number of sides expected for a circle
        var out = new TrilateralArray();
        var pi = Math.PI;
        var step = pi*2/sides;
        var positive = ( dif >= 0 );
        var totalSteps = Math.ceil( Math.abs( dif )/step );
        // adjust step with smaller value to fit the angle drawn.
        var step = dif/totalSteps;
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
                if( mark != 0 ) t.mark = mark;
            }
            angle = angle + step;
            bx = cx;
            by = cy;
        }
        return out;
    }
    public static inline
    function arc( ax: Float, ay: Float, radius: Float, width: Float, beta: Float, gamma: Float, prefer: DifferencePreference, ?mark: Int = 0, ?sides: Int = 36 ): TrilateralArray {
        // choose a step size based on smoothness ie number of sides expected for a circle
        var out = new TrilateralArray();
        var pi = Math.PI;
        var step = pi*2/sides;
        var dif = Angles.differencePrefer( beta, gamma, prefer );
        var positive = ( dif >= 0 );
        var totalSteps = Math.ceil( Math.abs( dif )/step );
        // adjust step with smaller value to fit the angle drawn.
        var step = dif/totalSteps;
        var angle: Float = beta;
        var cx: Float;
        var cy: Float;
        var bx: Float = 0;
        var by: Float = 0;
        var dx: Float = 0;
        var dy: Float = 0;
        var ex: Float = 0;
        var ey: Float = 0;
        var r2 = radius - width;
        for( i in 0...totalSteps+1 ){
            cx = ax + radius*Math.sin( angle );
            cy = ay + radius*Math.cos( angle );
            ex = ax + r2*Math.sin( angle );
            ey = ay + r2*Math.cos( angle );
            if( i != 0 ){ // start on second iteration after b and d are populated.
                var t0 = new Trilateral( dx, dy, bx, by, cx, cy );
                var t1 = new Trilateral( dx, dy, cx, cy, ex, ey );
                out.add( t0 );
                out.add( t1 );
                if( mark != 0 ) {
                    t0.mark = mark;
                    t1.mark = mark;
                }
            }
            angle = angle + step;
            bx = cx;
            by = cy;
            dx = ex;
            dy = ey;
        }
        return out;
    }
    // useful for debugging
    public static inline
    function circleMarked( ax: Float, ay: Float, radius: Float, mark: Int, ?sides: Int = 36 ): TrilateralArray {
        var out = new TrilateralArray();
        var pi = Math.PI;
        var theta = pi/2;
        var step = pi*2/sides;
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
            t.mark = mark;
        }
        return out;
    }
    public static inline
    function circleOnSide( ax: Float, ay: Float, radius: Float, ?sides: Int = 36 ): TrilateralArray {
        var out = new TrilateralArray();
        var pi = Math.PI;
        var theta = pi/2;
        var step = pi*2/sides;
        theta -= step/2;
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
    function shape( x: Float, y: Float, radius: Float, p: PolySides ){
        return if( p & 1 == 0 ){
            circleOnSide( x, y, radius, p );
        } else {
            circle( x, y, radius, p );
        }
    }
    public static inline
    function roundedRectangle( x: Float, y: Float, width: Float, height: Float, radius: Float ): TrilateralArray {
        var out = new TrilateralArray();
        // zero = down
        // clockwise seems to be wrong way round !
        // Needs fixing in Contour so can't change yet!
        // so all the angles are currently wrong!!
        var pi = Math.PI;
        var pi_2 = Math.PI/2;
        var ax = x + radius;
        var ay = y + radius;
        var bx = x + width - radius;
        var by = y + radius;
        var cx = bx;
        var cy = y + height - radius;
        var dx = ax;
        var dy = cy;
        out.addPair( Quad.rectangle( ax, y, width - radius*2, height ) );
        var dimY = height - 2*radius;
        out.addPair( Quad.rectangle( x,  ay, radius, dimY ) );
        out.addPair( Quad.rectangle( bx, by, radius, dimY ) );
        out.addArray( pie( ax, ay, radius, -pi, -pi_2, CLOCKWISE ) );
        out.addArray( pie( bx, by, radius, pi_2, pi,   CLOCKWISE ) );
        out.addArray( pie( cx, cy, radius, pi_2, 0, ANTICLOCKWISE ) );
        out.addArray( pie( dx, dy, radius, 0, -pi_2,ANTICLOCKWISE ) );
        return out;
    }
    public static inline
    function roundedRectangleOutline( x: Float, y: Float, width: Float, height: Float, thick: Float, radius: Float ): TrilateralArray {
        var out = new TrilateralArray();
        // zero = down
        // clockwise seems to be wrong way round !
        // Needs fixing in Contour so can't change yet!
        // so all the angles are currently wrong!!
        var pi = Math.PI;
        var pi_2 = Math.PI/2;
        var ax = x + radius;
        var ay = y + radius;
        var bx = x + width - radius;
        var by = y + radius;
        var cx = bx;
        var cy = y + height - radius;
        var dx = ax;
        var dy = cy;
        out.addPair( Quad.rectangle( ax, y, width - radius*2, thick ) );
        out.addPair( Quad.rectangle( ax, y + height - thick, width - radius*2, thick ) );
        var dimY = height - 2*radius;
        out.addPair( Quad.rectangle( x,  ay, thick, dimY ) );
        out.addPair( Quad.rectangle( x + width - thick, by, thick, dimY ) );
        out.addArray( arc( ax, ay, radius, thick, -pi, -pi_2, CLOCKWISE ) );
        out.addArray( arc( bx, by, radius, thick, pi_2, pi,   CLOCKWISE ) );
        out.addArray( arc( cx, cy, radius, thick, pi_2, 0, ANTICLOCKWISE ) );
        out.addArray( arc( dx, dy, radius, thick, 0, -pi_2,ANTICLOCKWISE ) );
        return out;
    }
}