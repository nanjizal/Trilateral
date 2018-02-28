package;
import js.Browser;
import khaMath.Matrix4;
import htmlHelper.webgl.WebGLSetup;
import js.html.Event;
import js.html.KeyboardEvent;
import js.html.MouseEvent;
import htmlHelper.tools.AnimateTimer; 

import trilateral.Triangle;
import trilateral.TriangleArray;
import trilateral.Algebra;
import trilateral.pairs.Star;
import trilateral.pairs.Square;
import trilateral.pairs.Diamond;
import trilateral.pairs.Line;
import trilateral.pairs.Rectangle;
import trilateral.polys.Poly;
using htmlHelper.webgl.WebGLSetup;
@:enum
abstract AppColors( Int ) to Int from Int {
    var Violet      = 0x9400D3;
    var Indigo      = 0x4b0082;
    var Blue        = 0x0000FF;
    var Green       = 0x00ff00;
    var Yellow      = 0xFFFF00;
    var Orange      = 0xFF7F00;
    var Red         = 0xFF0000;
    var Black       = 0x000000;
    var LightGrey   = 0x444444;
    var MidGrey     = 0x333333;
    var DarkGrey    = 0x0c0c0c;
    var NearlyBlack = 0x111111;
    var White       = 0xFFFFFF;
    var BlueAlpha   = 0x0000FF;
    var GreenAlpha  = 0x00FF00;
    var RedAlpha    = 0xFF0000;
}
class Test extends WebGLSetup {
    var webgl: WebGLSetup;
    var appColors:         Array<AppColors> = [ Black, Red, Orange, Yellow, Green, Blue, Indigo, Violet
                                            , LightGrey, MidGrey, DarkGrey, NearlyBlack, White
                                            , BlueAlpha, GreenAlpha, RedAlpha ];
    public function findColorID( col: AppColors ){
        return appColors.indexOf( col );
    }
    //var triangles: Array<Triangle>;
    var triangles: TriangleArray;
    public static inline var vertex: String =
        'attribute vec3 pos;' +
        'attribute vec4 color;' +
        'varying vec4 vcol;' +
        'uniform mat4 modelViewProjection;' +
        'void main(void) {' +
            ' gl_Position = modelViewProjection * vec4(pos, 1.0);' +
            ' vcol = color;' +
        '}';
    public static inline var fragment: String =
        'precision mediump float;'+
        'varying vec4 vcol;' +
        'void main(void) {' +
            ' gl_FragColor = vcol;' +
        '}';
    public static function main(){ new Test(); }
    public function new(){
        super(570*2, 570*2 );
        bgRed = 0x18/256;
        bgGreen = 0x18/256;
        bgBlue = 0x18/256;
        triangles = new TriangleArray();
        var trilateralPair = Line.create( { x: 0., y: 0. }, { x: 0.5, y: 0.5 }, 0.01 );
        triangles.drawTrilateralPair( 1, trilateralPair, 1 );
        var trilateralPair = Star.create( {x:-0.3, y:-0.3}, 0.2 );
        triangles.drawTrilateralPair( 1, trilateralPair, 2 );
        var trilateralPair = Diamond.create( {x:-0.3, y:0.3}, 0.2 );
        triangles.drawTrilateralPair( 1, trilateralPair, 3 );
        var trilateralPair = Square.create( {x:0.3, y:-0.3}, 0.1 );
        triangles.drawTrilateralPair( 1, trilateralPair, 4 );
        var circle = Poly.circle( { x: 0.3, y: 0.3 }, 0.1 );
        triangles.drawArrayTrilateral( 1, circle, 5 );
        setupProgram( vertex, fragment );
        modelViewProjection = Matrix4.identity();
        AnimateTimer.create();
        AnimateTimer.onFrame = render_;
        render();
    }
    
    public function setTriangles( triangles: Array<Triangle>, triangleColors:Array<UInt> ) {
        //trace( 'triangles' + triangles );
        var rgb: RGB;
        var colorAlpha = 1.0;
        var tri: Triangle;
        var count = 0;
        var i: Int = 0;
        var c: Int = 0;
        var j: Int = 0;
        var ox: Float = 0.;
        var oy: Float = 0.3;
        var no: Int = 0;
        for( tri in triangles ){
            vertices[ i++ ] = tri.ax + ox;
            vertices[ i++ ] = tri.ay + oy;
            vertices[ i++ ] = tri.depth;
            vertices[ i++ ] = tri.bx + ox;
            vertices[ i++ ] = tri.by + oy;
            vertices[ i++ ] = tri.depth;
            vertices[ i++ ] = tri.cx + ox;
            vertices[ i++ ] = tri.cy + oy;
            vertices[ i++ ] = tri.depth;
            rgb = WebGLSetup.toRGB( triangleColors[ tri.colorID ] );
            for( k in 0...3 ){
                colors[ c++ ] = rgb.r;
                colors[ c++ ] = rgb.g;
                colors[ c++ ] = rgb.b;
                colors[ c++ ] = colorAlpha;
                indices[ j++ ] = count++;
            }
        }
        gl.uploadDataToBuffers( program, vertices, colors, indices );
    }
    inline function render_( i: Int ):Void{
        render();
    }
    override public function render(){
        modelViewProjection = spin();
        vertices = new Array<Float>();
        indices = new Array<Int>();
        colors = new Array<Float>();
        setTriangles( triangles, cast appColors );
        super.render();
    }
    var theta: Float = 0;
    inline function spin(): Matrix4{
        return Matrix4.rotationZ( theta += Math.PI/100 ).multmat( Matrix4.rotationY( theta ) );
    }
    
}