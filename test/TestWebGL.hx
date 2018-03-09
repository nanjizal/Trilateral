package;
import js.Browser;
import khaMath.Matrix4;
import htmlHelper.webgl.WebGLSetup;
import js.html.Event;
import js.html.KeyboardEvent;
import js.html.MouseEvent;
import htmlHelper.tools.AnimateTimer; 

import trilateral.tri.Triangle;
import trilateral.tri.TrilateralArray;
import trilateral.geom.Contour;
import trilateral.tri.TriangleArray;
import trilateral.tri.TrilateralPair;
import trilateral.geom.Algebra;

import trilateral.path.Crude;         // just overlap nothing between very dirty
import trilateral.path.RoundEnd;      // create isolated rounded lines not ideal as end of each line overlap but very robust.
import trilateral.path.MediumOverlap; // when the lines overlap slightly
import trilateral.path.Medium;        // this is for triangles between angles
import trilateral.path.FineOverlap;   // when the lines overlap slightly
import trilateral.path.Fine;          // this is triangles with curved corners
import trilateral.path.FillOnly;      // no drawing this is just useful if you want the shape without drawing the contour.

import trilateral.helper.Shapes;
import trilateral.helper.AppColors;

import justPath.SvgPath;
import justPath.PathContextTrace;

import fracs.Angles;
import trilateral.polys.Poly;
import trilateral.geom.Point;

#if trilateral_includeSegments
import trilateral.segment.SixteenSeg;
import trilateral.segment.SevenSeg;
#end

using htmlHelper.webgl.WebGLSetup;

class TestWebGL extends WebGLSetup {
    var webgl: WebGLSetup;
    var appColors:         Array<AppColors> = [ Black, Red, Orange, Yellow, Green, Blue, Indigo, Violet
                                            , LightGrey, MidGrey, DarkGrey, NearlyBlack, White
                                            , BlueAlpha, GreenAlpha, RedAlpha ];
    public function findColorID( col: AppColors ){
        return appColors.indexOf( col );
    }
    var triangles: TriangleArray;
    var centre:         Point;
    var bottomLeft:     Point;
    var bottomRight:    Point;
    var topLeft:        Point;
    var topRight:       Point;
    
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
    var scale = 0.002;
    public inline static var stageRadius: Int = 570;
    var quarter: Float;
    public function new(){
        super( stageRadius*2, stageRadius*2 );
        scale = 1/(stageRadius);
        var dark = 0x18/256;
        bgRed   = dark;
        bgGreen = dark;
        bgBlue  = dark;
        centre          = { x: stageRadius, y: stageRadius };
        quarter         = stageRadius/2;
        bottomLeft      = { x: stageRadius - quarter, y: stageRadius + quarter };
        bottomRight     = { x: stageRadius + quarter, y: stageRadius + quarter };
        topLeft         = { x: stageRadius - quarter, y: stageRadius - quarter };
        topRight        = { x: stageRadius + quarter, y: stageRadius - quarter };
        draw();
        setupProgram( vertex, fragment );
        modelViewProjection = Matrix4.identity();
        // does not need drawing every frame unless spinning
         AnimateTimer.create();
         AnimateTimer.onFrame = render_;
        render();
    }
    #if trilateral_includeSegments
    function addSixteen(){
        var sixteen = new SixteenSeg( 20, 30 );
        sixteen.add( 'Trilateral', 10., 10. );
        triangles.addArray( 12
                        ,   sixteen.triArr
                        ,   appColors.indexOf( Orange ) );
    }
    function addSeven(){
        var seven = new SevenSeg( 8, 12 );//0.050, 0.080 );
        seven.addDigit( 0, 30, 45 );
        seven.addNumber( 123456780, 30, 65 );
        seven.addString( '0123456789', 30, 85 );
        triangles.addArray( 12
                        ,   seven.triArr
                        ,   appColors.indexOf( Green ) );
    }
    #end
    function addShapes(){
        var size = 80;
        var shapes = new Shapes( triangles, appColors );
        shapes.star( ( bottomLeft.x + centre.x )/2, ( bottomLeft.y + centre.y )/2,      size,  Orange  );
        shapes.diamond( ( topLeft.x + centre.x )/2, ( topLeft.y + centre.y )/2,     0.7*size,  Yellow  );
        shapes.diamondOutline( ( topLeft.x + centre.x )/2
                                                 , ( topLeft.y + centre.y )/2,  0.7*size, 6,   MidGrey );
        shapes.square( ( bottomRight.x + centre.x )/2
                                                 , ( bottomRight.y + centre.y )/2,  0.7*size,  Green   );
        shapes.squareOutline( ( bottomRight.x + centre.x )/2
                                            , ( bottomRight.y + centre.y )/2, 0.7*size, 6,     MidGrey );
        shapes.rectangle( centre.x - 100, centre.y - 50,                        size*2, size,  Blue    );
        shapes.circle( ( topRight.x + centre.x )/2, ( topRight.y + centre.y )/2,        size,  Indigo  );
        shapes.spiralLines( centre.x, centre.y, 15, 60, 0.08, 0.05,                            Red     );
        shapes.roundedRectangle( topLeft.x - size
                              ,( topLeft.y + bottomLeft.y )/2 - size/2, size*2, size, 30,      Violet  );
        shapes.roundedRectangleOutline( topLeft.x - size
                              ,( topLeft.y + bottomLeft.y )/2 - size/2, size*2, size,  6, 30,  MidGrey );
    }
    function addBird(){
        //var path = new RoundEnd(); // currently Fine has issues.
        //var path = new MediumOverlap( null, null, both ); // overlap triangles between, and round at 
                                                            // beginning posible not at end because need move.
        var path = new Fine( null, null, both );
        // var path = new FillOnly();
        //var path = new Crude();
        //var path = new Medium();
        //var path = new Fine();
        
        path.width = 1;
        var p = new SvgPath( path );
        p.parse( bird_d, 0, 0, 1.5, 1.5 );
        triangles.addArray( 6
                        ,   path.trilateralArray
                        ,   8 );
        
    }
    function addQuadCurve(){
        //var path = new RoundEnd();
        var path = new FineOverlap( null, null, both );
        path.width = 2;
        path.widthFunction = function( width: Float, x: Float, y: Float, x_: Float, y_: Float ): Float{
            return width+0.008;
        }
        var p = new SvgPath( path );
        p.parse( quadtest_d, -100, 300, 1, 1 );
        triangles.addArray( 7
                        ,   path.trilateralArray
                        ,   1 );
    }
    function addCubicCurve(){
        //var path = new RoundEnd();
        var path = new Fine( null, null, both );
        path.width = 1;
        path.widthFunction = function( width: Float, x: Float, y: Float, x_: Float, y_: Float ): Float{
            return width+0.008;
        }
        var p = new SvgPath( path );
        p.parse( cubictest_d, -50, 500, 1, 1 );
        triangles.addArray( 7
                        ,   path.trilateralArray
                        ,   5 );
    }
    function addPaths(){
        addBird();
        addQuadCurve();
        addCubicCurve();
    }
    public function addJoinTestForwards(){
        var path = new Fine( null, null, both );
        path.width = 20;
        // forwards
        path.moveTo( 200, 450 );
        path.lineTo( 700, 450 );
        path.lineTo( 700, 700 );
        path.lineTo( 450, 750);
        path.lineTo( 450, 700 );
        path.lineTo( 200, 50);
        path.lineTo( 150, 450 );
        path.moveTo( 0.,0. ); // required to make it put endCap
        triangles.addArray( 10
                        ,   path.trilateralArray
                        ,   appColors.indexOf( Orange ) );
    }
    
