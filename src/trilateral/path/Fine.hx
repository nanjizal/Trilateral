package trilateral.path;
import justPath.IPathContext;
import trilateral.tri.TrilateralArray;
import trilateral.tri.TrilateralPair;
import trilateral.geom.Contour;
class Fine extends Base {
    public function new( ?contour_: Contour, ?trilateralArray_: TrilateralArray ){
        super( contour_, trilateralArray_ );
    }
    override inline
    function line( x_: Float, y_: Float ){
        // lineTrace( x_, y_ );
        // broken a bit!
        contour.triangleJoin( x, y, x_, y_, width, true );
    }
}