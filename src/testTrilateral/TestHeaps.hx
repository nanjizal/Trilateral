package testTrilateral;
import h2d.Graphics;
import khaMath.Matrix4;
import hxd.Key in K;
import testTrilateral.TrilateralTest;
import trilateral.tri.Triangle;
class TestHeaps extends hxd.App {
        var g: h2d.Graphics; 
        var trilateralTest: TrilateralTest;
        public inline static var stageRadius: Int = 570;
        override function init() {
            g = new h2d.Graphics(s2d);
            // does not need drawing every frame unless spinning
            trilateralTest =  new TrilateralTest( stageRadius, setMatrix, setAnimate );
            trilateralTest.setup();
            renderTriangles();
        }
        var animate: Bool = false;
        public inline
        function setAnimate(){
            animate = true;
        }
        public inline
        function setMatrix( matrix4: Matrix4 ): Void {
            // not implemented modelViewProjection = matrix4;
        }
        inline
        function renderTriangles(){
            var tri: Triangle;
            var s = 1.8;
            var ox = 20;
            var oy = 20;
            g.clear();
            var triangles = trilateralTest.triangles;
            var gameColors = trilateralTest.appColors;
            for( i in 0...triangles.length ){
                tri = triangles[ i ];
                trace( tri.ax + ' ' + tri.ay );
                g.beginFill( gameColors[ tri.colorID ] );
                g.lineTo( ox + tri.ax * s, oy + tri.ay * s );
                g.lineTo( ox + tri.bx * s, oy + tri.by * s );
                g.lineTo( ox + tri.cx * s, oy + tri.cy * s );
                g.endFill();
            }
        }
        override function update( dt: Float ) {
            if( K.isDown( K.UP ) ){
                // 
            }
            if( K.isDown( K.DOWN ) ){
                // 
            }
            if( K.isDown( K.LEFT ) ) {
                // 
            } else if( K.isDown( K.RIGHT ) ) {
                // 
            }
            if( animate ) renderTriangles();
        }
        static function main() {
            new TestHeaps();
        }
    }