    public function addJoinTestBackwards(){
        var path = new Fine( null, null, both );
        path.width = 20;
        // backwards
        path.moveTo( 150, 450 );
        path.lineTo( 200, 50);
        path.lineTo( 450, 700 );
        path.lineTo( 450, 750);
        path.lineTo( 700, 700 );
        path.lineTo( 700, 450 );
        path.lineTo( 200, 450 );
        path.moveTo( 0.,0. ); // required to make it put endCap
        triangles.addArray( 10
                        ,   path.trilateralArray
                        ,   appColors.indexOf( Orange ) );
    }
    
    public function pieTests(){
        var pieRadius = quarter/3;
        triangles.addArray( 0
                        ,   Poly.pie( topLeft.x, topLeft.y, pieRadius, Math.PI, Math.PI/16, CLOCKWISE )
                        ,   1 );
        triangles.addArray( 0
                        ,   Poly.pie( topRight.x, topRight.y, pieRadius, Math.PI, Math.PI/16, ANTICLOCKWISE )
                        ,   2 );
        triangles.addArray( 0
                        ,   Poly.pie( bottomLeft.x, bottomLeft.y, pieRadius, Math.PI, Math.PI/16, SMALL )
                        ,   3 );
        triangles.addArray( 0
                        ,   Poly.pie( bottomRight.x, bottomRight.y, pieRadius, Math.PI, Math.PI/16, LARGE )
                        ,   4 );
        
    }
    
    public function pieArc(){
        var pieRadius = quarter/3;
        triangles.addArray( 0
                        ,   Poly.arc( topLeft.x, topLeft.y, pieRadius + 40, 30, Math.PI, Math.PI/16, CLOCKWISE )
                        ,   2 );
        triangles.addArray( 0
                        ,   Poly.arc( topRight.x, topRight.y, pieRadius + 40, 30, Math.PI, Math.PI/16, ANTICLOCKWISE )
                        ,   3 );
        triangles.addArray( 0
                        ,   Poly.arc( bottomLeft.x, bottomLeft.y, pieRadius + 40, 30, Math.PI, Math.PI/16, SMALL )
                        ,   4 );
        triangles.addArray( 0
                        ,   Poly.arc( bottomRight.x, bottomRight.y, pieRadius + 40, 30, Math.PI, Math.PI/16, LARGE )
                        ,   5 );
        
    }
    
    public function draw(){
        triangles = new TriangleArray();
        addPaths();
        pieTests();
        pieArc();
        addShapes();
        addJoinTestForwards();
        
        #if trilateral_includeSegments
        addSixteen();
        addSeven();
        #end
    }
    public function setTriangles( triangles: Array<Triangle>, triangleColors:Array<UInt> ) {
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