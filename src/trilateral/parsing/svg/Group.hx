package trilateral.parsing.svg;
import trilateral.nodule.Nodule;
import trilateral.drawing.svg.*;
@:forward
abstract Group( Group_ ) from Group_ to Group_ {
    public inline function new( val: Group_ ){
        this = val;
    }
    public inline function attributeAdd( at: { name: String,value: String } ){
        switch( at.name ){
            case 'id':
                this.id            = at.value;
            case 'xmlns':
                this.xmlns         = at.value;
            case 'viewBox':
                this.viewBox       = at.value;
            case 'version':
                this.version       = at.value;
            case 'fill':
                this.fill          = at.value;
            case 'transform':
                this.transform     = at.value;
            case 'stroke-width':
                this.stroke_width  = at.value;
            case 'stroke':
                this.stroke        = at.value;
            case _:
                trace( 'group attribute ' + at.name + ' not found ' );
        }
    }
}
typedef Group_ = {
        ?id:           String
    ,   ?xmlns:        String
    ,   ?viewBox:      ViewBox
    ,   ?version:      Version
    ,   ?fill:         SharpColor
    ,   ?transform:    Matrix
    ,   ?stroke_width: Stroke_Width
    ,   ?stroke:       SharpColor
    ,   ?firstChild:   Nodule
}
