package trilateral.nodule;
import trilateral.nodule.ArrayPair;
typedef ValuePair = {
    var name: String;
    var value: String;
}

@:forward
abstract ArrayPair( Array<{ name: String,value: String }> ) from Array<{ name: String,value: String }>  to Array<{ name: String,value: String }>  {
    inline public function new( ?v: Array<{ name: String,value: String }> ) {
        if( v == null ) v = getEmpty();
        this = v;
    }
    /**
     * allow simple creation of empty ArrayPair
     * @return      ArrayPair
     **/
    public inline static 
    function getEmpty(){
        return new ArrayPair( new Array<{ name: String,value: String }>() );
    }
    /**
     * @return      verbose string representation
     **/
    public function toString() {
        var out = '( ';
        var vp: { name: String,value: String };
        for( i in 0...this.length ){
            vp = this[i];
            out += 'name: ' + vp.name + ', value: ' + vp.value + ', ';
        }
        out = out.substr( 0, out.length - 2 );
        out += ' )';
        return out;
    }
}