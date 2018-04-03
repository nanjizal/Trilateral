package trilateral.justPath.transform;
import trilateral.justPath.IPathContext;
class TranslationContext implements IPathContext {
    public var pathContext: IPathContext;
    public var dx: Float;
    public var dy: Float;
    public function new( pathContext_: IPathContext, dx_: Float, dy_: Float ){
        pathContext = pathContext_;
        dx = dx_;
        dy = dy_;
    }
    public inline
    function moveTo( x: Float, y: Float ){
        pathContext.moveTo( x + dx, y + dy );
    }
    public inline
    function lineTo( x: Float, y: Float ){
        pathContext.lineTo( x + dx, y + dy );
    }
    public inline
    function quadTo( x1: Float, y1: Float, x2: Float, y2: Float ){
        pathContext.quadTo( x1 + dx, y1 + dy, x2 + dx, y2 + dy );
    }
    public inline
    function curveTo( x1: Float, y1: Float, x2: Float, y2: Float, x3: Float, y3: Float ): Void {
        pathContext.curveTo( x1 + dx, y1 + dy, x2 + dx, y2 + dy, x3 + dx, y3 + dy );
    }
}