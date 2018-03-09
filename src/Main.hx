package;
import kha.Scheduler;
import kha.Color;
import kha.graphics4.VertexStructure;
import kha.graphics4.VertexBuffer;
import kha.graphics4.IndexBuffer;
import kha.graphics4.FragmentShader;
import kha.graphics4.VertexShader;
import kha.graphics4.VertexData;
import kha.graphics4.Usage;
import kha.graphics4.ConstantLocation;
import kha.graphics4.CompareMode;
//import kha.graphics2.ImageScaleQuality;
import kha.graphics2.Graphics;
import kha.graphics4.TextureFormat;
//import kha.math.Matrix4;
import kha.math.FastMatrix4;
import kha.math.FastVector3;
import kha.graphics4.PipelineState;
import kha.Shaders;
import kha.Assets;
import kha.Framebuffer;
import kha.Image;
import kha.input.Keyboard;
import kha.input.Mouse;
import kha.input.KeyCode;
import kha.Scaler;
import kha.System;
import kha.graphics4.DepthStencilFormat;  
import khaMath.Matrix4;
import trilateral.tri.Triangle;
import trilateral.tri.TriangleArray;
import testTrilateral.TrilateralTest;
class Main {
    public static function main() {
        //TOD: add antiAlias; 4 ?? 
        System.init({title: "TestKha4", width: 1024, height: 768, samplesPerPixel: 4 }, function(){ new Main(); } );
    }
    var pixelLayer:         Image;
    var vectorLayer:        Image;
    var initialized:        Bool = false;
    var xPos:               Float;
    var yPos:               Float;
    var keys:               Array<Bool> = [for(i in 0...4) false];
    var trilateralTest:     TrilateralTest;
    var modelViewProjection:Matrix4;
    public function new(){
        pixelLayer = Image.createRenderTarget( 1280, 720 );
        vectorLayer = Image.createRenderTarget( 1280, 720, TextureFormat.RGBA32, DepthStencilFormat.DepthOnly, 4 );
        Keyboard.get().notify(keyDown, keyUp);
        var mouse = Mouse.get();
        mouse.notify(null, null, mouseMove, null);
        Assets.loadEverything( loadingFinished );
    }

    // An array of vertices to form a cube
    static var vertices:Array<Float> = [];
    // Array of colors for each cube vertex
    static var colors:Array<Float> = [];
    var pipeline:       PipelineState;
    var vertexBuffer:   VertexBuffer;
    var indexBuffer:    IndexBuffer;
    var mvp:            FastMatrix4;
    var mvpID:          ConstantLocation;
    var z:              Float = -1;
    var structureLength = 6;
    var scale:          Float;
    var stageRadius:    Float;
    public function setup3d():Void {
        // Define vertex structure
        var structure = new VertexStructure();
        structure.add( "pos", VertexData.Float3 );
        structure.add( "col", VertexData.Float3 );
        // Save length - we store position and color data
        

        // Compile pipeline state
        // Shaders are located in 'Sources/Shaders' directory
        // and Kha includes them automatically
        pipeline = new PipelineState();
        pipeline.inputLayout = [structure];
        pipeline.fragmentShader = Shaders.simple_frag;
        pipeline.vertexShader = Shaders.simple_vert;
        // Set depth mode
        pipeline.depthWrite = false;
        pipeline.depthMode = CompareMode.Less;
        pipeline.compile();
        
        // Get a handle for our "MVP" uniform
        mvpID = pipeline.getConstantLocation("MVP");

        // Projection matrix: 45° Field of View, 4:3 ratio, display range : 0.1 unit <-> 100 units
        var projection = FastMatrix4.perspectiveProjection(45.0, 16.0 / 9.0, 0.1, 10.0);
        // Or, for an ortho camera
        //var projection = FastMatrix4.orthogonalProjection(-10.0, 10.0, -10.0, 10.0, 0.0, 100.0); // In world coordinates
        
        // Camera matrix
        var view = FastMatrix4.lookAt(new FastVector3(0, 0, 10), // Camera is at (4, 3, 3), in World Space
                                  new FastVector3(0, 0, 0), // and looks at the origin
                                  new FastVector3(0, 1, 0) // Head is up (set to (0, -1, 0) to look upside-down)
        );

        // Model matrix: an identity matrix (model will be at the origin)
        var model = FastMatrix4.identity();
        // Our ModelViewProjection: multiplication of our 3 matrices
        // Remember, matrix multiplication is the other way around
        mvp = FastMatrix4.identity();
        mvp = mvp.multmat(projection);
        mvp = mvp.multmat(view);
        mvp = mvp.multmat(model);
        
        // vertexBufferLen = Std.int(vertices.length / 3)
        // Create vertex buffer
        vertexBuffer = new VertexBuffer(
            300000, // Vertex count - 3 floats per vertex
            structure, // Vertex structure
            Usage.DynamicUsage // Vertex data will stay the same
        );
        // indicesLen = indices.length;
        // Create index buffer
        indexBuffer = new IndexBuffer(
            300000  , // Number of indices for our cube
            Usage.DynamicUsage // Index data will stay the same
        );
    }
    
