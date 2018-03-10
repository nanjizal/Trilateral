package justPath;

interface IPathContext{
    public function moveTo( x: Float, y: Float ): Void;
    public function lineTo( x: Float, y: Float ): Void;
    public function quadTo( x1: Float, y1: Float, x2: Float, y2: Float ): Void;
    public function curveTo( x1: Float, y1: Float, x2: Float, y2: Float, x3: Float, y3: Float ): Void;
}
