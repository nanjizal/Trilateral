package trilateral.pairs;
import trilateral.Algebra;
import trilateral.Trilateral;
// defines a line without a colour only suitable for occasional lines probably.
class Line {
    public inline static
    function create( A: Point, B: Point, width: Float ): TrilateralPair {
        var q = Algebra.lineAB( A, B, width ); // not ideal, don't use for lots of lines.
        return { t0: new Trilateral( q.A.x, q.A.y, q.B.x, q.B.y, q.D.x, q.D.y )
            ,    t1: new Trilateral( q.B.x, q.B.y, q.C.x, q.C.y, q.D.x, q.D.y ) };
    }
}