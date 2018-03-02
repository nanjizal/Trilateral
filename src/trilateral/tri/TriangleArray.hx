package trilateral.tri;
import trilateral.tri.Triangle;
import trilateral.geom.Algebra;
import trilateral.geom.Point;
@:forward
abstract TriangleArray(Array<Triangle>) from Array<Triangle> to Array<Triangle> {
    inline public 
    function new( ?t: Array<Triangle> ) {
        this = ( t == null )? getEmpty(): t;
    }
    public inline static 
    function getEmpty(){
        return new TriangleArray( new Array<Triangle>() );
    }
    public inline
    function clear(){
        this = new TriangleArray();
    }
    public inline
    function pushPair( tp: TrianglePair ){
        this[ this.length ] = tp.t0;
        this[ this.length ] = tp.t1;
    }
    public inline
    function drawTriangle( id: Int, p0: Point, p1: Point, p2: Point, colorID: Int ): Triangle {
        var tri = new Triangle( id, p0, p1, p2, 0, colorID );
        this[ this.length ] = tri;
        return tri;
    }
    public inline
    function add( id: Int, tri: Trilateral, colorID: Int ): Triangle {
        var tri = Triangle.fromTrilateral( id, tri, 0, colorID );
        this[ this.length ] = tri;
        return tri;
    }
    public inline
    function addPair( id: Int, tri: TrilateralPair, colorID: Int ) {
        var tri0 = Triangle.fromTrilateral( id, tri.t0, 0, colorID );
        this[ this.length ] = tri0;
        var tri1 = Triangle.fromTrilateral( id, tri.t1, 0, colorID );
        this[ this.length ] = tri1;
        return tri;
    }
    public inline
    function addArray( id: Int, triArr: Array<Trilateral>, colorID: Int ) {
        var tri: Triangle;
        for( t in triArr ) {
            tri = Triangle.fromTrilateral( id, t, 0, colorID );
            this[ this.length ] = tri;
        }
        return triArr;
    }
    public inline 
    function getTriangles( id: Int ): TriangleArray {
        var out = new TriangleArray();
        for( i in 0...this.length ) if( this[ i ].id == id ) out[ out.length ] = this[ i ];
        return out;
    }
    public inline
    function getHitTriangles( p: Point ): TriangleArray {
        var out = new TriangleArray();
        for( i in 0...this.length ) if( this[ i ].hitTest( p ) ) out[ out.length ] = this[ i ];
        return out;
    }
}