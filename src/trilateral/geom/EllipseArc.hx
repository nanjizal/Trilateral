package trilateral.geom;
// No license found so should be fine under MIT ( 15March2018 )
// https://github.com/MadLittleMods/svg-curve-lib/blob/master/src/js/svg-curve-lib.js
// UNTESTED
import trilateral.angle.ZeroTo2pi;
class EllipseArc {
    public
    var startAngle:         ZeroTo2pi;
    public
    var sweepAngle:         ZeroTo2pi;
    public
    var endAngle:           ZeroTo2pi;
    public
    var angle:              ZeroTo2pi;
    // center
    public
    var cx:                 Float;
    public
    var cy:                 Float;
    var rx:                 Float;
    var ry:                 Float;
    public var px:          Float;
    public var py:          Float;
    var sin:                Float;
    var cos:                Float;
    var startX:             Float;
    var startY:             Float;
    var endX:               Float;
    var endY:               Float;
    public var length:      Float;
    public function new(){
        
    }
    // Angle.differencePrefer ??
    function angleBetween( x0: Float, y0: Float, x1: Float, y1: Float ){
        var p = x0*x1 + y0*y1;
        var n = Math.sqrt( ( x0*x0 + y0*y0 )*( x1*x1 + y1*y1 ) );
        var sign = ( x0*y1 - y0*x1 < 0 )? -1 : 1;
        var angle = sign*Math.acos( p / n );
        //var angle = Math.atan2(v0.y, v0.x) - Math.atan2(v1.y,  v1.x);
        return angle;
    }
    public 
    function setup(   x0: Float, y0: Float
                ,    rx_: Float, ry_: Float
                ,    theta: ZeroTo2pi
                ,    large: Bool, sweep: Bool
                ,    x1: Float, y1: Float ){
        rx = Math.abs( rx_ );// In accordance to: http://www.w3.org/TR/SVG/implnote.html#ArcOutOfRangeParameters
        ry = Math.abs( ry_ );
        // Following "Conversion from endpoint to center parameterization"
        // http://www.w3.org/TR/SVG/implnote.html#ArcConversionEndpointToCenter
        // Step #1: Compute transformedPoint
        var dx    = ( x0 - x1 )/2;
        var dy    = ( y0 - y1 )/2;
        var avgX  = ( x0 + x1 )/2;
        var avgY  = ( y0 + y1 )/2;
        sin = Math.sin( theta );
        cos = Math.cos( theta );
        var tx = cos*dx + sin*dy;
        var ty = -sin*dx + cos*dy;
        // Ensure radii are large enough
        var tx2 = tx*tx;
        var ty2 = ty*ty;
        var rx2 = rx*rx;
        var ry2 = ry*ry;
        var radiiCheck = tx2/rx2 + ty2/ry2;
        if( radiiCheck > 1 ){
            var radiiSq = Math.sqrt( radiiCheck );
            rx = radiiSq*rx;
            ry = radiiSq*ry;
            rx2 = rx*rx;
            ry2 = ry*ry;
        }
        // Compute transformedCenter
        var cRadicand = ( rx2*ry2 - rx2*tx2 - ry2*tx2 ) / ( rx2*tx2 + ry2*tx2 );
        // Make sure this never drops below zero because of precision
        cRadicand = ( cRadicand < 0 )? 0 : cRadicand;
        var cCoef = ( ( large != sweep ) ? 1: -1 ) * Math.sqrt( cRadicand );
        var tcx = cCoef*(  (rx*ty) / ry );
        var tcy = cCoef*( -(ry*tx) / rx );
        // Compute center
        cx = cos*tcx - sin*tcy + avgX;
        cy = sin*tcx + cos*tcy + avgY;
        // Compute start/sweep angles
        // Start angle of the elliptical arc prior to the stretch and rotate operations.
        // Difference between the start and end angles
        startX = ( tx - tcx )/rx;
        startY = ( ty - tcy )/ry;
        // TODO: look to see if ZeroTo2pi and Pi2pi could help?
        startAngle = angleBetween( 1, 0, startX, startX );  // this is problem
        endX = ( -tx - tcx )/rx;
        endY = ( -ty - tcy )/ry;
        //endAngle = angleBetween( 1, 0, endX, endY );
        sweepAngle = angleBetween( startX, startY, endX, endY ); // This is problem
        
        /*
        if( !sweep && sweepAngle > 0 ){
            sweepAngle -= 2*Math.PI;
        } else if( sweep && sweepAngle < 0){
            sweepAngle += 2*Math.PI;
        }
        */
        // We use % instead of `mod(..)` because we want it to be -360deg to 360deg(but actually in radians)
         // sweepAngle %= 2*Math.PI;
        
        endAngle = startAngle + sweepAngle;
    }
    // Call this repeatedly from 0->1 to create points on an Elliptical Arc.
    public
    function calculateforT( t: Float ) {
        angle = startAngle + ( sweepAngle * t );
        var eX = rx * Math.cos( angle ); // ellipse component
        var eY = ry * Math.sin( angle );
        px = cos*eX - sin*eY + cx;
        py = sin*eX + cos*eY + cy;
    }
    public function calculateApproxLength( ?resolution: Int = 25 ) {
        length = 0.;
        calculateforT( 0 );
        var prevPx = px;
        var prevPy = py;
        for( i in 0...resolution ){
            var t = Math.min( Math.max( i*( 1/resolution ), 0 ), 1 );
            calculateforT( t );
            length += Algebra.distance( prevPx, prevPy, px, py );
            prevPx = px;
            prevPy = py;
        }
        calculateforT( 1 );
        length += Algebra.distance( prevPx, prevPy, px, py );
    }
}