package;
import kha.Framebuffer;
import kha.Scheduler;
import kha.System;
import kha.Color;
import kha.Assets;
import kha.Font;
import khaMath.Matrix4;
import kha.graphics2.Graphics;
import kha.input.Keyboard;
import kha.input.Mouse;
import kha.input.KeyCode;
import testTrilateral.TrilateralTest;
import trilateral.tri.Triangle;
import trilateral.tri.TriangleArray;
class Main {
    // Kha2 example
    public static function main() {
        //TODO: add antiAlias; 4 ?? 
        System.init({title: "TestTrilateral", width: 1024, height: 768, samplesPerPixel: 4 }, function(){ new Main(); } );
    }
    var trilateralTest: TrilateralTest;
    public function new() {
        Assets.loadEverything(loadAll);
    } 
    public function loadAll() {
        // does not need drawing every frame unless spinning
        var stageRadius = 570;
        trilateralTest =  new TrilateralTest( stageRadius, setMatrix, setAnimate );
        trilateralTest.setup();
        
        System.notifyOnRender( render );
        Scheduler.addTimeTask( update, 0, 1 / 60 );
        Keyboard.get().notify( keyDown, keyUp );
        var mouse = Mouse.get();
        //Mouse.get().notify( onMouseDown, onMouseUp, onMouseMove, null );
    }
    var allowRender: Bool = true;
    var repeat: Bool = false;
    public inline
    function setAnimate(){
        repeat = true;
    }
    public inline
    function setMatrix( matrix4: Matrix4 ): Void {
        // not yet implemented modelViewProjection = matrix4;
    }
    
    function render( framebuffer: Framebuffer ): Void {
        if( allowRender ){
            trilateralTest.render();
            var g = framebuffer.g2;
            g.begin( 0xFF181818 );
            renderTriangles( g );
            g.end();
        }
        if( !repeat ) allowRender = false;
    }
    inline function renderTriangles( g: kha.graphics2.Graphics ){
        var tri: Triangle;
        var triangles = trilateralTest.triangles;
        var gameColors = trilateralTest.appColors;
        var s = 1;
        var ox = 1;
        var oy = 1;
        for( i in 0...triangles.length ){
            tri = triangles[ i ];
            g.color = cast( gameColors[ tri.colorID ], kha.Color );
            g.fillTriangle( ox + tri.ax * s, oy + tri.ay * s
                        ,   ox + tri.bx * s, oy + tri.by * s
                        ,   ox + tri.cx * s, oy + tri.cy * s );
            // g.color = cast( gameColors[ 12 ], kha.Color );
            // if( i%2 == 0 ) g.drawLine( ox + tri.bx * s, oy + tri.by * s,ox + tri.cx * s, oy + tri.cy * s,2. );
        }
    }
    var leftDown:           Bool = false;
    var rightDown:          Bool = false;
    var downDown:           Bool = false;
    var upDown:             Bool = false;
    public function keyDown( keyCode:Int ): Void {
        switch(keyCode){
            case KeyCode.Left:  
                leftDown    = true;
            case KeyCode.Right: 
                rightDown   = true;
            case KeyCode.Up:    
                upDown      = true;
            case KeyCode.Down:  
                downDown    = true;
            default: 
                
        }
    }
    public function keyUp( keyCode: Int  ): Void { 
        switch(keyCode){
            case KeyCode.Left:  
                leftDown    = false;
            case KeyCode.Right: 
                rightDown   = false;
            case KeyCode.Up:    
                upDown      = false;
            case KeyCode.Down:  
                downDown    = false;
            default: 
                
        }
    }
    // useful for debuging or... spinning 3D? :)
    //function mouseMove( x: Int, y: Int, movementX: Int, movementY: Int ): Void {
        //xPos = x - (ball.width / 2);
       // yPos = y - (ball.height / 2);
    //}
    function update(): Void {
        if( upDown ){
            // rotate( 1 );
        } else if( downDown ){
            // move(  0, 1 );
        }
        if( leftDown ) {
            // move( -1, 0 );
        } else if( rightDown ) {
            // move(  1, 0 );
        }
        leftDown    = false;
        rightDown   = false;
        downDown    = false;
        upDown      = false;
    }
}