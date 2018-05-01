package trilateral.parsing.svg;
@:forward
abstract Path( Path_ ) from Path_ to Path_ {
    public inline function new( val: Path_ ){
        this = val;
    }
    public inline function attributeAdd( at: { name: String, value: String } ){
        switch( at.name ){
            case 'id':
                this.id            = at.value;
            case 'd':
                this.d             = at.value;
            case 'fill':
                this.fill          = at.value;
            case 'stroke-width':
                this.stroke_width  = at.value;
            case 'stroke':
                this.stroke        = at.value;
            case '_':
                trace( 'path attribute ' + at.name + ' not found ' );
        }
    }
}
typedef Path_ = {
        ?id:           String
    ,   ?d:            String
    ,   ?fill:         SharpColor
    ,   ?stroke_width: Stroke_Width
    ,   ?stroke:       SharpColor
}