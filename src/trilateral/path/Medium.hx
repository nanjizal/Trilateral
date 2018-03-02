package trilateral.path;
import justPath.IPathContext;
import trilateral.TrilateralArray;
import trilateral.Algebra;
import trilateral.pairs.Line;
import trilateral.path.Lines;
class Medium extends Base {
    public function new( ?lines_: Lines, ?trilateralArray_: TrilateralArray ){
        super( lines_, trilateralArray_ );
    }
    override inline
    function line( x_: Float, y_: Float ){
       // trace( 'x '+ x + ',y ' + y + ',x2 ' + x_ + ',y2 ' + y_ );
       lines.triangleJoin( trilateralArray, x, y, x_, y_, width, false );
    }
}