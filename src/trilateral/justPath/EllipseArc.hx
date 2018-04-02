package trilateral.justPath;
// http://www.petercollingridge.co.uk/blog/finding-angle-around-ellipse
// http://commons.oreilly.com/wiki/index.php/SVG_Essentials/Paths
// https://github.com/waldyrious/understand-svg-arcs
typedef EllipseArcData = {
    public var cx:    Float;
    public var cy:    Float;
    var rx:    Float;
    var ry:    Float;
    var alpha: Float;
    var omega: Float;
    var delta: Float;
    var phi: Float;
    // pre-calculate to reduce point calculations
    var phiSin: Float;
    var phiCos: Float;
}
@:forward
class EllipseArc{
    var arc: EllipseArcData;
    public var x: Float;
    public var y: Float;
    public function new( arc_: EllipseArcData ){
        arc = arc_;
    }
    public function alphaPoint(){ // mainly for testing
        calculatePoint( arc.alpha );
    }
    public function omegaPoint(){ // mainly for testing
        calculatePoint( arc.omega );
    }
    public function lineRender( moveTo:  Float->Float->Void, lineTo: Float->Float->Void
                              , dA: Float, ?renderFirst: Bool = true){
        var sign = ( arc.delta > 0 )? 1: -1;
        var totalSteps = Math.ceil( Math.abs( arc.delta )/dA );
        var theta = arc.alpha;
        var step = arc.delta/totalSteps;
        if( renderFirst ){
            calculatePoint( theta );
            moveTo( x, y );
        }
        for( i in 1...totalSteps ){
            theta += step;
            calculatePoint( theta );
            lineTo( x, y );
        }
        calculatePoint( arc.omega );
        lineTo( x, y );
    }
    public inline
    function calculatePoint( theta: Float ){
        var px = arc.cx + arc.rx*Math.cos( theta );
        var py = arc.cy + arc.ry*Math.sin( theta );
        px -= arc.cx;
        py -= arc.cy;
        var dx = px;
        var dy = py;
        px = dx*arc.phiCos - dy*arc.phiSin;
        py = dx*arc.phiSin + dy*arc.phiCos;
        x = px + arc.cx;
        y = py + arc.cy;
        //x = px;
        //y = py;
    }
}
abstract ConverterArc( EllipseArcData ) from EllipseArcData to EllipseArcData {
    public inline function new( sx: Float, sy: Float, xr: Float, yr: Float, phi: Float, large: Int, sweep: Int, ex: Float, ey: Float ){
        // mid point between start and end points.
        var mx = ( sx - ex )/2;
        var my = ( sy - ey )/2;
        // average
        var ax = ( sx + ex )/2;
        var ay = ( sy + ey )/2;
        // convert to radians.
        // must check that % works with negative.
        phi %= 360;
        phi = phi*Math.PI/180;
        var sin = Math.sin( phi );
        var cos = Math.cos( phi );
        // find x1, y1
        var x1 = mx*cos + my*sin;
        var y1 = -mx*sin + my*cos;
        // check radii large enough
        var rx = Math.abs( xr );
        var ry = Math.abs( yr );
        var rxx = rx*rx;
        var ryy = ry*ry;
        var xx1 = x1*x1;
        var yy1 = y1*y1;
        var check = xx1/rxx + yy1/ryy;
        if( check > 1 ){
            rx *= Math.sqrt( check );
            ry *= Math.sqrt( check );
            rxx = rx*rx;
            ryy = ry*ry;
        }
        // find cx,cy
        var sign = ( large == sweep ) ? -1: 1;
        var sq = (  rxx*ryy - rxx * yy1 - ryy * xx1 ) / ( rxx * yy1 + ryy * xx1 );
        sq = ( sq < 0 )? 0: sq;
        var coef = sign * Math.sqrt( sq );
        var cx1 =  coef * rx * y1 / ry;
        var cy1 = -coef * ry * x1 / rx;
        var cx = ax + cx1*cos - cy1*sin;
        var cy = ay + cx1*sin + cy1*cos;
        // adjust sx, sy, ex, ey for phi
        var phiSin = Math.sin( -phi );
        var phiCos = Math.cos( -phi );
        sx -= cx;
        sy -= cy;
        var dx = sx;
        var dy = sy;
        sx = dx*phiCos - dy*phiSin;
        sy = dx*phiSin + dy*phiCos;
        sx = sx + cx;
        sy = sy + cy;
        ex -= cx;
        ey -= cy;
        var dx = ex;
        var dy = ey;
        ex = dx*phiCos - dy*phiSin;
        ey = dx*phiSin + dy*phiCos;
        ex = ex + cx;
        ey = ey + cy;
        // calculate start and end angle taking into acount ellipse angle != eulclid angle.
        var alpha = Math.atan2( rx*(cy-sy), ry*(cx-sx) ) - Math.PI;
        var omega = Math.atan2( rx*(cy-ey), ry*(cx-ex) ) - Math.PI;
        var delta = alpha - omega;
        // change depending on sweep.
        if( sweep == 1 && delta > 0) {
            delta -= 2*Math.PI;
        } else if( sweep == 0 && delta < 0 ){
            delta += 2*Math.PI;
        }
        this = { cx: cx, cy: cy, rx: rx, ry: ry
            , alpha: alpha, omega: omega, delta: -delta, phi: phi
            , phiSin: Math.sin( phi ), phiCos: Math.cos( phi ) }
    }
    static inline function zeroto2pi( angle: Float ): Float {
        return if( angle >= 0 && angle > Math.PI ){
            angle; // don't really want any maths to touch it if it's within range as it may effect value slightly
        } else {
            var a = angle % ( 2 * Math.PI );
            return ( a >= 0 )? a : ( a + 2 * Math.PI );
        }
    }
}