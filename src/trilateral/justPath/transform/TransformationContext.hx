package trilateral.justPath.transform;
import trilateral.justPath.IPathContext;
class TransformationContext implements IPathContext {
    public var pathContext: IPathContext;
    public var m3: M3;
    public function new( pathContext_: IPathContext, m3_: M3 ){
        pathContext = pathContext_;
        m3 = m3_;
    }
    public inline
    function moveTo( x: Float, y: Float ){
        m3.transform( x, y );
        x = m3.x;
        y = m3.y;
        pathContext.moveTo( x, y );
    }
    public inline
    function lineTo( x: Float, y: Float ){
        m3.transform( x, y );
        x = m3.x;
        y = m3.y;
        pathContext.lineTo( x, y );
    }
    public inline
    function quadTo( x1: Float, y1: Float, x2: Float, y2: Float ){
        m3.transform( x1, y1 );
        x1 = m3.x;
        y1 = m3.y;
        m3.transform( x2, y2 );
        x2 = m3.x;
        y2 = m3.y;
        pathContext.quadTo( x1, y1, x2, y2 );
    }
    public inline
    function curveTo( x1: Float, y1: Float, x2: Float, y2: Float, x3: Float, y3: Float ): Void {
        m3.transform( x1, y1 );
        x1 = m3.x;
        y1 = m3.y;
        m3.transform( x2, y2 );
        x2 = m3.x;
        y2 = m3.y;
        m3.transform( x3, y3 );
        x2 = m3.x;
        y2 = m3.y;
        pathContext.curveTo( x1, y1, x2, y2, x3, y3 );
    }
}