package trilateral.fxg;
import trilateral.nodule.Nodule;
import trilateral.path.FillOnly;
import trilateral.justPath.SvgPath;
import trilateral.tri.TriangleArray;
import trilateral.path.Base;
import trilateral.fxg.Path;
// simplest possible path implementation for later extension, just a fill.
@:forward
abstract Group( Nodule ) from Nodule to Nodule {
    public inline function new( n: Nodule ){
        this = n;
    }
    public function render( count: Int, tri: TriangleArray, colors: Array<Int>
                        ,   pathFactory: Void->Base
                        ,   fillFunc: TriangleArray -> Int -> Array<Float> -> Int -> Void ){
        var kids = this.childNodules( new Array<Nodule>() );
        for( kid in kids ){
            var p: Path = new Path( kid );
            p.render( count, tri, colors, pathFactory, fillFunc );
            count++;
        }
    }
}