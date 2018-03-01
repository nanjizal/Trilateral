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
import trilateral.pairs.Quad;
import trilateral.pairs.Line;
import trilateral.polys.Poly;
import trilateral.path.Crude;
import trilateral.path.Fine;
import justPath.SvgPath;
import justPath.PathContextTrace;
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
        super( 570*2, 570*2 );
        var dark = 0x18/256;
        bgRed   = dark;
        bgGreen = dark;
        bgBlue  = dark;
        draw();
        setupProgram( vertex, fragment );
        modelViewProjection = Matrix4.identity();
        // does not need drawing every frame unless spinning
         AnimateTimer.create();
         AnimateTimer.onFrame = render_;
        render();
    }
    public function draw(){
        triangles = new TriangleArray();
        triangles.addPair(  0
                        ,   Star.create( { x: -0.3, y: -0.3 }, 0.2 )
                        ,   2 );
        triangles.addPair(  1
                        ,   Quad.diamond( { x: -0.3, y: 0.3 }, 0.15 )
                        ,   3 );
        triangles.addPair(  2
                        ,   Quad.square( { x: 0.3, y: -0.3 }, 0.15 )
                        ,   4 );
        triangles.addPair(  3
                        ,   Quad.rectangle( { x: -0.15, y: -0.1 }, { x: 0.3, y: 0.2 } )
                        ,   5 );
        triangles.addArray( 4
                        ,   Poly.circle( { x: 0.3, y: 0.3 }, 0.1 )
                        ,   6 );
        var theta = 0.;
        var lines = 60;
        var line: TrilateralPair;
        var wid = 0.0001;
        for( i in 0...lines ){
            var px = 0.5*Math.sin( theta );
            var py = 0.5*Math.cos( theta );
            theta += (Math.PI*2)/lines;
            line = Line.create( { x: 0., y: 0. }, { x: px, y: py }, wid+= 0.0003 );
            triangles.addPair(  5
                            ,   line
                            ,   1 );
        }
        var path = new Crude();
        path.width = 0.001;
        path.widthFunction = function( width: Float, x: Float, y: Float, x_: Float, y_: Float ): Float{
            return width+0.0001;
        }
        var p = new SvgPath( path );
        p.parse( cubictest_d, -1., -0.6, 0.002, 0.002 );
        triangles.addArray( 6
                        ,   path.trilateralArray
                        ,   1 );
        path.trilateralArray = [];
        path.width = 0.001;
        path.widthFunction = function( width: Float, x: Float, y: Float, x_: Float, y_: Float ): Float{
            return width+0.001*y;
        }
        p.parse( quadtest_d, -1.2, -0.6, 0.002, 0.002 );
        //crudePath.width = 0.001;  bird not currently working properly
        //p.parse( bird_d, -0.5, -0.0, 0.0005, 0.0005 );
        // you can trace out svg points.
        // var p = new SvgPath( new PathContextTrace() );
        // p.parse( quadtest_d, -1., -0.6, 0.002, 0.002 );
        trace( path.trilateralArray );
        triangles.addArray( 6
                        ,   path.trilateralArray
                        ,   7 );
    }
    public function setTriangles( triangles: Array<Triangle>, triangleColors:Array<UInt> ) {
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
        //modelViewProjection = spin();
        vertices = new Array<Float>();
        indices = new Array<Int>();
        colors = new Array<Float>();
        setTriangles( triangles, cast appColors );
        super.render();
    }
    var theta: Float = 0;
    inline function spin(): Matrix4{
        if( theta > Math.PI/2 ) theta = -Math.PI/2;
        return Matrix4.rotationZ( theta += Math.PI/100 ).multmat( Matrix4.rotationY( theta ) );
    }
    // Test SVG data
    var quadtest_d = "M200,300 Q400,50 600,300 T1000,300";
    var cubictest_d = "M100,200 C100,100 250,100 250,200S400,300 400,200";
    var bird_d = "M210.333,65.331C104.367,66.105-12.349,150.637,1.056,276.449c4.303,40.393,18.533,63.704,52.171,79.03c36.307,16.544,57.022,54.556,50.406,112.954c-9.935,4.88-17.405,11.031-19.132,20.015c7.531-0.17,14.943-0.312,22.59,4.341c20.333,12.375,31.296,27.363,42.979,51.72c1.714,3.572,8.192,2.849,8.312-3.078c0.17-8.467-1.856-17.454-5.226-26.933c-2.955-8.313,3.059-7.985,6.917-6.106c6.399,3.115,16.334,9.43,30.39,13.098c5.392,1.407,5.995-3.877,5.224-6.991c-1.864-7.522-11.009-10.862-24.519-19.229c-4.82-2.984-0.927-9.736,5.168-8.351l20.234,2.415c3.359,0.763,4.555-6.114,0.882-7.875c-14.198-6.804-28.897-10.098-53.864-7.799c-11.617-29.265-29.811-61.617-15.674-81.681c12.639-17.938,31.216-20.74,39.147,43.489c-5.002,3.107-11.215,5.031-11.332,13.024c7.201-2.845,11.207-1.399,14.791,0c17.912,6.998,35.462,21.826,52.982,37.309c3.739,3.303,8.413-1.718,6.991-6.034c-2.138-6.494-8.053-10.659-14.791-20.016c-3.239-4.495,5.03-7.045,10.886-6.876c13.849,0.396,22.886,8.268,35.177,11.218c4.483,1.076,9.741-1.964,6.917-6.917c-3.472-6.085-13.015-9.124-19.18-13.413c-4.357-3.029-3.025-7.132,2.697-6.602c3.905,0.361,8.478,2.271,13.908,1.767c9.946-0.925,7.717-7.169-0.883-9.566c-19.036-5.304-39.891-6.311-61.665-5.225c-43.837-8.358-31.554-84.887,0-90.363c29.571-5.132,62.966-13.339,99.928-32.156c32.668-5.429,64.835-12.446,92.939-33.85c48.106-14.469,111.903,16.113,204.241,149.695c3.926,5.681,15.819,9.94,9.524-6.351c-15.893-41.125-68.176-93.328-92.13-132.085c-24.581-39.774-14.34-61.243-39.957-91.247c-21.326-24.978-47.502-25.803-77.339-17.365c-23.461,6.634-39.234-7.117-52.98-31.273C318.42,87.525,265.838,64.927,210.333,65.331zM445.731,203.01c6.12,0,11.112,4.919,11.112,11.038c0,6.119-4.994,11.111-11.112,11.111s-11.038-4.994-11.038-11.111C434.693,207.929,439.613,203.01,445.731,203.01z";
}