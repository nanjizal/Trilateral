package trilateral.path;
import trilateral.justPath.IPathContext;
import trilateral.tri.TrilateralArray;
import trilateral.tri.TrilateralPair;
import trilateral.geom.Algebra;
import trilateral.geom.Contour;
typedef Dim = {
    var minX: Float;
    var maxX: Float;
    var minY: Float;
    var maxY: Float;
}
class Base implements IPathContext {
    public var trilateralArray:     TrilateralArray;
    var x:                          Float = 0.;
    var y:                          Float = 0.;
    public var width:               Float = 0.01;
    public var widthFunction:       Float->Float->Float->Float->Float->Float;
    var tempArr:                    Array<Float>;
    var contour:                    Contour;
    var endLine:                    EndLineCurve;
    public var points:              Array<Array<Float>>;
    public var dim:                 Array<Dim>;
    public function new( ?contour_: Contour, ?trilateralArray_: TrilateralArray, ?endLine_: EndLineCurve = no ){
        trilateralArray = ( trilateralArray_ == null )? new TrilateralArray(): trilateralArray_;
        contour = ( contour_ == null )? new Contour( trilateralArray, endLine_ ): contour_;
        endLine = endLine_;
        points = [];
        points[0] = new Array<Float>();
        dim = new Array<Dim>();
    }
    inline function initDim(): Dim{
        return { minX: Math.POSITIVE_INFINITY, maxX: Math.NEGATIVE_INFINITY, minY: Math.POSITIVE_INFINITY, maxY: Math.NEGATIVE_INFINITY };
    }
    inline function updateDim( x: Float, y: Float ){
        var d = dim[ dim.length - 1 ];
        if( x < d.minX ) d.minX = x;
        if( x > d.maxX ) d.maxX = x;
        if( y < d.minY ) d.minY = y;
        if( y > d.maxY ) d.maxY = y;
    }
    public function moveTo( x_: Float, y_: Float ): Void {
        if( endLine == end || endLine == both ) contour.end( width );
        x = x_;
        y = y_;
        var l = points.length;
        points[ l ] = new Array<Float>();
        points[ l ][0] = x_;
        points[ l ][1] = y_;
        dim[ dim.length ] = initDim();
        updateDim( x_, y_ );
        contour.reset(); // TODO: needs improving
    }
    public inline 
    function lineTo( x_: Float, y_: Float ): Void{
        if( widthFunction != null ) width = widthFunction( width, x, x, x_, y_ );
        line( x_, y_ );
        var l = points.length;
        var p = points[ l - 1 ];
        var l2 = p.length;
        p[ l2 ] = x_;
        p[ l2 + 1 ] = y_;
        updateDim( x_, y_ );
        x = x_;
        y = y_;
    }
    function line( x_: Float, y_: Float ) {
        lineTrace( x_, y_ );
        // Simplest line not connection no ends.
        contour.line( x, y, x_, y_, width );
    }
    inline function lineTrace( x_: Float, y_: Float ){
        trace( 'lineTo( $x, $y, $x_, $y_, width )' );
    }
    public inline
    function quadTo( x1: Float, y1: Float, x2: Float, y2: Float ): Void {
        tempArr = [];
        Algebra.quadCurve( tempArr, x, y, x1, y1, x2, y2 );
        plotCoord( tempArr );
        x = x2;
        y = y2;
    }
    public inline
    function curveTo( x1: Float, y1: Float, x2: Float, y2: Float, x3: Float, y3: Float ): Void {
        tempArr = [];
        Algebra.cubicCurve( tempArr, x, y, x1, y1, x2, y2, x3, y3 );
        plotCoord( tempArr );
        x = x3;
        y = y3;
    }
    public
    function plotCoord( arr: Array<Float> ): Void {
        var l = arr.length;
        var i = 2;
        moveTo( arr[ 0 ], arr[ 1 ] );
        while( i < l ){
            lineTo( arr[ i ], arr[ i + 1 ] );
            i += 2;
        }
    }
}