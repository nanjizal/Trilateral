package trilateral.bits;
import haxe.io.Bytes;
import haxe.io.BytesOutput;

// untested
enum Toggle {
    TOGGLE;
}
@:forward
abstract Binary8( Int ) from Int {
    inline public function new ( ?i: Int = 0 ){
        this = i;
    }
    
    public inline function getValue(): Int {
        return this;
    }
    public var d0( get, set ): Bool;
    public var d1( get, set ): Bool;
    public var d2( get, set ): Bool;
    public var d3( get, set ): Bool;
    public var d4( get, set ): Bool;
    public var d5( get, set ): Bool;
    public var d6( get, set ): Bool;
    public var d7( get, set ): Bool;
    inline
    function get_d0():Bool {
        return this & 0x80 == 0x80;
    }
    inline
    function get_d1():Bool {
        return this & 0x40 == 0x40;
    }
    inline 
    function get_d2():Bool {
        return this & 0x20 == 0x20;
    }
    inline
    function get_d3():Bool {
        return this & 0x10 == 0x10;
    }
    inline
    function get_d4():Bool {
        return this & 0x8 == 0x8;
    }
    inline
    function get_d5():Bool {
        return this & 0x4 == 0x4;
    }
    inline
    function get_d6():Bool {
        return this & 0x2 == 0x2;
    }
    inline
    function get_d7():Bool {
        return this & 0x1 == 0x1;
    }
    inline
    function set_d0( v: Bool ){
        (v)? this |= 0x80: this &= ~0x80;
        return v;
    }
    inline
    function set_d1( v: Bool ){
        (v)? this |= 0x40: this &= ~0x40;
        return v;
    }
    inline
    function set_d2( v: Bool ){
        (v)? this |= 0x20: this &= ~0x20;
        return v; 
    }
    inline
    function set_d3( v: Bool ){
        (v)? this |= 0x10: this &= ~0x10;
        return v;
    }
    inline
    function set_d4( v: Bool ){
        (v)? this |= 0x8: this &= ~0x8;
        return v;
    }
    inline
    function set_d5( v: Bool ){
        (v)? this |= 0x4: this &= ~0x4;
        return v;
    }
    inline
    function set_d6( v: Bool ){
        (v)? this |= 0x2: this &= ~0x2;
        return v;
    }
    inline
    function set_d7( v: Bool ){
        (v)? this |= 0x1: this &= ~0x1;
        return v;
    }
    @:arrayAccess
    public inline function get( n: Int ):Bool {
        return switch( n ){
            case 7:
                d7;
            case 6:
                d6;
            case 5:
                d5;
            case 4:
                d4;
            case 3:
                d3;
            case 2:
                d2;
            case 1:
                d1;
            case 0:
                d0;
            case _:
                false;
        }
    }

    @:arrayAccess
    public inline function set( n:Int, v: Bool ):Bool {
        switch( n ){
            case 7:
                d7 = v;
            case 6:
                d6 = v;
            case 5:
                d5 = v;
            case 4:
                d4 = v;
            case 3:
                d3 = v;
            case 2:
                d2 = v;
            case 1:
                d1 = v;
            case 0:
                d0 = v;
            case _:

        }
        return v;
    }
    
    @:arrayAccess
    public inline
    function setInt( n:Int, v:Int ):Int {
        set( n, ( v==1 ) );
        return v;
    }

    @:arrayAccess
    public inline
    function getInt( n:Int ):Int {
        var b: Bool = get( n );
        return ( b == true )? 1: 0;
    }

    @:arrayAccess
    public inline
    function setToggle( n:Int, t:Toggle ):Toggle {
        switch( n ){
            case 7:
                this ^= 0x1;
            case 6:
                this ^= 0x2;
            case 5:
                this ^= 0x4;
            case 4:
                this ^= 0x8;
            case 3:
                this ^= 0x10;
            case 2:
                this ^= 0x20;
            case 1:
                this ^= 0x40;
            case 0:
                this ^= 0x80;
            case _:

        }
        return t;
    }
    // l is so you can reduce the width of display to l binary digits
    inline
    public function left( ?b: Null<Bool> = null, ?l: Int = 0 ): Bool{
        return if( l == 0 || l >8 ){
                    var d = d7;
                    this = this << 1;
                    if( b != null ) d7 = b;
                    d;
                } else {
                    var d = get( 7 - l );
                    this = this << 1;
                    if( b != null ) set( 7 - l, b );
                    for( i in 0...( 8-l) ) set( i, false ); // zero all the ones above l
                    d;
                }
    }
    inline
    public function right( ?b: Null<Bool> = null, ?l: Int = 0 ): Bool{
        return if( l == 0 || l >8 ){
                    var d = d0;
                    this = this >> 1;
                    if( b != null ) d0 = b;
                    d;
                } else {
                    var d = get( 7 - l );
                    this = this >> 1;
                    for( i in 0...( 8-l) ) set( i, false ); // zero all the ones above l
                    if( b != null ) set( 7 - l, b );
                    d;
                }
    }
    @:from
    public static inline 
    function fromString( s: String ): Binary8 {
        var bs = new Binary8( 0 );
        var l = s.length;
        for( i in 0...l ){
            var no = StringTools.fastCodeAt( s, i );
            if( no == null ) break;
            bs[ i - ( l - 8 )] = switch( no ){
                case 49:
                    true;
                case 48:
                    false;
                case 32:
                    false;
                case 42:
                    true;
                case _:
                    throw "Bits digits must be 0 or 1 " + Std.string( StringTools.fastCodeAt( s, i ) );
            }
        }
        return bs;
    }

    @:to
    public function toString():String {
        var out = '';
        var bs: Binary8 = this;
        for( i in 0...8 ) out += ( bs[i] )? '1': '0';
        return out;
    }
    
    @:to
    public function toStars():String {
        var out = '';
        var bs: Binary8 = this;
        for( i in 0...8 ) out += ( bs[i] )? '* ': '  ';
        return out;
    }

    @:to
    public inline function toBytes(): Bytes {
        var o = new BytesOutput();
        o.writeByte(0);
        var by = o.getBytes();
        by.set( 0, this );
        return by;
    }

    @:from
    public static inline function fromBytes( b: Bytes ): Binary8 {
        return new Binary8( b.get(0) );
    }
    
    // Hex String
    public function toHexString():String {
        return '0x' + StringTools.hex( this, 2 );
    }
    // not sure I need this!!
    //public inline
    //function clone():Binary8{
    //    return new Binary8( this.toInt() );
    //}
    public var iteratorBool( get, never ): Binary8IteratorBool;
    public function get_iteratorBool(): Binary8IteratorBool {
        return new Binary8IteratorBool( this );
    }
    public var iteratorInt( get, never ): Binary8IteratorInt;
    public function get_iteratorInt(): Binary8IteratorInt {
        return new Binary8IteratorInt( this );
    }
    
}
class Binary8IteratorBool{
    var count: Int = 0;
    var binary8: Binary8;
    public inline 
    function new( binary8_: Binary8 ){
        count = 0;
        binary8 = binary8_;
    }
    public inline
    function hasNext():Bool {
        return if( count < 8 ){
            true;
        } else {
            binary8 = null;
            count = 0;
            false;
        }
    }
    public inline
    function next(): Bool {
        var b: Bool = binary8[ count ];
        return b;
    }
}
class Binary8IteratorInt{
    var count: Int = 0;
    var binary8: Binary8;
    public inline 
    function new( binary8_: Binary8 ){
        count = 0;
        binary8 = binary8_;
    }
    public inline
    function hasNext():Bool {
        return if( count < 8 ){
            true;
        } else {
            binary8 = null;
            count = 0;
            false;
        }
    }
    public inline
    function next(): Int {
        var b: Int = binary8.getInt( count );
        return b;
    }
}