    public function updateVectors():Void {
     // Copy vertices and colors to vertex buffer
        var vbData = vertexBuffer.lock();
        for (i in 0...Std.int(vbData.length / structureLength)) {
            vbData.set( i * structureLength, vertices[i * 3] );
            vbData.set( i * structureLength + 1, vertices[i * 3 + 1] );
            vbData.set( i * structureLength + 2, vertices[i * 3 + 2] );
            vbData.set( i * structureLength + 3, colors[i * 3] );
            vbData.set( i * structureLength + 4, colors[i * 3 + 1] );
            vbData.set( i * structureLength + 5, colors[i * 3 + 2] );
        }
        vertexBuffer.unlock();
        // A 'trick' to create indices for a non-indexed vertex data
        var indices:Array<Int> = [];
        for (i in 0...Std.int(vertices.length / 3)) {
            indices.push(i);
        }
        // Copy indices to index buffer
        var iData = indexBuffer.lock();
        for (i in 0...iData.length) {
            iData[i] = indices[i];
        }
        indexBuffer.unlock();
    }
    
    var timeSlice: Float = 0;
    
    public static inline function toRGB( int: Int ) : { r: Float, g: Float, b: Float } {
        return {
            r: ((int >> 16) & 255) / 255,
            g: ((int >> 8) & 255) / 255,
            b: (int & 255) / 255,
        }
    }
    private function loadingFinished():Void{
        setup3d();
        initialized = true;
        stageRadius = 570;
        scale = 1/(stageRadius);
        trilateralTest =  new TrilateralTest( stageRadius, setMatrix, setAnimate );
        trilateralTest.setup();
        System.notifyOnRender(render);
        
        Scheduler.addTimeTask(update, 0, 1 / 60);
    }
    var allowRender: Bool = true;
    var repeat: Bool = false;
    public inline
    function setAnimate(){
        repeat = true;
    }
    public inline
    function setMatrix( matrix4: Matrix4 ): Void {
        modelViewProjection = matrix4;
    }
    
    public function keyDown(keyCode:Int):Void{
        switch(keyCode){
            case KeyCode.Left:  
                keys[0] = true;
            case KeyCode.Right: 
                keys[1] = true;
            case KeyCode.Up:    
                keys[2] = true;
            case KeyCode.Down:  
                keys[3] = true;
            default: 
                
        }
    }
    public function keyUp(keyCode:Int  ):Void{ 
        switch(keyCode){
            case KeyCode.Left:  
                keys[0] = false;
            case KeyCode.Right: 
                keys[1] = false;
            case KeyCode.Up:    
                keys[2] = false;
            case KeyCode.Down:  
                keys[3] = false;
            default: 
                
        }
    }
    function mouseMove(x:Int, y:Int, movementX:Int, movementY:Int):Void{
        //xPos = x - (ball.width / 2);
       // yPos = y - (ball.height / 2);
    }
    public function update(): Void {
        if (!initialized)
            return;
        if (keys[0])
            xPos -= 3;
        else if (keys[1])
            xPos += 3;
        if (keys[2])
            yPos -= 3;
        else if (keys[3])
            yPos += 3;
        
        
    }
    public function render(framebuffer:Framebuffer):Void {
        if (!initialized)return;
        if( allowRender ){
        vertices = new Array<Float>();
        colors = new Array<Float>();
        var w = System.windowWidth() / 2;
        var h = System.windowHeight() / 2;
        var g = framebuffer.g2;
        var tri: Triangle;
        var s = scale*5.5;//4;
        var offX = 8.0;
        var offY = 5.0;
        var toRGBs = toRGB;
        
        var triangles = trilateralTest.triangles;
        var gameColors = trilateralTest.appColors;
        
        //var adjScale: Float = 87.1;//200
        for( i in 0...triangles.length ){
            tri = triangles[ i ];
            vertices.push( s * tri.ax - offX );
            vertices.push( s * tri.ay - offY );
            vertices.push( -z );
            vertices.push( s * tri.bx - offX );
            vertices.push( s * tri.by - offY );
            vertices.push( -z );
            vertices.push( s * tri.cx - offX );
            vertices.push( s * tri.cy - offY );
            vertices.push( -z );
            var rgb = toRGBs( cast( gameColors[ tri.colorID ], Int ) );
            colors.push( rgb.r );
            colors.push( rgb.g );
            colors.push( rgb.b );
            colors.push( rgb.r );
            colors.push( rgb.g );
            colors.push( rgb.b );
            colors.push( rgb.r );
            colors.push( rgb.g );
            colors.push( rgb.b );
        }

        updateVectors();
        var g4 = vectorLayer.g4;
        var g2 = vectorLayer.g2;
        //g2.imageScaleQuality = ImageScaleQuality.High;
        g4.begin();
        g4.clear(Color.fromValue(0xff000000));
        g4.setVertexBuffer(vertexBuffer);
        g4.setIndexBuffer(indexBuffer);
        g4.setPipeline(pipeline);
        g4.setMatrix(mvpID, mvp);
        g4.drawIndexedVertices();
        g4.end();
        
        var g2 = framebuffer.g2;
        g2.begin();
        g2.clear(Color.fromValue(0xff000000));
        //g2.imageScaleQuality = ImageScaleQuality.High;
        g2.drawImage( vectorLayer, 0, 0 );
        //g2.drawImage( pixelLayer, 0, 0 );
        g2.end();
        }
        if( !repeat ) allowRender = false;
    }
        
}