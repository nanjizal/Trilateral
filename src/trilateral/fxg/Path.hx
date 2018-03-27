package trilateral.fxg;
import trilateral.nodule.Nodule;
import trilateral.nodule.AttributePairs;
import trilateral.path.FillOnly;
import trilateral.path.Crude;
import trilateral.path.Fine;
import trilateral.path.Base;
import trilateral.justPath.SvgPath;
import trilateral.tri.TriangleArray;
// simple path implementation for later extension.
@:forward
abstract Path( Nodule ) from Nodule to Nodule {
    public inline function new( n: Nodule ){
        this = n;
    }
    public function render( count: Int, tri: TriangleArray, colors: Array<Int>
                        ,   pathFactory: Void->Base
                        ,   fillFunc: TriangleArray -> Int -> Array<Float> -> Int -> Void ){
        var d = this.firstAttribute.content;
        var kid = new Array<Nodule>();
        this.childNodules( kid );
        var fill        = kid.filter( function(v) { return ( v.name == 'fill' ); } );
        var stroke      = kid.filter( function(v) { return( v.name == 'stroke' ); } );
        var solidColor: Int = 0xFF000000; // defaults to black
        var lineColor:  Int = 0xFF000000; // defaults to black 
        var lineWidth:  Float = 0.;
        var hasFill     = ( fill.length != 0 );
        var hasStroke   = ( stroke.length != 0 );
        if( hasFill ){
            if( fill[0].firstChild.firstAttribute != null ){
                solidColor = parseColor( fill[0].firstChild.firstAttribute.content );
            }
        }
        if( hasStroke ){
            var attPairs = new AttributePairs();
            var attPairs = stroke[ 0 ].firstChild.attributes( attPairs );//SolidColorStroke
            for( pair in attPairs ){
                if( pair.name == 'weight' ) lineWidth = Std.parseFloat( pair.value )/2;
                if( pair.name == 'color' )  lineColor = parseColor( pair.value );
            }
        }
        if( hasFill && hasStroke ){
            var pen = pathFactory();
            pen.width = lineWidth;
            var svgPath = new SvgPath( pen );
            svgPath.parse( d );
            var id = colors.indexOf( solidColor );
            if( id == -1 ) {
                id = colors.length;
                colors[id] = solidColor;
            }
            var p = pen.points;
            var l = p.length;
            var j = 0;
            for( i in 0...l ){
                if( p[ i ].length != 0 ){ // only try to fill empty arrays
                    fillFunc( tri, count, p[ i ], id );
                    j++;
                }
            }
            var id = colors.indexOf( lineColor );
            if( id == -1 ) {
                id = colors.length;
                colors[ id ] = lineColor;
            }
            tri.addArray( count, pen.trilateralArray, id );
        } else if( hasFill ){
            var fillOnly = new FillOnly();
            fillOnly.width = 1;
            var svgPath = new SvgPath( fillOnly );
            svgPath.parse( d );
            var id = colors.indexOf( solidColor );
            if( id == -1 ) {
                id = colors.length;
                colors[ id ] = solidColor;
            }
            var p = fillOnly.points;
            var l = p.length;
            var j = 0;
            for( i in 0...l ){
                if( p[ i ].length != 0 ){ // only try to fill empty arrays
                    fillFunc( tri, count, p[ i ], id );
                    j++;
                }
            }
        } else if( hasStroke ){
            var pen = pathFactory();
            pen.width = lineWidth;
            var svgPath = new SvgPath( pen );
            svgPath.parse( d );
            var id = colors.indexOf( lineColor );
            if( id == -1 ) {
                id = colors.length;
                colors[ id ] = lineColor;
            }
            tri.addArray( count, pen.trilateralArray, id );
        }
    }
    public inline function parseColor( hashColor: String ): Int {
        var col = hashColor.substr( 1 );
        return 0xFF000000 + Std.parseInt( '0x' + col );
    }
}