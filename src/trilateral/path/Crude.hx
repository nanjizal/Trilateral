package trilateral.path;
import justPath.IPathContext;
import trilateral.tri.TrilateralArray;
import trilateral.geom.Algebra;
import trilateral.geom.Contour;
class Crude extends Base {
    public function new( ?contour_: Contour, ?trilateralArray_: TrilateralArray ){
        super( contour_, trilateralArray_ );
    }
    override inline
    function line( x_: Float, y_: Float ){
        // lineTrace( x_, y_ );
        trilateralArray.addPair( contour.line( x, y, x_, y_, width ) );
    }
}
