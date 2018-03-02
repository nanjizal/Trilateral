package trilateral.tri;
import trilateral.tri.Triangle;
import trilateral.tri.Trilateral;
import trilateral.geom.Algebra;
@:forward
abstract TrilateralArray(Array<Trilateral>) from Array<Trilateral> to Array<Trilateral> {
    inline public 
    function new( ?t: Array<Trilateral> ) {
        this = ( t == null )? getEmpty(): t;
    }
    public inline static 
    function getEmpty(){
        return new TrilateralArray( new Array<Trilateral>() );
    }
    public inline
    function clear(){
        this = new TrilateralArray();
    }
    public inline
    function add( tri: Trilateral ){
        this[ this.length ] = tri;
    }
    public inline
    function addPair( tp: TrilateralPair ){
        this[ this.length ] = tp.t0;
        this[ this.length ] = tp.t1;
    }
    public inline
    function addArray( triArr: Array<Trilateral> ) {
        for( t in triArr ) this[ this.length ] = t;
        return triArr;
    }
}