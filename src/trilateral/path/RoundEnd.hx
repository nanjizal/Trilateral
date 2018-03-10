package trilateral.path;
import trilateral.tri.TrilateralArray;
import trilateral.geom.Contour;
class RoundEnd extends Base {
    public function new( ?contour_: Contour, ?trilateralArray_: TrilateralArray ){
        super( contour_, trilateralArray_ );
    }
    override inline
    function line( x_: Float, y_: Float ){
        // lineTrace( x_, y_ );
        // less than ideal as triangles overlap lots, Fine needs tweaking.
        contour.line( x, y, x_, y_, width, both );
    }
}