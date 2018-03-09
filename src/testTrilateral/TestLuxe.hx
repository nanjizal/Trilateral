package testTrilateral;
import luxe.Sprite;
import luxe.Color;
import phoenix.Batcher.PrimitiveType;
import phoenix.Vector;
import phoenix.geometry.Vertex;
import luxe.Input;
import luxe.Vector;
import lsystem.*;
import phoenix.geometry.Geometry;
import luxe.Color;
import testTrilateral.TrilateralTest;
import trilateral.tri.Triangle;
import trilateral.tri.TriangleArray;
import testTrilateral.TrilateralTest;
import khaMath.Matrix4;
class TestLuxe extends luxe.Game {
    var trilateralTest:     TrilateralTest;
    var shape: Geometry;
    var leftDown:           Bool = false;
    var rightDown:          Bool = false;
    var downDown:           Bool = false;
    var upDown:             Bool = false;
    var stageRadius:        Float = 570;
    override function ready() {
        trilateralTest =  new TrilateralTest( stageRadius, setMatrix, setAnimate );
        trilateralTest.setup();
        renderToTriangles();
    }
    var animate: Bool = false;
    public inline
    function setAnimate(){
        animate = true;
    }
    public inline
    function setMatrix( matrix4: Matrix4 ): Void {
        // not implemented
    }
    inline
    function renderToTriangles(){
        if( shape != null ) shape.drop();
        shape = new Geometry({
                primitive_type:PrimitiveType.triangles,
                batcher: Luxe.renderer.batcher
        });
        //shape.lock = true; ??
        var tri: Triangle;
        var color: Color;
        var s = 1.;//500;
        var ox = 1.;//500;
        var oy = 1.;//250;
        var triangles = trilateralTest.triangles;
        var gameColors = trilateralTest.appColors;
        for( i in 0...triangles.length ){
            tri = triangles[ i ];
            color =  new Color().rgb( cast gameColors[ tri.colorID ] );
            shape.add( new Vertex( new Vector( ox + tri.ax * s, oy + tri.ay * s ), color ) );
            shape.add( new Vertex( new Vector( ox + tri.bx * s, oy + tri.by * s ), color ) );
            shape.add( new Vertex( new Vector( ox + tri.cx * s, oy + tri.cy * s ), color ) );
        }
    }
    override function onmousemove( event:MouseEvent ) {
        // mousemove update
    }
    override function onkeyup( e:KeyEvent ) {
        if(e.keycode == Key.escape) {
            Luxe.shutdown();
        }
        var keyCode = e.keycode;
        switch(keyCode){
            case Key.left:  
                leftDown    = false;
            case Key.right: 
                rightDown   = false;
            case Key.up:    
                upDown      = false;
            case Key.down:  
                downDown    = false;
            default: 
                
        }
    }
    override function onkeydown( e:KeyEvent ) {
        var keyCode = e.keycode;
        switch(keyCode){
            case Key.left:  
                leftDown    = true;
            case Key.right: 
                rightDown   = true;
            case Key.up:    
                upDown      = true;
            case Key.down:  
                downDown    = true;
            default: 
                
        }
    }
    inline
    function updateMovement(): Void {
        if( upDown ){
            // 
        } else if( downDown ){
            // 
        }
        if( leftDown ) {
            // 
        } else if( rightDown ) {
            // 
        }
        leftDown    = false;
        rightDown   = false;
        downDown    = false;
        upDown      = false;
    }
    
    override function update( delta:Float ) {
        if( animate ) renderToTriangles();
    }
    override function config( config:luxe.GameConfig ) {
        config.window.width = 1024;
        config.window.height = 768;
        config.render.antialiasing = 4;
        return config;
    }
}