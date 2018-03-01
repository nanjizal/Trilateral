package trilateral.path;
import justPath.IPathContext;
import trilateral.TrilateralArray;
import trilateral.Algebra;
import trilateral.pairs.Line;
import trilateral.path.Lines;
class Crude extends Base {
    public function new( ?lines_: Lines, ?trilateralArray_: TrilateralArray ){
        super( lines_, trilateralArray_ );
    }
    override inline
    function line( x_: Float, y_: Float ){
        trilateralArray.addPair( lines.line( x, y, x_, y_, width ) );
    }
}
