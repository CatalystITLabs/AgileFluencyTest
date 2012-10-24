/**
* Represents a base class for XML nodes.  This node is essentially
* read-only.  Use [XmlElement] for manipulating attributes
* and heirarchies.
*/
class XmlNode {
  final XmlNodeType type;
  XmlElement parent;

  XmlNode(this.type);

  void remove(){
    if (parent == null) return;

    var i = parent._children.indexOf(this);
    if (i == -1){
      throw const XmlException('Element not found.');
    }

    parent._children._removeRange(i, 1);
  }

  /// Returns a text representation of the XmlNode tree.
  String toString() {
    StringBuffer s = new StringBuffer();
    _stringifyInternal(s, this, 0);
    return s.toString();
  }

  static void _stringifyInternal(
                  StringBuffer b, XmlNode n, int indent, 
                  {bool leadingWhiteSpace:true}) {
    switch(n.type){
      case XmlNodeType.Element:
        XmlElement el = n as XmlElement;
        
        if (leadingWhiteSpace) {
          b.add('\r${_space(indent)}');
        }
        b.add('<${el.name}');

        if (el.namespaces.length > 0){
          el.namespaces.forEach((k, v) =>
              b.add(new XmlNamespace(k, v).toString()));
        }

        if (el.attributes.length > 0){
          el.attributes.forEach((k, v) =>
              b.add(new XmlAttribute(k, v).toString()));
        }

        b.add('>');

        if (el.hasChildren) {
          for (int i = 0; i < el.children.length; i++) {
            bool whitespace = 
                !(i > 0 && el.children[i-1].type == XmlNodeType.Text);
            _stringifyInternal(
                b, el.children[i], indent + 3, leadingWhiteSpace:whitespace);
          }
        }

        if (el.children.length > 0 
            && el.children.last().type != XmlNodeType.Text) {
          b.add('\r${_space(indent)}</${el.name}>');
        } else {
          b.add('</${el.name}>');
        }

        break;
      case XmlNodeType.Namespace:
      case XmlNodeType.Attribute:
        b.add(n.toString());
        break;
      case XmlNodeType.Text:
        b.add('$n');
        break;
      case XmlNodeType.PI:
      case XmlNodeType.CDATA:
        b.add('\r$n');
        break;
      default:
        throw new XmlException("Node Type ${n.type} is not supported.");
    }
  }

  static String _space(int amount) {
    StringBuffer s = new StringBuffer();
    for (int i = 0; i < amount; i++){
      s.add(' ');
    }
    return s.toString();
   }
}
