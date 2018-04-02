package trilateral.justPath.transform;
import trilateral.justPath.IPathContext;
class ScaleTranslateContext implements IPathContext {
    public var pathContext: IPathContext;
    public var dx: Float;
    public var dy: Float;
    public var sx: Float;
    public var sy: Float;
    public function new( pathContext_: IPathContext, dx_: Float, dy_: Float, sx_: Float, sy_: Float ){
        pathContext = pathContext_;
        dx = dx_;
        dy = dy_;
        sx = sx_;
        sy = sy_;
    }
    public inline
    function moveTo( x: Float, y: Float ){
        pathContext.moveTo( x*sx + dx, y*sy + dy );
    }
    public inline
    function lineTo( x: Float, y: Float ){
        pathContext.lineTo( x*sx + dx, y*sy + dy );
    }
    public inline
    function quadTo( x1: Float, y1: Float, x2: Float, y2: Float ){
        pathContext.quadTo( x1*sx + dx, y1*sy + dy, x2*sx + dx, y2*sy + dy );
    }
    public inline
    function curveTo( x1: Float, y1: Float, x2: Float, y2: Float, x3: Float, y3: Float ): Void {
        pathContext.curveTo( x1*sx + dx, y1*sy + dy, x2*sx + dx, y2*sy + dy, x3*sx + dx, y3*sy + dy );
    }
}