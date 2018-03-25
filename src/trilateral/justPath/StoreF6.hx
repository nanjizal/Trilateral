package trilateral.justPath;

class StoreF6{
    var l: Int = 0;
    public var s0: Null<Float>;
    public var s1: Null<Float>;
    public var s2: Null<Float>;
    public var s3: Null<Float>;
    public var s4: Null<Float>;
    public var s5: Null<Float>;
    public var s6: StoreF6;
    public function new(){}
    inline public function clear(){
        l = 0;
        s0 = null;
        s1 = null;
        s2 = null;
        s3 = null;
        s4 = null;
        s5 = null;
        s6 = null;
    }
    inline public function length(): Int {
        return l;
    }
    inline public function push( v: Null<Float> ){
        switch( l ){
            case 0:
                s0 = v;
            case 1:
                s1 = v;
            case 2:
                s2 = v;
            case 3:
                s3 = v;
            case 4:
                s4 = v;
            case 5: 
                s5 = v;
            default:
                if( s6 == null ) s6 = new StoreF6();
                s6.push( v );
        }
        l++;
    }
    inline public function pop(){
        var out: Null<Float> = null;
        switch( l ){
            case 0:
                out = s0;
                s0 = null;
            case 1:
                out = s1;
                s1 = null;
            case 2:
                out = s2;
                s2 = null;
            case 3:
                out = s3;
                s3 = null;
            case 4:
                out = s4;
                s4 = null;
            case 5:
                out = s5; 
                s5 = null;
            default:
                if( s6 != null ) s6.pop();
        }
        l--;
        return out;
    }
    
    inline public function unshift( v: Null<Float> ){
        if( s6 == null ) s6 = new StoreF6();
        s6.unshift( s5 );
        s5 = s4;
        s4 = s3;
        s3 = s2;
        s2 = s1;
        s0 = v;
        l++;
    }
    inline public function shift(): Null<Float>{
        var out = s0;
        if( l != 0 ){
            s0 = s1;
            s1 = s2;
            s2 = s3;
            s3 = s4;
            s4 = s5;
            s5 = null;
            if( s6 != null ) s5 = s6.shift();
            l--;
        }
        return out;
    }
    inline public function toString(): String{
        return if( s6 == null ){
            '$s0, $s1, $s2, $s3, $s4, $s5';
        } else {
            '$s0, $s1, $s2, $s3, $s4, $s5' + s6.toString();
        }
    }
    inline public function populatedToString(): String{
        var out: String = '';
        switch( l - 1 ){
            case 0:
                out = '$s0';
            case 1:
                out = '$s0, $s1';
            case 2:
                out = '$s0, $s1, $s2';
            case 3:
                out = '$s0, $s1, $s2, $s3';
            case 4:
                out = '$s0, $s1, $s2, $s3, $s4';
            case 5: 
                out = '$s0, $s1, $s2, $s3, $s4, $s5';
            default:
                out = '$s0, $s1, $s2, $s3, $s4, $s5';
                if( s6 != null ){
                    out = out + s6.populatedToString();
                } 
        }
        return out;
    }
    var count = 0;
    inline public function hasNext() {
          return count < l + 1;
    }
    inline public function resetIterator(){
        count = 0;
        if( s6 != null ) s6.resetIterator();
    }
    inline public function next() {
        var out: Null<Float> = null;
        switch( count ){
            case 0:
                out = s0;
            case 1:
                out = s1;
            case 2:
                out = s2;
            case 3:
                out = s3;
            case 4:
                out = s4;
            case 5:
                out = s5; 
            default:
                out = s6.next();
        }
        count++;
        return out;
    }
    inline public function first(): Null<Float>{
        return s0;
    }
    inline public function last(): Null<Float>{
        var out: Null<Float> = null;
        switch( l ){
            case 0:
                out = s0;
            case 1:
                out = s1;
            case 2:
                out = s2;
            case 3:
                out = s3;
            case 4:
                out = s4;
            case 5:
                out = s5; 
            default:
                out = s6.last();
        }
        return out;
    }
    inline public function penultimate(): Null<Float>{
        var out: Null<Float> = null;
        switch( l-1 ){
            case 0:
                out = s0;
            case 1:
                out = s1;
            case 2:
                out = s2;
            case 3:
                out = s3;
            case 4:
                out = s4;
            case 5:
                out = s5; 
            default:
                out = s6.penultimate();
        }
        return out;
    }
    inline public function toArray(){
        var arr = new Array<Null<Float>>();
        count = 0;
        // not implemented for s6... not sure on this one... maybe not using.
        for( i in this ){
            arr.push( i );
        }
    }
}
