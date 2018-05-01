package trilateral.parsing.fxg;
import trilateral.nodule.Nodule;
import trilateral.nodule.AttributePairs;
import trilateral.path.FillOnly;
import trilateral.path.Crude;
import trilateral.path.Fine;
import trilateral.path.Base;
import trilateral.justPath.SvgPath;
import trilateral.tri.TriangleArray;
import trilateral.parsing.FillDraw;
@:forward
abstract Path( Nodule ) from Nodule to Nodule {
    public inline function new( n: Nodule ){
        this = n;
    }
    public inline function firstChildAttPairs( nodule: Nodule ): AttributePairs {
        var firstNodule = nodule.firstChild;
        var attPairs = new AttributePairs();
        attPairs = firstNodule.attributes( attPairs );
        return attPairs;
    }
    public function render( fillDraw: FillDraw, ?rnd: Bool = false ){
        var d = this.firstAttribute.content;
        var black = fillDraw.colorId( 0xFF000000 );
        var solidColor      = black;
        var lineColor       = black;
        var lineWidth:      Float = 0.;
        var hasFill         = false;
        var hasStroke       = false;
        for( prop in this.childNodules( new Array<Nodule>() ) ){
            switch( prop.name ){
                case 'fill':
                    hasFill = true;
                    for( pair in firstChildAttPairs( prop ) ){
                        switch( pair.name ){
                            case 'color':
                                solidColor = fillDraw.colorId( parseColor( pair.value ) );
                            case _:
                                trace( 'fill attribute : '+ pair.name +' not implemented' );
                        }
                    }
                case 'stroke':
                    hasStroke = true;
                    for( pair in firstChildAttPairs( prop ) ){
                        switch( pair.name ){
                            case 'weight':
                                lineWidth = Std.parseFloat( pair.value )/2;
                            case 'color':
                                lineColor = fillDraw.colorId( parseColor( pair.value ) );
                            case _:
                                trace( 'stroke attribute : '+ pair.name +' not implemented' );
                        }
                    }
                case _:
                    trace( 'prop.name : '+ prop.name +' not implemented' );
            }
        }
        if( hasStroke ){
            var pen = fillDraw.pathFactory();
            pen.width = lineWidth;
            ( new SvgPath( pen ) ).parse( d );
            if( hasFill ) {
                if( rnd ){
                    fillDraw.fillRnd( pen.points, fillDraw.colors.length );
                } else {
                    fillDraw.fill( pen.points, solidColor );
                }
            }
            fillDraw.triangles.addArray( fillDraw.count, pen.trilateralArray, lineColor );
        } else if( hasFill ){
            var fillOnly = new FillOnly();
            fillOnly.width = 1;
            ( new SvgPath( fillOnly ) ).parse( d );
            if( rnd ){
                fillDraw.fillRnd( fillOnly.points, fillDraw.colors.length );
            } else {
                fillDraw.fill( fillOnly.points, solidColor );
            }
        }
    }
    inline
    function parseColor( hashColor: String ): Int {
        var col = hashColor.substr( 1 );
        //trace( ' col ' + col );
        return 0xFF000000 + Std.parseInt( '0x' + col );
    }
}