package testTrilateral;
import khaMath.Matrix4;
import js.Browser;
import htmlHelper.canvas.CanvasWrapper;
import js.html.CanvasRenderingContext2D;
import htmlHelper.tools.AnimateTimer; 
import justDrawing.Surface;
import js.html.Event;
import js.html.KeyboardEvent;
import js.html.MouseEvent;
import trilateral.tri.Triangle;
import trilateral.tri.TriangleArray;
import testTrilateral.TrilateralTest;
import khaMath.Matrix4;
class TestCanvas {
    var surface:            Surface;
    var trilateralTest:     TrilateralTest;
    var stageRadius:        Float = 570;
    public static function main(){ new TestCanvas(); } public function new(){
        var canvas = new CanvasWrapper();
        canvas.width = 1024;
        canvas.height = 768;
        Browser.document.body.appendChild( cast canvas );
        surface = new Surface( canvas.getContext2d() );
        trilateralTest =  new TrilateralTest( stageRadius, setMatrix, setAnimate );// does not need drawing every frame unless spinning
        trilateralTest.setup();
        render(0);
        Browser.document.onkeydown = keyDown;
        Browser.document.onkeyup = keyUp;
    }
    public inline
    function setMatrix( matrix4: Matrix4 ){
        // not implemented yet
    }
    public inline
    function setAnimate(){
        AnimateTimer.create();
        AnimateTimer.onFrame = render;
    }
    inline
    function render( i: Int ):Void{
        trilateralTest.render();
        var tri: Triangle;
        var s = 1.;
        var ox = 0.;
        var oy = 0.;
        var g = surface;
        g.beginFill( 0x181818, 1. );
        g.lineStyle( 0., 0x000000, 0. );
        g.drawRect( 1, 1, 1024-2, 768-2 );
        g.endFill();
        var triangles = trilateralTest.triangles;
        var triangleColors = trilateralTest.appColors;
        for( i in 0...triangles.length ){
            tri = triangles[ i ];
            if( tri.mark != 0 ){
                g.beginFill( triangleColors[ tri.mark ] );
            } else {
                g.beginFill( triangleColors[ tri.colorID ] );
            }
            g.drawTri( [   ox + tri.ax * s, oy + tri.ay * s
                        ,  ox + tri.bx * s, oy + tri.by * s
                        ,  ox + tri.cx * s, oy + tri.cy * s ] );
            g.endFill();
        }
    }
    
    var leftDown:           Bool = false;
    var rightDown:          Bool = false;
    var downDown:           Bool = false;
    var upDown:             Bool = false;
    inline
    function keyDown( e: KeyboardEvent ) {
        e.preventDefault();
        var keyCode = e.keyCode;
        switch( keyCode ){
            case KeyboardEvent.DOM_VK_LEFT:
                leftDown    = true;
            case KeyboardEvent.DOM_VK_RIGHT:
                rightDown   = true;
            case KeyboardEvent.DOM_VK_UP:
                upDown      = true;
            case KeyboardEvent.DOM_VK_DOWN:
                downDown    = true;
            default: 
        }
        update(); // not sure if this ideal?
    }
    inline
    function keyUp( e: KeyboardEvent ) {
        e.preventDefault();
        var keyCode = e.keyCode;
        switch(keyCode){
            case KeyboardEvent.DOM_VK_LEFT:
                leftDown    = false;
            case KeyboardEvent.DOM_VK_RIGHT:
                rightDown   = false;
            case KeyboardEvent.DOM_VK_UP:
                upDown      = false;
            case KeyboardEvent.DOM_VK_DOWN:
                downDown    = false;
            default: 
        }
    }
    inline
    function update(): Void {
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
}