package trilateral.tri;
import trilateral.tri.Triangle;
import trilateral.tri.TriangleArray;
import trilateral.geom.Algebra;
abstract TriangleGradient( Triangle ) from Triangle to Triangle {
    public inline function new(  id_: Int
                            , outline_: Bool
                            , A_: Point, B_: Point, C_: Point
                            , depth_: Float
                            , colorID_: Int
                            , colorID2_: Int
                            , gradCorner_: Int
                            ){
            this = new Triangle( id_, outline_, A_, B_, C_, depth_, colorID_ );
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
                                            ,   outline_:   Bool
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
        var line = Algebra.rotateVectorLine( pos, dim, theta, pivotX, pivotY );
        if( horizontal ){
            return { t0: new TriangleGradient( id_, outline_, line.A, line.B, line.D, depth_, colorID_, colorID2_, 1 )
                ,    t1: new TriangleGradient( id_, outline_, line.B, line.C, line.D, depth_, colorID2_, colorID_, 2 ) };
        } else {
            return { t0:  new TriangleGradient( id_, outline_, line.A, line.B, line.D, depth_, colorID_, colorID2_, 2 )
                ,    t1:  new TriangleGradient( id_, outline_, line.B, line.C, line.D, depth_, colorID2_, colorID_, 0 ) };
        }
    }
    public static inline function multiGradient(    id_:    Int,    horizontal_:    Bool
                                                ,   x_:     Float,  y_:             Float
                                                ,   wid_:   Float,  hi_:            Float
                                                ,   triangles: TriangleArray
                                                ,   colors: Array<Int>
                                                ,   ?theta:  Float = 0.
                                                ,   ?pivotX: Float = 0.
                                                ,   ?pivotY: Float = 0.
                                                ){
        if( colors.length == 0 ) return;
        var left = x_; 
        var top = -y_;
        var wid = wid_;
        var hi = hi_;
        if( colors.length == 1 ) colors.push( colors[0] );
        var sections = colors.length - 1;
        var loops = colors.length - 1;
        if( horizontal_ ){
            var step: Float = wid/sections;
            var dim = { x: step, y: -hi };
            for( i in 0...loops ){
                var pos = { x: left + i*step, y: top };
                triangles.pushPair( TriangleGradient.quadGradient( id_, false, pos, dim, 0, colors[i], colors[i+1], horizontal_, theta, pivotX, pivotY ) );
            }
        } else {
            var step: Float = hi/sections;
            var dim = { x: wid, y: -step };
            for( i in 0...loops ){
                var pos = { x: left, y: top - i*step };
                triangles.pushPair( TriangleGradient.quadGradient( id_, false, pos, dim, 0, colors[i], colors[i+1], horizontal_, theta, pivotX, pivotY ) );
            }
        }
    }
}