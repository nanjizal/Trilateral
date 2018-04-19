package trilateral.tri;
import trilateral.tri.Triangle;
import trilateral.geom.Point;
import trilateral.tri.TriangleArray;
import trilateral.geom.Algebra;
abstract TriangleGradient( Triangle ) from Triangle to Triangle {
    public inline function new(  id_: Int
                            , A_: Point, B_: Point, C_: Point
                            , depth_: Float
                            , colorID_: Int
                            , colorID2_: Int
                            , gradCorner_: Int
                            ){
            this = new Triangle( id_, A_, B_, C_, depth_, colorID_ );
            switch( gradCorner_ ){
                case 0:
                    this.colorA = colorID2_;
                    this.colorB = colorID_;
                    this.colorC = colorID_;
                case 1:
                    if( this.windingAdjusted ){
                        this.colorA = colorID_;
                        this.colorB = colorID_;
                        this.colorC = colorID2_;
                    } else {
                        this.colorA = colorID_;
                        this.colorB = colorID2_;
                        this.colorC = colorID_;
                    }
                case 2:
                    if( this.windingAdjusted ){
                        this.colorA = colorID_;
                        this.colorB = colorID2_;
                        this.colorC = colorID_;
                    } else {
                        this.colorA = colorID_;
                        this.colorB = colorID_;
                        this.colorC = colorID2_;
                    }
            }
    }
    public inline static function quadGradient( id_:        Int
                                            ,   pos_:       Point, dim_: Point
                                            ,   depth_:     Float
                                            ,   colorID_:   Int
                                            ,   colorID2_:  Int
                                            ,   horizontal: Bool
                                            ,   theta:      Float = 0.
                                            ,   pivotX:     Float = 0.
                                            ,   pivotY:     Float = 0.
                                            ): TrianglePair {
        //   A   B
        //   D   C
        var line = Algebra.rotateVectorLine( pos_, dim_, theta, pivotX, pivotY );
        if( horizontal ){
            return { t0: new TriangleGradient( id_, line.A, line.B, line.D, depth_, colorID_, colorID2_, 1 )
                ,    t1: new TriangleGradient( id_, line.B, line.C, line.D, depth_, colorID2_, colorID_, 2 ) };
        } else {
            return { t0:  new TriangleGradient( id_, line.A, line.B, line.D, depth_, colorID_, colorID2_, 2 )
                ,    t1:  new TriangleGradient( id_, line.B, line.C, line.D, depth_, colorID2_, colorID_, 0 ) };
        }
    }
    // converts normal tween equation for use with gradient
    public static function gradientFunction( tweenEquation: Float->Float->Float->Float->Float ): Float->Float {
        return function( t: Float ): Float { return tweenEquation( t, 0, 1, 1 ); }
    }
    public static inline function multiGradient(    id_:    Int,    horizontal_:    Bool
                                                ,   x_:     Float,  y_:             Float
                                                ,   wid_:   Float,  hi_:            Float
                                                ,   triangles: TriangleArray
                                                ,   colors: Array<Int>
                                                ,   func: Float -> Float = null
                                                ,   ?theta:  Float = 0.
                                                ,   ?pivotX: Float = 0.
                                                ,   ?pivotY: Float = 0.
                                                ){
        if( colors.length == 0 ) return;
        var left = x_; 
        var top = y_;
        var wid = wid_;
        var hi = hi_;
        if( colors.length == 1 ) colors.push( colors[ 0 ] );
        var sections = colors.length - 1;
        var loops = colors.length - 1;
        if( func == null ) func = function( v: Float ): Float{ return v; }
        if( horizontal_ ){
            var step: Float = 1/sections;
            var x0: Float;
            var x1: Float;
            for( i in 0...loops ){
                x0 = func( i*step );
                x1 = func( (i+1)*step );
                var pos = { x: left + x0*wid, y: top };
                var dim = { x: wid*(x1-x0), y: hi };
                triangles.pushPair( TriangleGradient.quadGradient( id_, pos, dim, 0, colors[ i ], colors[ i + 1 ], horizontal_, theta, pivotX, pivotY ) );
            }
        } else {
            var step: Float = 1/sections;
            var dim = { x: wid, y: hi*func( step ) };
            for( i in 0...loops ){
                var pos = { x: left, y: top + func( i*step )*hi };
                triangles.pushPair( TriangleGradient.quadGradient( id_, pos, dim, 0, colors[ i ], colors[ i + 1 ], horizontal_, theta, pivotX, pivotY ) );
            }
        }
    }
}