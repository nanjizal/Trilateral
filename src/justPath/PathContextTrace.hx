package justPath;

class PathContextTrace implements IPathContext {
    public function new(){
    
    }
    public function moveTo( x: Float, y: Float ): Void{
        trace( 'moveTo( $x, $y );' );
    }
    public function lineTo( x: Float, y: Float ): Void{
        trace( 'lineTo( $x, $y );' );
    }
    public function quadTo( x1: Float, y1: Float, x2: Float, y2: Float ): Void{
        trace( 'quadTo( $x1, $y1, $x2, $y2 );');
    }
    public function curveTo( x1: Float, y1: Float, x2: Float, y2: Float, x3: Float, y3: Float ): Void{
        trace( 'curveTo( $x1, $y1, $x2, $y2, $x3, $y3 );');
    }
}
