package;
import js.Browser;
import khaMath.Matrix4;
import htmlHelper.webgl.WebGLSetup;
import js.html.Event;
import js.html.KeyboardEvent;
import js.html.MouseEvent;
import htmlHelper.tools.AnimateTimer; 
import TrilateralTest;
import trilateral.tri.Triangle;
using htmlHelper.webgl.WebGLSetup;

class TestWebGL extends WebGLSetup {
    var webgl:          WebGLSetup;
    var trilateralTest: TrilateralTest;
    var scale:          Float;
    // Generic triangle drawing Shaders
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
    public static function main(){ new TestWebGL(); }
    public inline static var stageRadius: Int = 570;
    public function new(){
        super( stageRadius*2, stageRadius*2 );
        scale = 1/(stageRadius);
        darkBackground();
        trilateralTest =  new TrilateralTest( stageRadius );
        trilateralTest.setup();
        setupProgram( vertex, fragment );
        modelViewProjection = Matrix4.identity();
        // does not need drawing every frame unless spinning
         AnimateTimer.create();
         AnimateTimer.onFrame = render_;
        render();
    }
    function darkBackground(){
        var dark = 0x18/256;
        bgRed   = dark;
        bgGreen = dark;
        bgBlue  = dark;
    }
    function setTriangles( triangles: Array<Triangle>, triangleColors:Array<UInt> ) {
        var rgb: RGB;
        var colorAlpha = 1.;
        var tri: Triangle;
        var count = 0;
        var i: Int = 0;
        var c: Int = 0;
        var j: Int = 0;
        var ox: Float = -1.0;
        var oy: Float = 1.0;
        var no: Int = 0;
        for( tri in triangles ){
            vertices[ i++ ] = tri.ax*scale + ox;
            vertices[ i++ ] = -tri.ay*scale + oy;
            vertices[ i++ ] = tri.depth;
            vertices[ i++ ] = tri.bx*scale + ox;
            vertices[ i++ ] = -tri.by*scale + oy;
            vertices[ i++ ] = tri.depth;
            vertices[ i++ ] = tri.cx*scale + ox;
            vertices[ i++ ] = -tri.cy*scale + oy;
            vertices[ i++ ] = tri.depth;
            if( tri.mark != 0 ){
                rgb = WebGLSetup.toRGB( triangleColors[ tri.mark ] );
            } else {
                rgb = WebGLSetup.toRGB( triangleColors[ tri.colorID ] );
            }
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
        //modelViewProjection = spin();
        vertices = new Array<Float>();
        indices = new Array<Int>();
        colors = new Array<Float>();
        trilateralTest.render(); // not currently needed
        setTriangles( trilateralTest.triangles, cast trilateralTest.appColors );
        super.render();
    }
    var theta: Float = 0;
    inline function spin(): Matrix4{
        if( theta > Math.PI/2 ) theta = -Math.PI/2;
        return Matrix4.rotationZ( theta += Math.PI/100 ).multmat( Matrix4.rotationY( theta ) );
    }
}