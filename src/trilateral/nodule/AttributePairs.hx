package trilateral.nodule;

@:forward
abstract AttributePairs( Array<{ name: String,value: String }> ) from Array<{ name: String,value: String }>  to Array<{ name: String,value: String }>  {
    inline public function new( ?v: Array<{ name: String,value: String }> ) {
        if( v == null ) v = getEmpty();
        this = v;
    }
    /**
     * allow simple creation of empty AttributePair
     * @return      ArrayPair
     **/
    public inline static 
    function getEmpty(){
        return new AttributePairs( new Array<{ name: String,value: String }>() );
    }
    /**
     * @return      verbose string representation
     **/
    public function toString() {
        var out = ' ';
        var vp: { name: String, value: String };
        for( i in 0...this.length ){
            vp = this[i];
            out += vp.name + "='" + vp.value + "' ";
        }
        out = out.substr( 0, out.length - 1 );
        return out;
    }
}