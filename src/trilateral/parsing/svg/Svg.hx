package trilateral.parsing.svg;
import trilateral.parsing.svg.*;
import trilateral.nodule.AttributePairs;
import trilateral.nodule.Nodule;
import trilateral.justPath.SvgPath;
import trilateral.path.FillOnly;
import trilateral.path.Crude;
import trilateral.path.Fine;
import trilateral.path.Base;
import trilateral.parsing.FillDraw;
class Svg{
    public var fillDraw: FillDraw;
    public var groups: Array<Group>;//
    public var group: Group;
    public var nodule: Nodule;
    public var rnd: Bool = false;
    public function new( nodule_: Nodule ){
        nodule = nodule_;
        
    }
    public function render( fillDraw_: FillDraw, ?rnd_: Bool = false ){
        fillDraw = fillDraw_;
        rnd = rnd_;
        switch( nodule.name ){
            case 'g':
                var g = parseGroup( nodule );
            case 'path':
                var p = parsePath( nodule );
            case _:
                parseChild( nodule );
        }
    }
    public inline
    function parseChild( nodule: Nodule ){
        var childs: Array<Nodule> = nodule.childNodules( new Array() );
        for( kid in childs ){
            switch( kid.name ){
                case 'g':
                    var g = parseGroup( kid );
                case 'path':
                    var p = parsePath( kid );
                case _:
                    parseChild( kid );
            }
        }
    }
    public inline
    function parseGroup( kid: Nodule ): Group {
        var g: Group = {};
        for( at in kid.attributes( [] ) ) g.attributeAdd( at );
        // trace( 'g ' + g );
        group = g;
        if( kid.firstChild != null ) {
            parseChild( kid );
        }
        return g;
    }
    public inline
    function parsePath( kid: Nodule ): Path {
        var p: Path = {};
        for( at in kid.attributes( [] ) ) p.attributeAdd( at );
        // trace( 'path ' + p );
        // composite group with group properties above like matrix in realistic render, pushing poping on group
        // arigate group values?
        var g = group;
        if( g == {} ) g = null;
        renderPath( p, group );
        return p;
    }
    public function renderPath( path: Path, group: Group ){
        var black            = fillDraw.colorId( 0xFF000000 );
        // var red              = imageDrawing.colorId( 0xFFFF0000 );
        // TODO take into account above group settings!
        // set fill color
        var hasGroupFill     = ( group == null )? false: (( group.fill != null )? true: false );
        var hasPathFill      = ( path.fill != null )? true: false;
        var hasFill          = ( hasPathFill )? true: hasGroupFill;
        var solidColor = black;
        if( hasPathFill ){
            solidColor = fillDraw.colorId( path.fill );
        } else if( hasGroupFill ){
            solidColor = fillDraw.colorId( group.fill );
        }
        // set stroke color
        var hasPathStroke    = ( path.stroke != null )? true: false;
        var hasGroupStroke   = ( group == null )? false: (( group.stroke != null )? true: false);
        var hasStroke        = ( hasPathStroke )? true: hasGroupStroke;
        var lineColor = black;
        if( hasPathStroke ){
            lineColor = fillDraw.colorId( path.stroke );
        } else if( hasGroupStroke ){
            lineColor = fillDraw.colorId( group.stroke );
        }
        // set stroke width
        var hasGroupWidth= ( group == null )? false: (( group.stroke_width != null )? true: false );
        var hasPathWidth = ( path.stroke_width != null )? true: false;
        
        var lineWidth: Float = 0.;
        if( hasPathWidth ){
            lineWidth = path.stroke_width;
            lineWidth /= 2;
        } else if( hasGroupStroke ){
            lineWidth = group.stroke_width;
            lineWidth /= 2;
        }
        if( hasStroke ){
            var pen = fillDraw.pathFactory();
            pen.width = lineWidth;
            ( new SvgPath( pen ) ).parse( path.d );
            var points = pen.pointsRewound();
            //points.reverse();
            if( hasFill ) {
                if( rnd ){
                    fillDraw.fillRnd( points, fillDraw.colors.length );
                } else {
                    fillDraw.fill( points, solidColor );
                }
            }
            fillDraw.triangles.addArray( fillDraw.count, pen.trilateralArray, lineColor );
        } else if( hasFill ){
            var fillOnly = new FillOnly();
            fillOnly.width = 1.;
            ( new SvgPath( fillOnly ) ).parse( path.d );
            var points = fillOnly.pointsRewound();
            //points.reverse();
            if( rnd ){
                fillDraw.fillRnd( points, fillDraw.colors.length );
            } else {
                fillDraw.fill( points, solidColor );
            }

            /* FOR TESTING 
            // outline just fills
            var pen = fillDraw.pathFactory();
            pen.width = 3;
            ( new SvgPath( pen ) ).parse( path.d );
            fillDraw.triangles.addArray( imageDrawing.count, pen.trilateralArray, red );
            */
        }
    }
}