package trilateral.polys;
import trilateral.tri.TriangleArray;
import trilateral.tri.TrianglePair;
import trilateral.tri.TrilateralPair;
import trilateral.tri.TrilateralArray;
import trilateral.tri.Triangle;
import trilateral.pairs.Star;
import trilateral.pairs.Quad;
import trilateral.pairs.Line;
import trilateral.polys.Poly;
class Shapes {
    public var triangles:     TriangleArray;
    var colors:        Array<Int>;
    public var refCount: Int = 0; // allow you to reference a shape by an index, ie you can collect all triangles with specific id number.
    public function new( triangleArray_: TriangleArray, colors_: Array<Int> ){
        triangles       = triangleArray_;
        colors          = colors_;
    }
    public inline
    function findShapeById( id: Int ): TriangleArray {
        return triangles.getTriangles( id );
    }
    public inline
    function star( x: Float, y: Float, radius: Float, color: Int, ?theta: Float = 0 ): Int{
        triangles.addPair(  refCount++
                        ,   Star.create( x, y, radius, theta )
                        ,   color );
        return refCount - 1;
    }
    public inline
    function diamond( x: Float, y: Float, radius: Float, color: Int, ?theta: Float = 0 ): Int {
        triangles.addPair(  refCount++
                        ,   Quad.diamond( x, y, radius )
                        ,   color );
        return refCount - 1;
    }
    public inline
    function diamondOutline( x: Float, y: Float, radius: Float, thick: Float, color: Int, ?theta: Float = 0 ): Int {
        triangles.addArray( refCount++
                        ,   Quad.diamondOutline( x, y, thick, radius )
                        ,   color );
        return refCount - 1;
    }
    public inline
    function square( x: Float, y: Float, radius: Float, color: Int, ?theta: Float = 0 ): Int {
        triangles.addPair(  refCount++
                        ,   Quad.square( x, y, radius )
                        ,   color );
        return refCount - 1;
    }
    public inline
    function squareOutline( x: Float, y: Float, radius: Float, thick: Float, color: Int, ?theta: Float = 0 ): Int {
        triangles.addArray( refCount++
                        ,   Quad.squareOutline( x, y, radius, thick )
                        ,   color );
        return refCount - 1;
    }
    public inline
    function rectangle( x: Float, y: Float, width: Float, height: Float, color: Int ): Int {
        triangles.addPair(  refCount++
                        ,   Quad.rectangle( x, y, width, height )
                        ,   color );
        return refCount - 1;
    }
    public inline
    // theta not so relevant to circle but for more general poly it is.
    function circle( x: Float, y: Float, radius: Float, color: Int, ?theta: Float = 0 ): Int {
        triangles.addArray( refCount++
                        ,   Poly.circle( x, y, radius )
                        ,   color );
        return refCount - 1;
    }
    public inline
    function shape( x: Float, y: Float, radius: Float, color: Int, sides: Int, ?theta: Float = 0 ): Int {
        triangles.addArray( refCount++
                        ,   Poly.shape( x, y, radius, sides, theta )
                        ,   color );
        return refCount - 1;
    }
    public inline
    function ellipse( x: Float, y: Float, rx: Float, ry: Float, color: Int, ?sides: Int, ?theta: Float = 0 ): Int {
        triangles.addArray( refCount++
                        ,   Poly.ellipse( x, y, rx, ry, sides )
                        ,   color );
        return refCount - 1;
    }
    public inline
    function roundedRectangle( x: Float, y: Float, width: Float, height: Float, radius: Float, color: Int ): Int {
        triangles.addArray( refCount++
                        ,   Poly.roundedRectangle( x, y, width, height, radius )
                        ,   color );
        return refCount - 1;
    } 
    public inline
    function roundedRectangleOutline( x: Float, y: Float, width: Float, height: Float, thick: Float, radius: Float, color: Int ): Int {
        triangles.addArray( refCount++
                        ,   Poly.roundedRectangleOutline( x, y, width, height, thick, radius )
                        ,   color );
        return refCount - 1;
    }
}