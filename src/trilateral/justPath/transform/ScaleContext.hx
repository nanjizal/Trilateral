package trilateral.justPath.transform;
import trilateral.justPath.IPathContext;
class ScaleContext implements IPathContext {
    public var pathContext: IPathContext;
    public var sx: Float;
    public var sy: Float;
    public function new( pathContext_: IPathContext, sx_: Float, sy_: Float ){
        pathContext = pathContext_;
        sx = sx_;
        sy = sy_;
    }
    public inline
    function moveTo( x: Float, y: Float ){
        pathContext.moveTo( x*sx, y*sy );
    }
    public inline
    function lineTo( x: Float, y: Float ){
        pathContext.lineTo( x*sx, y*sy );
    }
    public inline
    function quadTo( x1: Float, y1: Float, x2: Float, y2: Float ){
        pathContext.quadTo( x1*sx, y1*sy, x2*sx, y2*sy );
    }
    public inline
    function curveTo( x1: Float, y1: Float, x2: Float, y2: Float, x3: Float, y3: Float ): Void {
        pathContext.curveTo( x1*sx, y1*sy, x2*sx, y2*sy, x3*sx, y3*sy );
    }
}