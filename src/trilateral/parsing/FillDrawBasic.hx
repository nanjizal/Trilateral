package trilateral.parsing;
import trilateral.tri.TriangleArray;
import trilateral.tri.Triangle;
import trilateral.path.Fine;
import trilateral.path.Base;
import trilateral.parsing.FillDraw;
// TODO: implement
class FillDrawBasic extends FillDraw {
    public
    function new( ?w: Int, ?h: Int ){
        super( w, h );
    }
    public override
    function fill( p: Array<Array<Float>>, colorID: Int ){
        throw 'please extend FillDraw with implementation';
    }
    // used to help show random fills
    public override
    function fillRnd( p: Array<Array<Float>>, rnd: Int ){
        throw 'please extend FillDraw with implementation';
    }
    public override
    function pathFactory(): Base {
        throw 'please extend FillDraw with implementation';
    }
}