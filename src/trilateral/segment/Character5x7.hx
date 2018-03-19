package trilateral.segment;
import trilateral.helper.ShapesGeneric;
import trilateral.segment.DotMatrix;
import trilateral.tri.Triangle;
enum PixelShape {
    Circle;
    Square;
    LandScape;
    Portrait;
    //Triangle;
    Star;
    //Diamond;
    RoundedLandScape;
    RoundedPortrait;
}

class Character5x7 {
    public static inline var GOLDEN_RATIO:       Float = 1.61803398874989484820;
    public static inline var FIVESEVEN_RATIO:    Float = 7/5;
    public var shapes:      ShapesGeneric;
    public var ratio:       Float;
    public var bgIndex:     Int;
    public var shapeIndex:  Int;
    public var onColor:     Int;
    public var offColor:    Int;
    public var bgColor:     Int;
    public var dotMatrix:   DotMatrix;
    var pixelShape:         PixelShape;
    public function new(    shapes_: ShapesGeneric, pixelShape_: PixelShape
                        ,   onColor_: Int, offColor_: Int, bgColor_: Int
                        ,   ?ratio_: Float ){
        ratio = ( ratio == null )? FIVESEVEN_RATIO: ratio_;
        pixelShape  = pixelShape_;
        shapes      = shapes_;
        onColor     = onColor_;
        offColor    = offColor_;
        bgColor     = bgColor_;
    }
    public inline
    function updateColor(){
        if( dotMatrix != null ){
            var count = shapeIndex;
            for( j in 0...dotMatrix.length ){
                for( k in 0...5 ){
                    var isOn = dotMatrix[ j ][ 3 + k ];
                    var tris = shapes.findShapeById( count );  
                    tris.map( function( triangle: Triangle ){ 
                        if( isOn ) {
                            triangle.colorID = onColor;
                        } else {
                            triangle.colorID = offColor;
                        }
                    } );
                    count++;
                }
            }
        }
    }
    public inline
    function draw( x: Float, y: Float, w: Float, h: Float
                 , radius: Float, bevel: Float ){
        bgIndex = shapes.refCount;
        shapeIndex = bgIndex + 1;
        var colorID = offColor;    
        var radiusW: Float;
        var radiusH: Float;
        switch( pixelShape ){
            case Circle:
                radiusW = radius;
                radiusH = radius;
            case Square: 
                radiusW = radius;
                radiusH = radius;
            case LandScape:
                radiusW = radius*ratio;
                radiusH = radius;
            case Portrait:
                radiusW = radius;
                radiusH = radius*ratio;
            /*case Triangle:
                radiusW = radius;
                radiusH = radius;*/
            case Star:
                radiusW = radius;
                radiusH = radius;
            /*case Diamond:
                radiusW = radius;
                radiusH = radius;*/
            case RoundedLandScape:
                radiusW = radius*ratio;
                radiusH = radius;
            case RoundedPortrait:
                radiusW = radius;
                radiusH = radius*ratio;
        }                 
        var dx = ( w-radiusW-bevel*2 )/ ( 5 - 1 );
        var dy = ( h-radiusH-bevel*2 )/ ( 7 - 1 );
        shapes.rectangle( x, y, w, h, bgColor );
        var startX = x + bevel + radiusW/2;
        var startY = y + bevel + radiusH/2;
        var px = startX;
        var py = startY;
        for( col in 0...7 ){
            for( i in 0...5 ){
                switch( pixelShape ){
                    case Circle:
                        shapes.circle( px, py, radius, colorID );
                    case Square:
                        shapes.square( px - radius, py - radius, radius*2, colorID );
                    case LandScape:
                        shapes.rectangle( px - radiusW, py - radiusH, radiusW*2, radiusH*2, colorID );
                    case Portrait:
                        shapes.rectangle( px - radiusW, py - radiusH, radiusW*2, radiusH*2, colorID );
                    case Star:
                        shapes.star( px, px, radius, colorID );
                    case RoundedLandScape:
                        shapes.roundedRectangle( px - radiusW, py - radiusH, radiusW*2, radiusH*2, radius/(ratio*2), colorID );
                    case RoundedPortrait:
                        shapes.roundedRectangle( px - radiusW, py - radiusH, radiusW*2, radiusH*2, radius/(ratio*2), colorID );
                } 
                px += dx;
            }
            px = startX;
            py += dy;
        }
    }
}