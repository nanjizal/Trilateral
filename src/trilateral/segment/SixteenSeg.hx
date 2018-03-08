package trilateral.segment;
import trilateral.tri.Trilateral;
import trilateral.tri.TrilateralArray;
// Used to emulate 16 segment display, can be used for rough letters.
class SixteenSeg{
    public var width: Float;
    public var height: Float;
    public var sx: Float = 1.;
    public var sy: Float = 1.;
    public var x: Float;
    public var y: Float;
    public var spacing: Float;
    public var triArr: TrilateralArray;
    public function new( width_: Float, height_: Float, ?trilateralArray_: TrilateralArray = null ){
        height = height_;
        width  = width_;
        sx = width/11;
        sy = height/18;
        spacing = width * 14/11;
        triArr = ( trilateralArray_ == null )? new Array<Trilateral>(): trilateralArray_;
    } 
    public inline
    function stringWidth( str: String ): Float {
        var l = str.length;
        var space = 0.;
        for( i in 0...l ){
            space += spacing;
        }
        return space;
    }
    public inline
    function addNumber( val: Int, x_: Float, y_: Float, ?centre: Bool = false ){
        var str = Std.string( val );
        add( str, x_, y_, centre );
    }
    public inline
    function add( str: String, x_: Float, y_: Float, ?centre: Bool = false ){
        var l = str.length;
        var space = 0.;
        if( centre ){
            for( i in 0...l ) space += spacing;
            space -= width * 14/11;// centreX makes assumption for simplicity see spacing in constructor.
            space = -space/2;
            y_ = y_ - height/2;
        }
        for( i in 0...l ){
            addChar( str.substr( i, 1 ), x_ + space, y_ );
            space += spacing;
        }
    }
    public inline
    function addChar( str: String, x_: Float, y_: Float ){
        x = x_;
        y = y_;
        switch( str ){
            case '!':   b(); c(); // dp();
            case '"':   f(); b();
            case '#':   f(); e(); d(); g(); i(); l();
            case '$':   a(); f(); g(); c(); d(); i(); l();
            case '%':   a1(); f(); g(); c(); d2(); i(); j(); k(); l();
            case '&':   a1(); f(); h(); g1(); e(); d(); m(); j();
            case "'":   b();
            case '(':   j(); m();
            case ')':   h(); k();
            case '*':   g(); h(); i(); j(); k(); l(); m();
            case '+':   i(); g(); l();
            case ',':   d1();
            case '-':   g();
            case '.':   //dp();
            case '/':   j(); k();
            case '0':   a(); b(); c(); d(); e(); f(); j(); k();
            case '1':   b(); c();
            case '2':   a(); b(); g(); e(); d();
            case '3':   a(); b(); g(); c(); d();
            case '4':   f(); g(); b(); c();
            case '5':   a(); f(); g(); c(); d();
            case '6':   a(); f(); g(); e(); c(); d();
            case '7':   a(); b(); c();
            case '8':   a(); b(); c(); d(); e(); f(); g();
            case '9':   a(); b(); f(); g(); c(); d();
            case ':':   g1(); d1();
            case ';':   a1(); k();
            case '<':   j(); m();
            case '=':   g(); d();
            case '>':   h(); k();
            case '?':   a2(); b(); g2(); l(); //dp();
            case '@':   a(); b(); c(); d(); e(); g1(); l();
            case 'A':   e(); f(); a1(); a2(); b(); c(); g();
            case 'B':   a(); b(); c(); d(); g2(); l(); i();
            case 'C':   a(); f(); e(); d();
            case 'D':   a(); b(); c(); d(); i(); l();
            case 'E':   a(); f(); g1(); e(); d();
            case 'F':   a(); f(); g1(); e();
            case 'G':   a(); f(); e(); d(); c(); g2();
            case 'H':   f(); g(); b(); c(); e();
            case 'I':   a(); i(); l(); d();
            case 'J':   b(); c(); d(); e();
            case 'K':   f(); g1(); e(); j(); m();
            case 'L':   f(); e(); d();
            case 'M':   e(); f(); h(); j(); b(); c();
            case 'N':   e(); f(); h(); m(); c(); b();
            case 'O':   a(); b(); c(); d(); e(); f();
            case 'P':   a(); b(); g(); f(); e(); 
            case 'Q':   a(); b(); c(); d(); e(); f(); m();
            case 'R':   a(); b(); g(); m(); f(); e();
            case 'S':   a(); f(); g(); c(); d();
            case 'T':   a(); i(); l();
            case 'U':   f(); e(); d(); c(); b(); c();
            case 'V':   f(); e(); j(); k();
            case 'W':   f(); e(); k(); m(); c(); b();
            case 'X':   h(); j(); k(); m();
            case 'Y':   h(); j(); l();
            case 'Z':   a(); j(); k(); d();
            case '[':   a2(); i(); l(); d2();
            case '\\':  h(); m();
            case ']':   a1(); i(); l(); d1();
            case '':    k(); m();
            case '_':   d1(); d2();
            case '`':   h();
            case 'a':   g1(); e(); l(); d();
            case 'b':   f(); g1(); g2(); c(); d(); e();
            case 'c':   g(); e(); d();
            case 'd':   b(); g(); e(); d(); c();
            case 'e':   g1(); e(); k(); d1(); d2();
            case 'f':   a2(); i(); g(); l();
            case 'g':   g1(); e(); k(); m(); d2();
            case 'h':   f(); g(); c(); e();
            case 'i':   a1(); g1(); l(); d();
            case 'j':   a2(); g2(); c(); d();
            case 'k':   f(); g(); m(); e();
            case 'l':   a1(); i(); l(); d2();
            case 'm':   e(); g(); l(); c();
            case 'n':   e(); g(); c();
            case 'o':   e(); g(); d(); c();
            case 'p':   d1(); l(); m(); g2(); c();
            case 'q':   e(); g(); c(); m(); d();
            case 'r':   e(); g();
            case 's':   g2(); m(); d();
            case 't':   i(); g(); l(); d2();
            case 'u':   e(); d(); c();
            case 'v':   e(); k();
            case 'w':   e(); k(); m(); c();
            case 'x':   g(); k(); m();
            case 'y':   m(); c(); d();
            case 'z':   g1(); k(); d1();
            case '{':   a2(); i(); g1(); l(); d2();
            case '|':   i(); l();
            case '}':   a1(); i(); g2(); l(); d1();
            case '£':   a2(); i(); g(); k(); d();
            case '±':   i(); g(); l(); d();
            
        }
    }
    inline
    function a(){
        a1();
        a2();
    }
    inline
    function g(){
        g1();
        g2();
    }
    inline
    function d(){
        d1();
        d2();
    }
    inline
    function triFactory( ax: Float, ay: Float, bx: Float, by: Float, cx: Float, cy: Float ): Trilateral {
        return new Trilateral( x+sx*ax, y+sy*ay, x+sx*bx, y+sy*by, x+sx*cx, y+sy*cy );
    }
    inline
    function a1(){
        var tri = triArr;
        var l_ = tri.length;
        var third = 1/3;
        tri[ l_ ] = triFactory( 1., 0.5, 1.5, 0., 5., 0. );
        l_++;
        tri[ l_ ] = triFactory( 1., 0.5, 5., 0., 5. + third, 0.5 );
        l_++;
        tri[ l_ ] = triFactory( 1., 0.5, 5 + third, 0.5, 5 + third, 2. );
        l_++;
        tri[ l_ ] = triFactory( 1., 0.5, 5 + third, 2., 2.5, 2. );
    }
    inline
    function a2(){
        var tri = triArr;
        var l_ = tri.length;
        var third = 1/3;
        tri[ l_ ] = triFactory( 6. - third, 0.5, 6., 0., 9.5, 0. );
        l_++;
        tri[ l_ ] = triFactory( 6. - third, 0.5, 9.5, 0., 10., 0.5 );
        l_++;
        tri[ l_ ] = triFactory( 6. - third, 0.5, 10., 0.5, 8.5, 2. );
        l_++;
        tri[ l_ ] = triFactory( 6 - third, 0.5, 8.5, 0.5, 6 - third, 2.0 );
    }
    inline
    function b(){
        var tri = triArr;
        var l_ = tri.length;
        tri[ l_ ] = triFactory( 9., 2.5, 10.5, 1., 11., 1.5 );
        l_++;
        tri[ l_ ] = triFactory( 9., 2.5, 11., 1.5, 11., 7.5 );
        l_++;
        tri[ l_ ] = triFactory( 9., 7.5, 11., 7.5, 10.5, 8.5 );
        l_++;
        tri[ l_ ] = triFactory( 9., 2.5, 11., 7.5, 10.5, 8.5 );
    }
    inline
    function c(){
        var tri = triArr;
        var l_ = tri.length;
        tri[ l_ ] = triFactory( 9., 10.5, 10.5, 9.5, 11., 10.5 );
        l_++;
        tri[ l_ ] = triFactory( 9., 10.5, 11., 10.5, 11., 16.5 );
        l_++;
        tri[ l_ ] = triFactory( 9., 10.5, 11., 16.5, 9., 15.5 );
        l_++;
        tri[ l_ ] = triFactory( 9., 15.5, 11., 16.5, 10.5, 17. );
    }
    inline
    function d1(){
        var tri = triArr;
        var l_ = tri.length;
        var third = 1/3;
        tri[ l_ ] = triFactory( 1., 17.5, 2.5, 16., 5. + third, 16. );
        l_++;
        tri[ l_ ] = triFactory( 1., 17.5, 5. + third, 16., 5. + third, 17.5 );
        l_++;
        tri[ l_ ] = triFactory( 1., 17.5, 5. + third, 17.5, 5., 18. );
        l_++;
        tri[ l_ ] = triFactory( 1., 17.5, 5., 18., 1.5, 18. );
        l_++;
    }
    inline
    function d2(){
        var tri = triArr;
        var l_ = tri.length;
        var third = 1/3;
        tri[ l_ ] = triFactory( 6. - third, 17.5, 6. - third, 16., 8.5, 16. );
        l_++;
        tri[ l_ ] = triFactory( 6. - third, 17.5, 8.5, 16., 10., 17.);
        l_++;
        tri[ l_ ] = triFactory( 6. - third, 17.5, 10.5, 17., 9.5, 18. );
        l_++;
        tri[ l_ ] = triFactory( 6. - third, 17.5, 9.5, 18., 6., 18. );
    }
    inline
    function e(){
        var tri = triArr;
        var l_ = tri.length;
        tri[ l_ ] = triFactory( 0., 10.5, 0.5, 9.5, 2., 10.5 );
        l_++;
        tri[ l_ ] = triFactory( 0., 10.5, 2., 10.5, 2., 15.5 );
        l_++;
        tri[ l_ ] = triFactory( 0., 10.5, 2., 15.5, 0., 16. );
        l_++;
        tri[ l_ ] = triFactory( 0., 16., 2., 15.5, 0.5, 17 );
    }
    inline
    function f(){
        var tri = triArr;
        var l_ = tri.length;
        tri[ l_ ] = triFactory( 0., 1.5, 0.5, 1., 2., 2.5 );
        l_++;
        tri[ l_ ] = triFactory( 0., 1.5, 2., 2.5, 2., 7.5 );
        l_++;
        tri[ l_ ] = triFactory( 0., 1.5, 2., 7.5, 0., 7.5 );
        l_++;
        tri[ l_ ] = triFactory( 0., 7.5, 2., 7.5, 0.5, 8.5 );
    }
    inline
    function g1(){
        var tri = triArr;
        var l_ = tri.length;
        var third = 1/3;
        tri[ l_ ] = triFactory( 0.5, 9., 2.5, 8., 2.5, 10. );
        l_++;
        tri[ l_ ] = triFactory( 2.5, 8., 5. + third, 8., 5 + third, 10. );
        l_++;
        tri[ l_ ] = triFactory( 2.5, 8., 5. + third, 10., 2.5, 10. );
    }
    inline
    function g2(){
        var tri = triArr;
        var l_ = tri.length;
        var third = 1/3;
        tri[ l_ ] = triFactory( 6. - third, 8., 8.5, 8., 8.5, 10. );
        l_++;
        tri[ l_ ] = triFactory( 6. - third, 8.5, 8.5, 10., 6. - third, 10. );
        l_++;
        tri[ l_ ] = triFactory( 8.5, 8., 10.5, 9., 8.5, 10.);
    }
    inline
    function h(){
        var tri = triArr;
        var l_ = tri.length;
        tri[ l_ ] = triFactory( 2.5, 2.5, 3.5, 2.5, 4., 4. );
        l_++;
        tri[ l_ ] = triFactory( 4., 4., 5., 7.5, 4., 7.5 );
        l_++;
        tri[ l_ ] = triFactory( 2.5, 2.5, 4., 4., 2.5, 5. );
        l_++;
        tri[ l_ ] = triFactory( 2.5, 5., 4., 4., 4., 7.5 );
    }
    inline
    function i(){
        var tri = triArr;
        var l_ = tri.length;
        tri[ l_ ] = triFactory( 4.5, 2.5, 6.5, 2.5, 6.5, 4. );
        l_++;
        tri[ l_ ] = triFactory( 4.5, 2.5, 6.5, 4., 4.5, 4. );
        l_++;
        tri[ l_ ] = triFactory( 4.5, 4., 6.5, 4., 5.5, 7.5 );
    }
    inline
    function j(){
        var tri = triArr;
        var l_ = tri.length;
        tri[ l_ ] = triFactory( 6.5, 7.5, 7., 4., 7., 7.5 );
        l_++;
        tri[ l_ ] = triFactory( 7., 4., 7.5, 2.5, 8.5, 2.5 );
        l_++;
        tri[ l_ ] = triFactory( 7., 4., 8.5, 2.5, 8.5, 4. );
        l_++;
        tri[ l_ ] = triFactory( 7., 4., 8.5, 4., 7., 7.5 );
    }
    inline
    function k(){
        var tri = triArr;
        var l_ = tri.length;
        tri[ l_ ] = triFactory( 2.5, 13., 4., 10.5, 5., 10.5 );
        l_++;
        tri[ l_ ] = triFactory( 2.5, 13., 5.5, 10.5, 4., 14. );
        l_++;
        tri[ l_ ] = triFactory( 2.5, 13., 4., 14., 3.5, 15. );
        l_++;
        tri[ l_ ] = triFactory( 2.5, 13., 3.5, 15., 2.5, 15. );
    }
    inline
    function l(){
        var tri = triArr;
        var l_ = tri.length;
        tri[ l_ ] = triFactory( 4.5, 14., 5.5, 10.5, 6.5, 14. );
        l_++;
        tri[ l_ ] = triFactory( 4.5, 14., 6.5, 14., 6.5, 15.5 );
        l_++;
        tri[ l_ ] = triFactory( 4.5, 14., 6.5, 15.5, 4.5, 15.5 );
    }
    inline
    function m(){
        var tri = triArr;
        var l_ = tri.length;
        tri[ l_ ] = triFactory( 6., 10.5, 6.5, 10., 8.5, 13.);
        l_++;
        tri[ l_ ] = triFactory( 6., 10.5, 8.5, 13., 7., 14. );
        l_++;
        tri[ l_ ] = triFactory( 7., 14., 8.5, 13., 8.5, 15.5 );
        l_++;
        tri[ l_ ] = triFactory( 7., 14., 8.5, 15.5, 7.5, 15.5 );
    }
}