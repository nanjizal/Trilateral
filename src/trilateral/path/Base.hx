package trilateral.path;
import justPath.IPathContext;
import trilateral.TrilateralArray;
import trilateral.Algebra;
import trilateral.pairs.Line;
import trilateral.path.Lines;
class Base implements IPathContext {
    public var trilateralArray:     TrilateralArray;
    var x:                          Float = 0.;
    var y:                          Float = 0.;
    public var width:               Float = 0.01;
    public var widthFunction:       Float->Float->Float->Float->Float->Float;
    var tempArr:                    Array<Float>;
    var lines:                      Lines;
    public function new( ?lines_: Lines, ?trilateralArray_: TrilateralArray ){
        trilateralArray = ( trilateralArray_ == null )? new TrilateralArray(): trilateralArray_;
        lines = ( lines_ == null )? new Lines(): lines_;
    }
    public function moveTo( x_: Float, y_: Float ): Void{
        x = x_;
        y = y_;
    }
    public inline 
    function lineTo( x_: Float, y_: Float ): Void{
        if( widthFunction != null ) width = widthFunction( width, x, x, x_, y_ );
        line( x_, y_ );
        x = x_;
        y = y_;
    }
    function line( x_: Float, y_: Float ) {
        trace( 'lineTo( $x, $y, $x_, $y_, width )' );
        trilateralArray.addPair( lines.line( x, y, x_, y_, width ) );
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
        lineTo( arr[ i ], arr[ i + 1 ] );
        var line: TrilateralPair;
        while( i < l ){
            lineTo( arr[ i ], arr[ i + 1 ] );
            i += 2;
        }
    }
}