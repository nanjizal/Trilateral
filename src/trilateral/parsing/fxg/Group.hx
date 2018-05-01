package trilateral.parsing.fxg;
import trilateral.nodule.Nodule;
import trilateral.path.FillOnly;
import trilateral.justPath.SvgPath;
import trilateral.tri.TriangleArray;
import trilateral.path.Base;
import trilateral.parsing.FillDraw;
import trilateral.parsing.fxg.Path;
@:forward
abstract Group( Nodule ) from Nodule to Nodule {
    public inline function new( n: Nodule ){
        this = n;
    }
    public function render( fillDraw: FillDraw, rnd: Bool = false ){
        var kids = this.childNodules( new Array<Nodule>() );
        for( kid in kids ){
            var p: Path = new Path( kid );
            p.render( fillDraw, rnd );
            fillDraw.count = fillDraw.count++;
        }
    }
}