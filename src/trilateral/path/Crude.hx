package trilateral.path;
import justPath.IPathContext;
import trilateral.TrilateralArray;
import trilateral.Algebra;
import trilateral.pairs.Line;
import trilateral.path.Lines;
class Crude extends Base {
    public function new( ?lines_: Lines, ?trilateralArray_: TrilateralArray ){
        super( lines, trilateralArray_ );
    }
    override inline
    function line( ax, ay, bx, by ): TrilateralPair {
        return lines.line( ax, ay, bx, by, width );
    }
}
