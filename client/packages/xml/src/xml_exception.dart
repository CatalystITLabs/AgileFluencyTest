class XmlException implements Exception {
  final String msg;
  final String debugXml;
  final int errorLocation;

  const XmlException(this.msg) :
    debugXml = '',
    errorLocation = 0;

  const XmlException.withDebug(this.msg, this.debugXml, this.errorLocation);

  String toString() {
    if (debugXml == '') return 'Xml Exception: $msg';

    StringBuffer s = new StringBuffer();
    s.add('Xml Exception: $msg');
    s.add('\r');

    int bLoc = (errorLocation < 41) ? 0 : errorLocation - 40;
    int aLoc = (errorLocation > debugXml.length - 41)
        ? debugXml.length - 1
        : errorLocation + 40;

    s.add(debugXml.substring(bLoc, aLoc));
    return s.toString();

  }
}
