package trilateral.nodule;
@:enum
abstract NoKey( Int ) to Int from Int {
    var backspace = 8;
    var tab = 9;
    var enter = 13;
    var shift = 16;
    var ctrl = 17;
    var alt = 18;
    var pause =	19;
    var capslock = 20;
    var escape = 27;
    var leftwindow = 91;
    var rightwindow = 92;
    var selectkey = 93;
    var numlock = 144;
    var cmd = 224;
    var andQuote = 34;
}
class ReadXML {
    public static inline function toNoduleAndXML( str_: String ): Xml {
        var s: String;
        var spaces: Int = 0;
        var strIter = new StringCodeIterator( str_ );
        strIter.next();
        var rootNodule = new Nodule();
        rootNodule.name = 'root';
        var rootXML = Xml.createElement('root');
        rootXML.nodeName = 'root';
        // change as parsed
        var parentXml = rootXML;
        // change as parsed
        var parent = rootNodule; 
        var nodule: Nodule = null;
        var xml: Xml = null;
        var contentBuf = new StringBuf();
        while( strIter.hasNext() ){
            switch( strIter.c ){
                // could put this after < but seems no change 
                case '\n'.code | '\r'.code | ' '.code | '\t'.code:
                        spaces++; // keeps track of spaces added
                        contentBuf.addChar( strIter.c );
                    // new line ignore
                case '<'.code:
                    s = contentBuf.toString();
                    if( spaces != s.length ) {
                        // add content to nodule
                        // trace( '   ' + s );/
                        if( nodule != null ) {
                            nodule.content = s;
                        }
                        if( xml != null ){
                            xml.addChild( Xml.createPCData( s ) );
                        }
                    }
                    spaces = 0;
                    strIter.next();
                    contentBuf = new StringBuf();
                    strIter.resetBuffer();
                    switch( strIter.c ){
                        case '/'.code:
                            // closing tag
                            strIter.next();
                            strIter.resetBuffer();
                            while( strIter.c  != '>'.code ){
                                strIter.addChar();
                                strIter.next();
                            }
                            var s = strIter.toStr();
                            // trace( '</' + s + '>' );
                            if( s == parent.name ){
                                parent = parent.parent;
                            }
                            
                            if( s == parentXml.nodeName ){
                                parentXml = parentXml.parent;
                            }
                            
                        case '?'.code:
                            // header
                            strIter.next();
                            strIter.resetBuffer();
                            while( strIter.c  != '?'.code ){
                                strIter.addChar();
                                strIter.next();
                            }
                            var s = strIter.toStr();
                            // trace( '<?' + s + '?>');
                            strIter.next();
                        case '!'.code:
                            // comment 
                            // ignore ?
                            strIter.resetBuffer();
                            while( strIter.c  != '>'.code ){
                                strIter.addChar();
                                strIter.next();
                            }
                            var s = strIter.toStr();
                            s = s.substr( 3, s.length - 5 );
                            // trace( '<!--' + s + '-->');
                            strIter.next();
                        default:
                            // opening tag
                            strIter.resetBuffer();
                            while( strIter.c  != '>'.code && strIter.c != ' '.code ){
                                strIter.addChar();
                                strIter.next();
                            }
                            var s = strIter.toStr();
                            // trace( '<' + s + '>' );
                            var node = new Nodule();
                            node.name = s;
                            nodule = node;
                            parent.addChild( nodule );
                            parent = nodule;
                            
                            //if( s != '' && s != null && s != ' ' && s != '\t' ){
                                var node2 = Xml.createElement( s );
                                //trace( 'add node ' + s );
                                //var node2 = Xml.createElement( 'fred' );// s
                                xml = node2;
                                parentXml.addChild( xml );
                                parentXml = xml;
                                //}
                            
                            
                            var att: Nodule = null;
                            var attName: String = '';
                            var toggle = true;
                            while( strIter.c  != '>'.code ){
                                switch( strIter.c ){
                                    case ' '.code, '='.code:
                                        strIter.next();
                                    default:
                                        strIter.resetBuffer();
                                        while( strIter.c  != '>'.code && strIter.c != ' '.code && strIter.c != '='.code ){
                                            if( strIter.c != 34 && strIter.c != 39 ) strIter.addChar(); // any speach marks 
                                            strIter.next();
                                        }
                                        var s = strIter.toStr();
                                        if( toggle ){
                                            var att_ = new Nodule();
                                            att = att_;
                                            att.name = s;
                                            nodule.addAttribute( att );
                                        } else {
                                            att.content = s;
                                            // add attribute
                                            // trace( '@' + att.name + " : "  + att.content );
                                        }
                                        if( toggle ){
                                            attName = s;
                                        } else {
                                            //trace( 'att value ' + s );
                                            if( attName != null ) xml.set( attName, s );
                                            // add attribute
                                             // trace( '@' + attName + " : "  + s );
                                        }
                                        toggle = !toggle;
                                }
                            }
                    }
                    case backspace | shift | ctrl | alt | pause | leftwindow | rightwindow | selectkey | numlock | cmd | 143 | null:
                        
                    default:
                        //trace('default ' + strIter.c );
                        //case '\n'.code | '\r'.code:
                        contentBuf.addChar( strIter.c );
            }
            strIter.next();
        }
        strIter = null;
        //trace( rootXML.toString() );
        return rootXML;
    }
    public static inline function toNodule( str_: String ): Nodule {
        var s: String;
        var spaces: Int = 0;
        var strIter = new StringCodeIterator( str_ );
        strIter.next();
        var rootNodule = new Nodule();
        rootNodule.name = 'root';
        // change as parsed
        var parent = rootNodule; 
        var nodule: Nodule = null;
        var contentBuf = new StringBuf();
        while( strIter.hasNext() ){
            switch( strIter.c ){
                // could put this after < but seems no change 
                case '\n'.code | '\r'.code | ' '.code | '\t'.code:
                        spaces++; // keeps track of spaces added
                        contentBuf.addChar( strIter.c );
                    // new line ignore
                case '<'.code:
                    s = contentBuf.toString();
                    if( spaces != s.length ) {
                        // add content to nodule
                        if( nodule != null ) {
                            nodule.content = s;
                        }
                    }
                    spaces = 0;
                    strIter.next();
                    contentBuf = new StringBuf();
                    strIter.resetBuffer();
                    switch( strIter.c ){
                        case '/'.code:
                            // closing tag
                            strIter.next();
                            strIter.resetBuffer();
                            while( strIter.c  != '>'.code ){
                                strIter.addChar();
                                strIter.next();
                            }
                            var s = strIter.toStr();
                            if( s == parent.name ){
                                parent = parent.parent;
                            }
                        case '?'.code:
                            // header
                            strIter.next();
                            strIter.resetBuffer();
                            while( strIter.c  != '?'.code ){
                                strIter.addChar();
                                strIter.next();
                            }
                            var s = strIter.toStr();
                            strIter.next();
                        case '!'.code:
                            // comment 
                            strIter.resetBuffer();
                            while( strIter.c  != '>'.code ){
                                strIter.addChar();
                                strIter.next();
                            }
                            var s = strIter.toStr();
                            s = s.substr( 3, s.length - 5 );
                            strIter.next();
                        default:
                            // opening tag
                            strIter.resetBuffer();
                            while( strIter.c  != '>'.code && strIter.c != ' '.code ){
                                strIter.addChar();
                                strIter.next();
                            }
                            var s = strIter.toStr();
                            var node = new Nodule();
                            node.name = s;
                            nodule = node;
                            parent.addChild( nodule );
                            parent = nodule;
                            var att: Nodule = null;
                            var attName: String = '';
                            var toggle = true;
                            while( strIter.c  != '>'.code ){
                                switch( strIter.c ){
                                    case ' '.code, '='.code:
                                        strIter.next();
                                    default:
                                        strIter.resetBuffer();
                                        while( strIter.c  != '>'.code && strIter.c != ' '.code && strIter.c != '='.code ){
                                            if( strIter.c != 34 && strIter.c != 39 ) strIter.addChar(); // any speach marks 
                                            strIter.next();
                                        }
                                        var s = strIter.toStr();
                                        if( toggle ){
                                            var att_ = new Nodule();
                                            att = att_;
                                            att.name = s;
                                            nodule.addAttribute( att );
                                        } else {
                                            att.content = s;
                                        }
                                        toggle = !toggle;
                                }
                            }
                    }
                    case backspace | shift | ctrl | alt | pause | leftwindow | rightwindow | selectkey | numlock | cmd | 143 | null:
                        
                    default:
                        contentBuf.addChar( strIter.c );
            }
            strIter.next();
        }
        strIter = null;
        return rootNodule.firstChild;
    }
    public static inline function toXml( str_: String ): Xml {
        var s: String;
        var spaces: Int = 0;
        var strIter = new StringCodeIterator( str_ );
        strIter.next();
        var rootXML: Xml = null;
        //var rootXML = Xml.createElement('root');
        //rootXML.nodeName = 'root';
        // change as parsed
        var parentXml = rootXML;
        var xml: Xml = null;
        var contentBuf = new StringBuf();
        while( strIter.hasNext() ){
            switch( strIter.c ){
                case '\n'.code | '\r'.code | ' '.code | '\t'.code: // could put this after < but seems no change 
                        spaces++; // keeps track of spaces added
                        contentBuf.addChar( strIter.c );
                    // new line ignore
                case '<'.code:
                    s = contentBuf.toString();
                    if( spaces != s.length ) {
                        // add content to nodule
                        if( xml != null ){
                            xml.addChild( Xml.createPCData( s ) );
                        }
                    }
                    spaces = 0;
                    strIter.next();
                    contentBuf = new StringBuf();
                    strIter.resetBuffer();
                    switch( strIter.c ){
                        case '/'.code:
                            // closing tag
                            strIter.next();
                            strIter.resetBuffer();
                            while( strIter.c  != '>'.code ){
                                strIter.addChar();
                                strIter.next();
                            }
                            var s = strIter.toStr();
                            if( s == parentXml.nodeName ){
                                parentXml = parentXml.parent;
                            }
                        case '?'.code:
                            // header ignore
                            strIter.next();
                            strIter.resetBuffer();
                            while( strIter.c  != '?'.code ){
                                strIter.addChar();
                                strIter.next();
                            }
                            var s = strIter.toStr();
                            strIter.next();
                        case '!'.code:
                            // comment ignore
                            strIter.resetBuffer();
                            while( strIter.c  != '>'.code ){
                                strIter.addChar();
                                strIter.next();
                            }
                            var s = strIter.toStr();
                            s = s.substr( 3, s.length - 5 );
                            strIter.next();
                        default:
                            // opening tag
                            strIter.resetBuffer();
                            while( strIter.c  != '>'.code && strIter.c != ' '.code ){
                                strIter.addChar();
                                strIter.next();
                            }
                            var s = strIter.toStr();
                            // attributes
                            var node2 = Xml.createElement( s );
                            xml = node2;
                            if( parentXml != null ) {
                                parentXml.addChild( xml );
                            } else {
                                rootXML = xml;
                            }
                            parentXml = xml;
                            var attName: String = '';
                            var toggle = true;
                            while( strIter.c  != '>'.code ){
                                switch( strIter.c ){
                                    case ' '.code, '='.code:
                                        strIter.next();
                                    default:
                                        strIter.resetBuffer();
                                        while( strIter.c  != '>'.code && strIter.c != ' '.code && strIter.c != '='.code ){
                                            if( strIter.c != 34 && strIter.c != 39 ) strIter.addChar(); // any speach marks 
                                            strIter.next();
                                        }
                                        var s = strIter.toStr();
                                        if( toggle ){
                                            attName = s;
                                        } else {
                                            if( attName != null ) xml.set( attName, s );
                                        }
                                        toggle = !toggle;
                                }
                            }
                    }
                    case backspace | shift | ctrl | alt | pause | leftwindow | rightwindow | selectkey | numlock | cmd | 143 | null:
                        
                    default:
                        contentBuf.addChar( strIter.c );
            }
            strIter.next();
        }
        strIter = null;
        return rootXML;
    }
    
    public static inline function firstLast( s: String ){
        return s.substr( 1, s.length-2 );
    }
    public static inline function last( s: String ){
        return s.substr( 0, s.length-1 );
    }
}