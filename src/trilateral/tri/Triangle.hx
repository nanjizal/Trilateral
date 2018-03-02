package trilateral.tri;
import trilateral.geom.Point;
import trilateral.tri.Trilateral;
class Triangle extends Trilateral {
    public var id: Int;
    public var colorID: Int;
    public var colorA: Int;
    public var colorB: Int;
    public var colorC: Int;
    public var depth: Float;
    public var alpha: Float;
    public function new(  id_: Int
                        , A: Point, B: Point, C: Point
                        , depth_: Float
                        , colorID_: Int
                        ){
        id = id_;
        super( A.x, A.y, B.x, B.y, C.x, C.y );
        depth = depth_;
        alpha = 1.;
        colorID = colorID_;
        colorA = colorID_;
        colorB = colorID_;
        colorC = colorID_;
    }
    // allows creation from a trialateral so you can create shapes use and color them later.
    public static inline
    function fromTrilateral( id_: Int, tri: Trilateral, depth_: Float, colorID_: Int ): Triangle {
        var t: Triangle = Type.createEmptyInstance( Triangle );
        t.id = id_;
        t.ax = tri.ax;
        t.ay = tri.ay;
        t.bx = tri.bx;
        t.by = tri.by;
        t.cx = tri.cx;
        t.cy = tri.cy;
        t.mark = tri.mark;
        t.depth = depth_;
        t.alpha = 1.;
        t.colorID = colorID_;
        t.colorA = colorID_;
        t.colorB = colorID_;
        t.colorC = colorID_;
        t.windingAdjusted = tri.windingAdjusted;
        return t;
    }
    public function hitTest( P: Point ): Bool {
        return fullHit( P.x, P.y );
    }
    // draws Triangle with horizontal strips 1px high.
    public function drawStrips( drawRect: Float->Float->Float->Float->Void ){
        var xi: Int         = Math.floor( x );
        var yi: Int         = Math.floor( y );
        var righti: Int     = Math.ceil( right );
        var bottomi: Int    = Math.ceil( bottom );
        var sx: Int = 0;
        var ex: Int = 0;
        var sFound: Bool;
        var eFound: Bool;
        // need to adjust for negative values thought required.
        for( y0 in yi...bottomi ){ // loop vertically
            sFound = false; // could remove if swapped floor and ceil on boundaries?
            eFound = false; // not needed perhaps just for safety at mo.
            for( x0 in xi...righti ){
                if( liteHit( x0, y0 ) ) { // start strip
                    sx = x0;
                    sFound = true;
                    break;
                }
            }
            if( sFound ){
                for( x0 in sx...righti ){ // end strip
                    if( !liteHit( x0, y0 ) ){
                        ex = x0;
                        eFound = true;
                        break;
                    }
                }
                if( eFound ) drawRect( sx, y0, ex - sx, 1 );
            }
        }
    }
}