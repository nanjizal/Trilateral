package trilateral.parsing;
import trilateral.tri.TriangleArray;
import trilateral.tri.Triangle;
import trilateral.path.Fine;
import trilateral.path.Base;
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
        throw 'please extend FillDraw with implementation';
    }
    // used to help show random fills
    public
    function fillRnd( p: Array<Array<Float>>, rnd: Int ){
        throw 'please extend FillDraw with implementation';
    }
    public
    function pathFactory(): Base {
        throw 'please extend FillDraw with implementation';
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