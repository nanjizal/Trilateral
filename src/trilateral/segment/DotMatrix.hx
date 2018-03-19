package trilateral.segment;
import trilateral.bits.Binary8;
@:forward
abstract DotMatrix( Array<Binary8> ) from Array<Binary8> to Array<Binary8> {
    public
    function new( ?arr: Array<Binary8> ){
        this = arr;
    }
    public
    function toString():String{
        var str = '\n';
        var b8: Binary8;
        var l = this.length;
        for( i in 0...l ){
            b8 = this[i];
            str += b8.toString() + '\n';
        }
        return str;
    }
    public inline
    function col( n: Int ):Binary8 {
        var b8 = new Binary8();
        for( i in 0...this.length ){
            b8[ i ] = this[ i ][ n ];
        }
        return b8;
    }
    public function valueByIndex( i: Int, dig: Int ){
        var x = i%dig;
        var y = Math.floor( i / dig );
        return this[ y ][ x + 8 - dig ];
    }
    
    public inline
    function clone():DotMatrix{
        var arr = [];
        for( i in 0...this.length ){
            arr[ i ] = this[ i ].getValue();
        }
        return new DotMatrix( arr );
    }
    // logic to help scroll
    // dig 8 = 3 space between
    // dig 7 = 2 space between
    // dig 6 = 1 space between
    // dig 5 = 0 space between 
    /**
     *  Useage:
     *
     *  for( j in 0...(l*dig + 5) ){
     *      trace( arr[ 0 ].toStars() );
     *      DotMatrix.displayLeft( arr, dig );
     *      
     *  }
     **/
    public static function displayLeft( arr: Array<DotMatrix>, dig: Int ){
        var l = arr.length;
        var col = arr[ 0 ].col( 8 - dig );
        for( i in 0...l  ) {
            if( i + 1 < l ){
                arr[ i ].left( arr[ i + 1 ], dig );
            } else {
                arr[ i ].leftFirst( col, dig );
            }
        }
    }
    /**
     *  Useage:
     *
     *   for( j in 0...(l*dig + 5) ){
     *      trace( arr[ arr.length - 1 ].toStars() );
     *      DotMatrix.displayRight( arr, dig );
     *  }
     *
     **/
    public static function displayRight(arr: Array<DotMatrix>, dig: Int ){
        var l = arr.length;
        var col = arr[ l - 1 ].col( 7 );
        var k: Int;
        for( i in 0...l  ) {
            k = l - i - 1;
            if( k > 0 ){
                arr[ k ].right( arr[ k - 1 ], dig );
            } else {
                arr[ k ].rightLast( col, dig );
            }
        }
    }
    inline
    public function leftFirst( ?b8:Binary8 = null, ?l: Int = 0 ){
        var here = this;
        var l2 = here.length; 
        for( i in 0...l2 ){
            here[ i ].left( null, l );
            if( b8 != null ) here[ i ].d7 = b8[ i ];
        }
    }
    inline
    public function left( ?dm: DotMatrix = null, ?l: Int = 0 ){
        var here = this;
        var l2 = here.length; 
        for( i in 0...l2 ){
            here[ i ].left( null, l );
            if( dm != null ) here[ i ].d7 = dm[ i ][ 8 - l ];
        }
    }
    inline
    public function rightLast( ?b8:Binary8 = null, ?l: Int = 0 ){
        var here = this;
        var l2 = here.length;
        for( i in 0...l2 ){
            here[ i ].right( null, l );
            if( b8 != null ) here[ i ].d0 = b8[ i ];
        }
    }
    inline
    public function right( ?dm: DotMatrix = null, ?l: Int = 0 ){
        var here = this;
        var l2 = here.length;
        for( i in 0...l2 ){
            here[ i ].right( null, l );
            if( dm != null ) here[ i ].d0 = dm[ i ].d7;
        }
    }
    public 
    function toStars():String{
        var str = '\n';
        var b8: Binary8;
        var l = this.length;
        for( i in 0...l ){
            b8 = this[i];
            str += b8.toStars() + '\n';
        }
        return str;
    }
    /**
     * Example use:
     * for( letter in DotMatrix.display('Nanjazal does DotMatrix' ) ) trace( letter.toStars() );
     *
     **/
    public static inline
    function display( str: String ):Array<DotMatrix> {
        var arr = [];
        for( i in 0...str.length ) arr[ i ] = DotMatrix.five7_dotMatrix( str.charCodeAt( i ) );
        return arr;
    }
    public static inline 
    function five7_dotMatrix( charCode: Int ): DotMatrix {
        var arr = new Array<Binary8>();
        switch( charCode ){
            case 32:// space
                arr[0] = '00000';
                arr[1] = '00000';
                arr[2] = '00000';
                arr[3] = '00000';
                arr[4] = '00000';
                arr[5] = '00000';
                arr[6] = '00000';
            case 33:// !
                arr[0] = '  *  ';
                arr[1] = '  *  ';
                arr[2] = '  *  ';
                arr[3] = '  *  ';
                arr[4] = '     ';
                arr[5] = '  *  ';
                arr[6] = '     '; 
            case 34:// "
                arr[0] = '     ';
                arr[1] = ' * * ';
                arr[2] = ' * * ';
                arr[3] = ' * * ';
                arr[4] = '     ';
                arr[5] = '     ';
                arr[6] = '     '; 
            case 35:// #
                arr[0] = ' * * ';
                arr[1] = ' * * ';
                arr[2] = '*****';
                arr[3] = ' * * ';
                arr[4] = '*****';
                arr[5] = ' * * ';
                arr[6] = ' * * '; 
            case 36:// $
                arr[0] = '  *  ';
                arr[1] = ' ****';
                arr[2] = '* *  ';
                arr[3] = ' *** ';
                arr[4] = '  * *';
                arr[5] = '**** ';
                arr[6] = '  *  '; 
            case 37:// %
                arr[0] = '**   ';
                arr[1] = '**  *';
                arr[2] = '   * ';
                arr[3] = '  *  ';
                arr[4] = ' *   ';
                arr[5] = '*  **';
                arr[6] = '   **'; 
            case 38:// &
                arr[0] = ' **  ';
                arr[1] = '*  * ';
                arr[2] = '* *  ';
                arr[3] = ' *   ';
                arr[4] = '* * *';
                arr[5] = '*  * ';
                arr[6] = ' ** *'; 
            case 39:// '
                arr[0] = '  ** ';
                arr[1] = '   * ';
                arr[2] = '  *  ';
                arr[3] = '     ';
                arr[4] = '     ';
                arr[5] = '     ';
                arr[6] = '     '; 
            case 40:// (
                arr[0] = '  *  ';
                arr[1] = ' *   ';
                arr[2] = '*    ';
                arr[3] = '*    ';
                arr[4] = '*    ';
                arr[5] = ' *   ';
                arr[6] = '  *  '; 
            case 41:// )
                arr[0] = '  *  ';
                arr[1] = '   * ';
                arr[2] = '    *';
                arr[3] = '    *';
                arr[4] = '    *';
                arr[5] = '   * ';
                arr[6] = '  *  '; 
            case 42:// *
                arr[0] = '  *  ';
                arr[1] = '  *  ';
                arr[2] = '* * *';
                arr[3] = ' *** ';
                arr[4] = '* * *';
                arr[5] = '  *  ';
                arr[6] = '     '; 
            case 43:// +
                arr[0] = '     ';
                arr[1] = '  *  ';
                arr[2] = '  *  ';
                arr[3] = '*****';
                arr[4] = '  *  ';
                arr[5] = '  *  ';
                arr[6] = '     '; 
            case 44:// ,
                arr[0] = '     ';
                arr[1] = '     ';
                arr[2] = '     ';
                arr[3] = '     ';
                arr[4] = ' **  ';
                arr[5] = '  *  ';
                arr[6] = ' *   '; 
            case 45:// -
                arr[0] = '     ';
                arr[1] = '     ';
                arr[2] = '     ';
                arr[3] = '*****';
                arr[4] = '     ';
                arr[5] = '     ';
                arr[6] = '     '; 
            case 46:// .
                arr[0] = '     ';
                arr[1] = '     ';
                arr[2] = '     ';
                arr[3] = '     ';
                arr[4] = '     ';
                arr[5] = '  ** ';
                arr[6] = '  ** '; 
            case 47:// /
                arr[0] = '    *';
                arr[1] = '   * ';
                arr[2] = '   * ';
                arr[3] = '  *  ';
                arr[4] = '  *  ';
                arr[5] = ' *   ';
                arr[6] = '*    '; 
            case 48:// 0
                arr[0] = ' *** ';
                arr[1] = '*   *';
                arr[2] = '*  **';
                arr[3] = '* * *';
                arr[4] = '**  *';
                arr[5] = '*   *';
                arr[6] = ' *** ';
            case 49:// 1
                arr[0] = '  *  ';
                arr[1] = ' **  ';
                arr[2] = '  *  ';
                arr[3] = '  *  ';
                arr[4] = '  *  ';
                arr[5] = '  *  ';
                arr[6] = ' *** ';
            case 50:// 2
                arr[0] = ' *** ';
                arr[1] = '*   *';
                arr[2] = '    *';
                arr[3] = '  *  ';
                arr[4] = ' *   ';
                arr[5] = '*    ';
                arr[6] = '*****';
            case 51:// 3
                arr[0] = '*****';
                arr[1] = '   * ';
                arr[2] = '  *  ';
                arr[3] = '   * ';
                arr[4] = '    *';
                arr[5] = '*   *';
                arr[6] = ' *** ';
            case 52:// 4
                arr[0] = '   * ';
                arr[1] = '  ** ';
                arr[2] = ' * * ';
                arr[3] = '*  * ';
                arr[4] = '*****';
                arr[5] = '   * ';
                arr[6] = '   * ';
            case 53:// 5
                arr[0] = '*****';
                arr[1] = '*    ';
                arr[2] = '**** ';
                arr[3] = '    *';
                arr[4] = '    *';
                arr[5] = '*   *';
                arr[6] = ' *** ';
            case 54:// 6
                arr[0] = '  ** ';
                arr[1] = ' *   ';
                arr[2] = '*    ';
                arr[3] = '**** ';
                arr[4] = '*   *';
                arr[5] = '*   *';
                arr[6] = ' *** ';
            case 55:// 7
                arr[0] = '*****';
                arr[1] = '    *';
                arr[2] = '   * ';
                arr[3] = '  *  ';
                arr[4] = ' *   ';
                arr[5] = ' *   ';
                arr[6] = ' *   ';
            case 56:// 8
                arr[0] = ' *** ';
                arr[1] = '*   *';
                arr[2] = '*   *';
                arr[3] = ' *** ';
                arr[4] = '*   *';
                arr[5] = '*   *';
                arr[6] = ' *** ';
            case 57:// 9
                arr[0] = ' *** ';
                arr[1] = '*   *';
                arr[2] = '*   *';
                arr[3] = ' ****';
                arr[4] = '    *';
                arr[5] = '   * ';
                arr[6] = ' **  ';
            case 58:// :
                arr[0] = '     ';
                arr[1] = '  ** ';
                arr[2] = '  ** ';
                arr[3] = '     ';
                arr[4] = '  ** ';
                arr[5] = '  ** ';
                arr[6] = '     ';                
            case 59:// ;
                arr[0] = '     ';
                arr[1] = '  ** ';
                arr[2] = '  ** ';
                arr[3] = '     ';
                arr[4] = '  ** ';
                arr[5] = '   * ';
                arr[6] = '  *  ';    
            case 60:// <
                arr[0] = '   * ';
                arr[1] = '  *  ';
                arr[2] = ' *   ';
                arr[3] = '*    ';
                arr[4] = ' *   ';
                arr[5] = '  *  ';
                arr[6] = '   * ';    
            case 61:// =
                arr[0] = '     ';
                arr[1] = '     ';
                arr[2] = '*****';
                arr[3] = '     ';
                arr[4] = '*****';
                arr[5] = '     ';
                arr[6] = '     ';    
            case 62:// >
                arr[0] = ' *   ';
                arr[1] = '  *  ';
                arr[2] = '   * ';
                arr[3] = '    *';
                arr[4] = '   * ';
                arr[5] = '  *  ';
                arr[6] = ' *   ';    
            case 63:// ?
                arr[0] = ' *** ';
                arr[1] = '*   *';
                arr[2] = '    *';
                arr[3] = '   * ';
                arr[4] = '  *  ';
                arr[5] = '     ';
                arr[6] = '  *  ';    
            case 64:// @
                arr[0] = ' *** ';
                arr[1] = '*   *';
                arr[2] = '    *';
                arr[3] = ' ** *';
                arr[4] = '* * *';
                arr[5] = '* * *';
                arr[6] = ' *** ';    
            case 65:// A
                arr[0] = ' *** ';
                arr[1] = '*   *';
                arr[2] = '*   *';
                arr[3] = '*   *';
                arr[4] = '*****';
                arr[5] = '*   *';
                arr[6] = '*   *';    
            case 66:// B
                arr[0] = '**** ';
                arr[1] = '*   *';
                arr[2] = '*   *';
                arr[3] = '**** ';
                arr[4] = '*   *';
                arr[5] = '*   *';
                arr[6] = '**** ';    
            case 67:// C
                arr[0] = ' *** ';
                arr[1] = '*   *';
                arr[2] = '*    ';
                arr[3] = '*    ';
                arr[4] = '*    ';
                arr[5] = '*   *';
                arr[6] = ' *** ';  
            case 68:// D
                arr[0] = '***  ';
                arr[1] = '*  * ';
                arr[2] = '*   *';
                arr[3] = '*   *';
                arr[4] = '*   *';
                arr[5] = '*  * ';
                arr[6] = '***  ';  
            case 69:// E
                arr[0] = '*****';
                arr[1] = '*    ';
                arr[2] = '*    ';
                arr[3] = '**** ';
                arr[4] = '*    ';
                arr[5] = '*    ';
                arr[6] = '*****';  
            case 70:// F
                arr[0] = '*****';
                arr[1] = '*    ';
                arr[2] = '*    ';
                arr[3] = '**** ';
                arr[4] = '*    ';
                arr[5] = '*    ';
                arr[6] = '*    ';  
            case 71:// G
                arr[0] = ' *** ';
                arr[1] = '*   *';
                arr[2] = '*    ';
                arr[3] = '* ***';
                arr[4] = '*   *';
                arr[5] = '*   *';
                arr[6] = ' ****';  
            case 72:// H
                arr[0] = '*   *';
                arr[1] = '*   *';
                arr[2] = '*   *';
                arr[3] = '*****';
                arr[4] = '*   *';
                arr[5] = '*   *';
                arr[6] = '*   *';  
            case 73:// I
                arr[0] = ' *** ';
                arr[1] = '  *  ';
                arr[2] = '  *  ';
                arr[3] = '  *  ';
                arr[4] = '  *  ';
                arr[5] = '  *  ';
                arr[6] = ' *** ';  
            case 74:// J
                arr[0] = ' ****';
                arr[1] = '   * ';
                arr[2] = '   * ';
                arr[3] = '   * ';
                arr[4] = '   * ';
                arr[5] = '*  * ';
                arr[6] = ' **  ';  
            case 75:// K
                arr[0] = '*   *';
                arr[1] = '*  * ';
                arr[2] = '* *  ';
                arr[3] = '**   ';
                arr[4] = '* *  ';
                arr[5] = '*  * ';
                arr[6] = '*   *';  
            case 76:// L
                arr[0] = '*    ';
                arr[1] = '*    ';
                arr[2] = '*    ';
                arr[3] = '*    ';
                arr[4] = '*    ';
                arr[5] = '*    ';
                arr[6] = '*****';  
            case 77:// M
                arr[0] = '*   *';
                arr[1] = '** **';
                arr[2] = '* * *';
                arr[3] = '* * *';
                arr[4] = '*   *';
                arr[5] = '*   *';
                arr[6] = '*   *';  
            case 78:// N
                arr[0] = '*   *';
                arr[1] = '*   *';
                arr[2] = '**  *';
                arr[3] = '* * *';
                arr[4] = '*  **';
                arr[5] = '*   *';
                arr[6] = '*   *';  
            case 79:// O
                arr[0] = ' *** ';
                arr[1] = '*   *';
                arr[2] = '*   *';
                arr[3] = '*   *';
                arr[4] = '*   *';
                arr[5] = '*   *';
                arr[6] = ' *** ';  
            case 80:// P
                arr[0] = '**** ';
                arr[1] = '*   *';
                arr[2] = '*   *';
                arr[3] = '**** ';
                arr[4] = '*    ';
                arr[5] = '*    ';
                arr[6] = '*    ';  
            case 81:// Q
                arr[0] = ' *** ';
                arr[1] = '*   *';
                arr[2] = '*   *';
                arr[3] = '*   *';
                arr[4] = '* * *';
                arr[5] = '*  * ';
                arr[6] = ' ** *';  
            case 82:// R
                arr[0] = '**** ';
                arr[1] = '*   *';
                arr[2] = '*   *';
                arr[3] = '**** ';
                arr[4] = '* *  ';
                arr[5] = '*  * ';
                arr[6] = '*   *';  
            case 83:// S
                arr[0] = ' ****';
                arr[1] = '*    ';
                arr[2] = '*    ';
                arr[3] = ' *** ';
                arr[4] = '    *';
                arr[5] = '    *';
                arr[6] = '**** ';  
            case 84:// T
                arr[0] = '*****';
                arr[1] = '  *  ';
                arr[2] = '  *  ';
                arr[3] = '  *  ';
                arr[4] = '  *  ';
                arr[5] = '  *  ';
                arr[6] = '  *  ';  
            case 85:// U
                arr[0] = '*   *';
                arr[1] = '*   *';
                arr[2] = '*   *';
                arr[3] = '*   *';
                arr[4] = '*   *';
                arr[5] = '*   *';
                arr[6] = ' *** ';  
            case 86:// V
                arr[0] = '*   *';
                arr[1] = '*   *';
                arr[2] = '*   *';
                arr[3] = '*   *';
                arr[4] = '*   *';
                arr[5] = ' * * ';
                arr[6] = '  *  ';  
            case 87:// W
                arr[0] = '*   *';
                arr[1] = '*   *';
                arr[2] = '*   *';
                arr[3] = '* * *';
                arr[4] = '* * *';
                arr[5] = '* * *';
                arr[6] = ' * * ';  
            case 88:// X
                arr[0] = '*   *';
                arr[1] = '*   *';
                arr[2] = ' * * ';
                arr[3] = '  *  ';
                arr[4] = ' * * ';
                arr[5] = '*   *';
                arr[6] = '*   *';  
            case 89:// Y
                arr[0] = '*   *';
                arr[1] = '*   *';
                arr[2] = '*   *';
                arr[3] = ' * * ';
                arr[4] = '  *  ';
                arr[5] = '  *  ';
                arr[6] = '  *  ';  
            case 90:// Z
                arr[0] = '*****';
                arr[1] = '    *';
                arr[2] = '   * ';
                arr[3] = '  *  ';
                arr[4] = ' *   ';
                arr[5] = '*    ';
                arr[6] = '*****';  
            case 91:// [
                arr[0] = ' *** ';
                arr[1] = ' *   ';
                arr[2] = ' *   ';
                arr[3] = ' *   ';
                arr[4] = ' *   ';
                arr[5] = ' *   ';
                arr[6] = ' *** ';  
            case 92:// \
                arr[0] = '*    ';
                arr[1] = ' *   ';
                arr[2] = '  *  ';
                arr[3] = '  *  ';
                arr[4] = '   * ';
                arr[5] = '   * ';
                arr[6] = '    *';  
            case 93:// ]
                arr[0] = ' *** ';
                arr[1] = '   * ';
                arr[2] = '   * ';
                arr[3] = '   * ';
                arr[4] = '   * ';
                arr[5] = '   * ';
                arr[6] = ' *** ';  
            case 94:// ^
                arr[0] = '  *  ';
                arr[1] = ' * * ';
                arr[2] = '*   *';
                arr[3] = '     ';
                arr[4] = '     ';
                arr[5] = '     ';
                arr[6] = '     ';  
            case 95:// _
                arr[0] = '     ';
                arr[1] = '     ';
                arr[2] = '     ';
                arr[3] = '     ';
                arr[4] = '     ';
                arr[5] = '     ';
                arr[6] = '*****';  
            case 96:// `
                arr[0] = '*    ';
                arr[1] = ' *   ';
                arr[2] = '     ';
                arr[3] = '     ';
                arr[4] = '     ';
                arr[5] = '     ';
                arr[6] = '     '; 
            case 97:// a
                arr[0] = '     ';
                arr[1] = '     ';
                arr[2] = ' *** ';
                arr[3] = '    *';
                arr[4] = ' ****';
                arr[5] = '*   *';
                arr[6] = ' ****'; 
            case 98:// b
                arr[0] = '*    ';
                arr[1] = '*    ';
                arr[2] = '* ** ';
                arr[3] = '**  *';
                arr[4] = '*   *';
                arr[5] = '*   *';
                arr[6] = '**** '; 
            case 99:// c
                arr[0] = '     ';
                arr[1] = '     ';
                arr[2] = ' *** ';
                arr[3] = '*    ';
                arr[4] = '*    ';
                arr[5] = '*   *';
                arr[6] = ' *** '; 
            case 100://d
                arr[0] = '    *';
                arr[1] = '    *';
                arr[2] = ' ** *';
                arr[3] = '*  **';
                arr[4] = '*   *';
                arr[5] = '*   *';
                arr[6] = ' ****'; 
            case 101://e
                arr[0] = '     ';
                arr[1] = '     ';
                arr[2] = ' *** ';
                arr[3] = '*   *';
                arr[4] = '*****';
                arr[5] = '*    ';
                arr[6] = ' *** '; 
            case 102://f
                arr[0] = '  ** ';
                arr[1] = ' *  *';
                arr[2] = ' *   ';
                arr[3] = '***  ';
                arr[4] = ' *   ';
                arr[5] = ' *   ';
                arr[6] = ' *   '; 
            case 103://g
                arr[0] = '     ';
                arr[1] = ' ****';
                arr[2] = '*   *';
                arr[3] = '*   *';
                arr[4] = ' ****';
                arr[5] = '    *';
                arr[6] = ' *** '; 
            case 104://h
                arr[0] = '*    ';
                arr[1] = '*    ';
                arr[2] = '* ** ';
                arr[3] = '**  *';
                arr[4] = '*   *';
                arr[5] = '*   *';
                arr[6] = '*   *'; 
            case 105://i
                arr[0] = '  *  ';
                arr[1] = '     ';
                arr[2] = ' **  ';
                arr[3] = '  *  ';
                arr[4] = '  *  ';
                arr[5] = '  *  ';
                arr[6] = ' *** '; 
            case 106://j
                arr[0] = '   * ';
                arr[1] = '     ';
                arr[2] = '  ** ';
                arr[3] = '   * ';
                arr[4] = '   * ';
                arr[5] = '*  * ';
                arr[6] = ' **  '; 
            case 107://k
                arr[0] = '*    ';
                arr[1] = '*    ';
                arr[2] = '*  * ';
                arr[3] = '* *  ';
                arr[4] = '**   ';
                arr[5] = '* *  ';
                arr[6] = '*   *'; 
            case 108://l
                arr[0] = ' **  ';
                arr[1] = '  *  ';
                arr[2] = '  *  ';
                arr[3] = '  *  ';
                arr[4] = '  *  ';
                arr[5] = '  *  ';
                arr[6] = ' ***'; 
            case 109://m
                arr[0] = '     ';
                arr[1] = '     ';
                arr[2] = '** * ';
                arr[3] = '* * *';
                arr[4] = '* * *';
                arr[5] = '*   *';
                arr[6] = '*   *'; 
            case 110://n
                arr[0] = '     ';
                arr[1] = '     ';
                arr[2] = '* ** ';
                arr[3] = '**  *';
                arr[4] = '*   *';
                arr[5] = '*   *';
                arr[6] = '*   *'; 
            case 111://o
                arr[0] = '     ';
                arr[1] = '     ';
                arr[2] = ' *** ';
                arr[3] = '*   *';
                arr[4] = '*   *';
                arr[5] = '*   *';
                arr[6] = ' *** '; 
            case 112://p
                arr[0] = '     ';
                arr[1] = '     ';
                arr[2] = '**** ';
                arr[3] = '*   *';
                arr[4] = '**** ';
                arr[5] = '*    ';
                arr[6] = '*    '; 
            case 113://q
                arr[0] = '     ';
                arr[1] = '     ';
                arr[2] = ' ** *';
                arr[3] = '*  **';
                arr[4] = ' ****';
                arr[5] = '    *';
                arr[6] = '    *'; 
            case 114://r
                arr[0] = '     ';
                arr[1] = '     ';
                arr[2] = '* ** ';
                arr[3] = '**  *';
                arr[4] = '*    ';
                arr[5] = '*    ';
                arr[6] = '*    '; 
            case 115://s
                arr[0] = '     ';
                arr[1] = '     ';
                arr[2] = ' *** ';
                arr[3] = '*    ';
                arr[4] = ' *** ';
                arr[5] = '    *';
                arr[6] = '**** '; 
            case 116://t
                arr[0] = '     ';
                arr[1] = ' *   ';
                arr[2] = '***  ';
                arr[3] = ' *   ';
                arr[4] = ' *   ';
                arr[5] = ' *  *';
                arr[6] = '  ** '; 
            case 117://u
                arr[0] = '     ';
                arr[1] = '     ';
                arr[2] = '*   *';
                arr[3] = '*   *';
                arr[4] = '*   *';
                arr[5] = '*  **';
                arr[6] = ' ** *'; 
            case 118://v
                arr[0] = '     ';
                arr[1] = '     ';
                arr[2] = '*   *';
                arr[3] = '*   *';
                arr[4] = '*   *';
                arr[5] = ' * * ';
                arr[6] = '  *  '; 
            case 119://w
                arr[0] = '     ';
                arr[1] = '     ';
                arr[2] = '*   *';
                arr[3] = '*   *';
                arr[4] = '* * *';
                arr[5] = '* * *';
                arr[6] = ' * * '; 
            case 120://x
                arr[0] = '     ';
                arr[1] = '     ';
                arr[2] = '*   *';
                arr[3] = ' * * ';
                arr[4] = '  *  ';
                arr[5] = ' * * ';
                arr[6] = '*   *'; 
            case 121://y
                arr[0] = '     ';
                arr[1] = '     ';
                arr[2] = '*   *';
                arr[3] = '*   *';
                arr[4] = ' ****';
                arr[5] = '    *';
                arr[6] = ' *** '; 
            case 122://z
                arr[0] = '     ';
                arr[1] = '     ';
                arr[2] = '*****';
                arr[3] = '   * ';
                arr[4] = '  *  ';
                arr[5] = ' *   ';
                arr[6] = '*****'; 
            case 123://{
                arr[0] = '   * ';
                arr[1] = '  *  ';
                arr[2] = '  *  ';
                arr[3] = ' *   ';
                arr[4] = '  *  ';
                arr[5] = '  *  ';
                arr[6] = '   * '; 
            case 124://|
                arr[0] = '  *  ';
                arr[1] = '  *  ';
                arr[2] = '  *  ';
                arr[3] = '  *  ';
                arr[4] = '  *  ';
                arr[5] = '  *  ';
                arr[6] = '  *  '; 
            case 125://}
                arr[0] = '   * ';
                arr[1] = '  *  ';
                arr[2] = '  *  ';
                arr[3] = ' *   ';
                arr[4] = '  *  ';
                arr[5] = '  *  ';
                arr[6] = '   * '; 
            case 126://~
                arr[0] = ' ** *';
                arr[1] = '*  * ';
                arr[2] = '     ';
                arr[3] = '     ';
                arr[4] = '     ';
                arr[5] = '     ';
                arr[6] = '     '; 
            
        }
        return new DotMatrix( arr );
    }
}