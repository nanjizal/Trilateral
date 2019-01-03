package trilateral.parsing;
import trilateral.tri.TriangleArray;
import trilateral.tri.Triangle;
import trilateral.arr.ArrayTriple;
import trilateral.path.Base;
typedef TfillDatas = {
    var vert: Array<Float>;
    var tri:  Array<Int>;
}
class FillDraw {
    public var count        = 0;
    public var colors       = new Array<Int>();
    public var triangles    = new TriangleArray();
    public var width:   Int;
    public var height:  Int;
    public
    function new( ?width_: Int, ?height_: Int ){
        if( width_ != null )  width   = width_;
        if( height_ != null ) height  = height_;
    }
    public
    function fill( p: Array<Array<Float>>, colorID: Int ){
        var fillDatas = fillFunc( p );
        return iterFill( fillDatas.vert, fillDatas.tri, colorID );
    }
    // used to help show random fills
    public
    function fillRnd( p: Array<Array<Float>>, rnd: Int ){
        var fillDatas = fillFunc( p );
        return iterFill( fillDatas.vert, fillDatas.tri, rnd, true );
    }
    public
    function fillFunc( p: Array<Array<Float>> ):TfillDatas {
        return { vert: [], tri: [] }
    }
    public
    function pathFactory(): Base {
        throw 'please extend FillDraw with implementation';
    }
    inline function rndInt( rnd: Int ){
        return Std.int( Math.round( Math.random()*rnd ) );
    }
    function iterFill( vert: Array<Float>, tri: Array<Int>, colorID: Int, ifRnd: Bool = false ){
        var triples = new ArrayTriple( tri );
        var i: Int;
        var id: Int;
        for( tri in triples ){
            var a: Int = Std.int( tri.a*3 );
            var b: Int = Std.int( tri.b*3 );
            var c: Int = Std.int( tri.c*3 );
            id = ( ifRnd )? colorID: rndInt( colorID );
            triangles.drawTriangle(  count, { x: vert[ a ], y: vert[ a + 1 ] }
                                , { x: vert[ b ], y: vert[ b + 1 ] }
                                , { x: vert[ c ], y: vert[ c + 1 ] }, id );
        }
    }
    public inline
    function colorId( color: Int ): Int {
        var id = colors.indexOf( color );
        if( id == -1 ) {
            id = colors.length;
            colors[ id ] = color;
        }
        return id;
    }
}