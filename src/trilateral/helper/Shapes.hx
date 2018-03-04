package trilateral.helper;
import trilateral.tri.TriangleArray;
import trilateral.tri.TrianglePair;
import trilateral.tri.TrilateralPair;
import trilateral.tri.TrilateralArray;
import trilateral.helper.AppColors;
import trilateral.pairs.Star;
import trilateral.pairs.Quad;
import trilateral.pairs.Line;
import trilateral.polys.Poly;

class Shapes {
    // used for testing.
    var triangles:     TriangleArray;
    var colors:        Array<AppColors>;
    var refCount: Int = 0; // allow you to reference a shape by an index, ie you can collect all triangles with specific id number.
    public function new( triangleArray_: TriangleArray, colors_: Array<AppColors> ){
        triangles       = triangleArray_;
        colors          = colors_;
    }
    public inline
    function star( x: Float, y: Float, radius: Float, color: AppColors, ?theta: Float = 0 ): Int{
        triangles.addPair(  refCount++
                        ,   Star.create( { x: x, y: y }, radius, theta )
                        ,   colors.indexOf( color ) );
        return refCount - 1;
    }
    public inline
    function diamond( x: Float, y: Float, radius: Float, color: AppColors, ?theta: Float = 0 ): Int {
        triangles.addPair(  refCount++
                        ,   Quad.diamond( { x: x, y: y }, radius )
                        ,   colors.indexOf( color ) );
        return refCount - 1;
    }
    public inline
    function square( x: Float, y: Float, radius: Float, color: AppColors, ?theta: Float = 0 ): Int {
        triangles.addPair(  refCount++
                        ,   Quad.square( { x: x, y: y }, radius )
                        ,   colors.indexOf( color ) );
        return refCount - 1;
    }
    public inline
    function rectangle( x: Float, y: Float, width: Float, height: Float, color: AppColors ): Int {
        triangles.addPair(  refCount++
                        ,   Quad.rectangle( { x: x, y: y }, { x: width, y: height } )
                        ,   colors.indexOf( color ) );
        return refCount - 1;
    }
    public inline
    // theta not so relevant to circle but for more general poly it is.
    function circle( x: Float, y: Float, radius: Float, color: AppColors, ?theta: Float = 0 ): Int {
        triangles.addArray( refCount++
                        ,   Poly.circle( { x: x, y: y }, radius )
                        ,   colors.indexOf( color ) );
        return refCount - 1;
    }
    public inline
    function spiralLines( x: Float, y: Float, radius: Float, nolines: Int, startWid: Float, stepWid: Float, color: AppColors ): Int {
        var theta = 0.;
        var line: TrilateralPair;
        var wid = startWid;
        for( i in 0...nolines ){
            var p0 = { x: x, y: y };
            var p1 = { x: x + radius*Math.sin( theta ), y: y + radius*Math.cos( theta ) };
            theta += (Math.PI*2)/nolines;
            line = Line.create( p0, p1, wid+= stepWid );
            triangles.addPair(  refCount
                            ,   line
                            ,   colors.indexOf( color ) );
        }
        refCount++;
        return refCount - 1;
    }
}