package trilateral.path;
import justPath.IPathContext;
import trilateral.tri.TrilateralArray;
import trilateral.tri.TrilateralPair;
import trilateral.geom.Contour;
// This is not ideal as it lets quads overlap but does not require calculation of inner angle
class MediumOverlap extends Base {
    public function new( ?contour_: Contour, ?trilateralArray_: TrilateralArray, ?endLine_: EndLineCurve ){
        super( contour_, trilateralArray_, endLine_ );
    }
    override inline
    function line( x_: Float, y_: Float ){
        // lineTrace( x_, y_ );
        contour.triangleJoin( x, y, x_, y_, width, false, true );
    }
}
