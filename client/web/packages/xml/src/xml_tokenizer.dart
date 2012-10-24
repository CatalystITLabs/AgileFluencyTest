/**
* Returns tokenized parts of Xml document.
*/
class XmlTokenizer {
  static const int TAB = 9;
  static const int NEW_LINE = 10;
  static const int CARRIAGE_RETURN = 13;
  static const int SPACE = 32;
  static const int QUOTE = 34;
  static const int SQUOTE = 39;
  static const int SLASH = 47;
  static const int COLON = 58;
  static const int LT = 60; //<
  static const int GT = 62; //>
  static const int EQ = 61; //=
  static const int Q = 63;  //?
  static const int B = 33;  //!
  static const int DASH = 45; //-
  static const int RBRACK = 93; //]

  static const List _reserved = const [LT, GT, B, COLON, SLASH, QUOTE,
                                      SQUOTE, EQ];

  static const List _whiteSpace = const[SPACE, TAB ,NEW_LINE, CARRIAGE_RETURN];

  final Queue<_XmlToken> _tq;
  final String _xml;
  int _length;
  int _i = 0;

  XmlTokenizer(this._xml) :
    _i = 0,
    _tq = new Queue<_XmlToken>() {
    _length = _xml.length;
  }


  _XmlToken next() {
    void addToQueue(_XmlToken token){
      token._location = _i;
      _tq.addLast(token);
    }

    _XmlToken getNextToken() {
//      if (!_tq.isEmpty()){
//        print('token: ${_tq.first()}, ${_tq.first()._str}');
//      }
      return _tq.isEmpty() ? null : _tq.removeFirst();
    }


    // Returns the first char in the list that appears ahead.
    int peekUntil(List chars){
      int z = _i;

      while (z < _length && chars.indexOf(_xml.charCodeAt(z)) == -1){
        z++;
      }

      return _xml.charCodeAt(z);
    }

    // Returns the index of the last char of a given word, if found from
    // the current index onward; otherwise returns -1;
    int matchWord(String word){
      int z = _i;

      for(int ii = 0; ii < word.length; ii++){
        if(_xml.charCodeAt(z) != word.charCodeAt(ii)) return -1;
        z++;
      }

      return z - 1;
    }

    int nextNonWhitespace(int from){

      while(isWhitespace(_xml.charCodeAt(from))){
        from++;
      }
      return from;
    }

    int nextWhitespace(int from){
      while(!isWhitespace(_xml.charCodeAt(from))){
        from++;
      }
      return from;
    }

    // Peel off and return a token if there are any in the queue.
    if (!_tq.isEmpty()) return getNextToken();

    while(_i < _length && isWhitespace(_xml.charCodeAt(_i)))
      {
        _i++;
      }

    if (_i == _length) return null;
  //print('char: $_i code: ${_xml.charCodeAt(_i)} ' + _xml.substring(_i, _i+1));
    final int char = _xml.charCodeAt(_i);

    switch(char){
      case B:
        _i++;
        addToQueue(new _XmlToken(_XmlToken.BANG));
        break;
      case COLON:
        _i++;
        addToQueue(new _XmlToken(_XmlToken.COLON));
        break;
      case SLASH:
        _i++;
        addToQueue(new _XmlToken(_XmlToken.SLASH));
        break;
      case LT:
        const specialTags = const ['<!--', '<![CDATA[', '<?', '</'];
        var found = '';
        var endIndex = -1;

        for(final tag in specialTags){
          var m = matchWord(tag);
          if (m != -1){
            found = tag;
            endIndex = m;
            break;
          }
        }

        switch(found)
        {
          case specialTags[0]:
            addToQueue(new _XmlToken(_XmlToken.START_COMMENT));
            _i = endIndex + 1;

            var endComment = _xml.indexOf('-->', _i);
            var nestedTest = _xml.indexOf('<!--', _i);

            if (endComment == -1){
              throw const XmlException('End comment tag not found.');
            }

            if (nestedTest != -1 && nestedTest < endComment){
              throw const XmlException('Nested comments not allowed.');
            }

            addToQueue(new _XmlToken.string(_xml.substring(_i, endComment)));
            addToQueue(new _XmlToken(_XmlToken.END_COMMENT));
            _i = endComment + 3;
            break;
          case specialTags[1]:
            addToQueue(new _XmlToken(_XmlToken.START_CDATA));
            _i = endIndex + 1;

            var endCDATA = _xml.indexOf(']]>', _i);
            var nestedTest = _xml.indexOf('<![CDATA[', _i);

            if (endCDATA == -1){
              throw const XmlException('End CDATA tag not found.');
            }

            if (nestedTest != -1 && nestedTest < endCDATA){
              throw const XmlException('Nested CDATA not allowed.');
            }

            addToQueue(new _XmlToken.string(_xml.substring(_i, endCDATA).trim()));
            addToQueue(new _XmlToken(_XmlToken.END_CDATA));
            _i = endCDATA + 3;
            break;
          case specialTags[2]:
            addToQueue(new _XmlToken(_XmlToken.START_PI));
            _i = endIndex + 1;

            var endPI= _xml.indexOf('?>', _i);
            var nestedTest = _xml.indexOf('<?', _i);

            if (endPI == -1){
              throw const XmlException('End PI tag not found.');
            }

            if (nestedTest != -1 && nestedTest < endPI){
              throw const XmlException('Nested PI not allowed.');
            }

            addToQueue(new _XmlToken.string(_xml.substring(_i, endPI).trim()));
            addToQueue(new _XmlToken(_XmlToken.END_PI));
            _i = endPI+ 2;
            break;
          case specialTags[3]:
            addToQueue(new _XmlToken(_XmlToken.LT));
            addToQueue(new _XmlToken(_XmlToken.SLASH));
            _i = endIndex + 1;
            break;
          default:
            //standard start tag
            _i++;
            addToQueue(new _XmlToken(_XmlToken.LT));
            _i = nextNonWhitespace(_i);
            int c = peekUntil([SPACE, COLON, GT]);
            if (c == SPACE){
              var _ii = _i;
              _i = nextWhitespace(_ii);
              addToQueue(new _XmlToken.string(_xml.substring(_ii, _i)));
              _i = nextNonWhitespace(_i);
            }else if (c == COLON){
              var _ii = _i;
              _i = _xml.indexOf(':', _ii) + 1;
              addToQueue(new _XmlToken.string(_xml.substring(_ii, _i - 1)));
              addToQueue(new _XmlToken(_XmlToken.COLON));
              _ii = nextWhitespace(_i);
              addToQueue(new _XmlToken.string(_xml.substring(_i, _ii)));
              _i = nextNonWhitespace(_ii);
            }
            break;
        }
        break;
      case GT:
        _i++;
        addToQueue(new _XmlToken(_XmlToken.GT));
        break;
      case EQ:
        _i++;
        addToQueue(new _XmlToken(_XmlToken.EQ));
        break;
      case QUOTE:
        _i++;
        addToQueue(new _XmlToken.quote(QUOTE));
        break;
      case SQUOTE:
        _i++;
        addToQueue(new _XmlToken.quote(SQUOTE));
        break;
      default:
        var m = matchWord('xmlns:');
        if (m != -1){
          _i = m + 1;
          addToQueue(new _XmlToken(_XmlToken.NAMESPACE));
        }else{
          StringBuffer s = new StringBuffer();

          while(_i < _length && !isReserved(_xml.charCodeAt(_i))){
            s.add(_xml.substring(_i, _i + 1));
            _i++;
          }
          addToQueue(new _XmlToken.string(s.toString().trim()));
        }
        break;
    }
    return getNextToken();
  }

  /**
  * Returns true if the charCode is one of the special reserved
  * charCodes
  */
  static bool isReserved(int c) => _reserved.indexOf(c) > -1;

  /**
  * Returns true if the charCode is considered to be whitespace.
  */
  static bool isWhitespace(int c) => _whiteSpace.indexOf(c) >= 0;

}

class _XmlToken {
  static const int LT = 1;
  static const int GT = 2;
  static const int QUESTION = 3;
  static const int STRING = 4;
  static const int BANG = 5;
  static const int COLON = 6;
  static const int SLASH = 7;
  static const int EQ = 8;
  static const int QUOTE = 9;
  static const int IGNORE = 10;
  static const int DASH = 11;
  static const int START_COMMENT = 12;
  static const int END_COMMENT = 13;
  static const int START_CDATA = 14;
  static const int END_CDATA = 15;
  static const int START_PI = 16;
  static const int END_PI = 17;
  static const int NAMESPACE = 18;

  final int kind;
  final int quoteKind;
  final String _str;
  int _location;

  _XmlToken._internal(this.kind, this._str, this.quoteKind);


  factory _XmlToken.string(String s) {
    return new _XmlToken._internal(STRING, s, -1);
  }

  factory _XmlToken.quote(int quoteKind){
    return new _XmlToken._internal(QUOTE, '', quoteKind);
  }


  factory _XmlToken(int kind) {
    return new _XmlToken._internal(kind, '', -1);
  }


  String toString() {
    switch(kind){
      case START_PI:
        return "(<?)";
      case END_PI:
        return "(?>)";
      case DASH:
        return "(-)";
      case LT:
        return "(<)";
      case GT:
        return "(>)";
      case QUESTION:
        return "(?)";
      case STRING:
        return 'STRING($_str)';
      case BANG:
        return "(!)";
      case COLON:
        return "(:)";
      case SLASH:
        return "(/)";
      case EQ:
        return "(=)";
      case QUOTE:
        return '(")';
      case START_COMMENT:
        return '(<!--)';
      case END_COMMENT:
        return '(-->)';
      case START_CDATA:
        return ('(<![CDATA[)');
      case END_CDATA:
        return ('(]]>)');
      case NAMESPACE:
        return ('xmlns:');
      case IGNORE:
        return 'INVALID()';

    }
  }

  String toStringLiteral() {
    switch(kind){
      case NAMESPACE:
        return "xmlns:";
      case GT:
        return ">";
      case LT:
        return "<";
      case QUESTION:
        return "?";
      case STRING:
        return _str;
      case BANG:
        return "!";
      case COLON:
        return ":";
      case SLASH:
        return "/";
      case EQ:
        return "=";
      case QUOTE:
        return quoteKind == XmlTokenizer.QUOTE ? '"' : "'";
      case IGNORE:
        return 'INVALID()';
      default:
        throw new XmlException('String literal unavailable for $this');

    }
  }
}