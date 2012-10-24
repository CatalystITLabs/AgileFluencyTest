// A lightweight, XML parser and emitter.
// See README.md for more info on features and limitations.

#library('xml_utils_prujohn');

#source('src/xml_element.dart');
#source('src/xml_parser.dart');
#source('src/xml_tokenizer.dart');
#source('src/xml_node.dart');
#source('src/xml_node_type.dart');
#source('src/xml_text.dart');
#source('src/xml_attribute.dart');
#source('src/xml_exception.dart');
#source('src/xml_cdata.dart');
#source('src/xml_processing_instruction.dart');
#source('src/xml_collection.dart');
#source('src/xml_namespace.dart');

/**
* Utility class to work with XML data.
*/
class XML {

  /**
  * Returns a [XmlElement] tree representing the raw XML fragment [String].
  *
  * Optional parameter [withQuirks] will allow the following when set to true:
  *
  * * Optional quotes for simple attribute values (no spaces).
  */
  static XmlElement parse(String xml, [withQuirks = false]) =>
      XmlParser._parse(xml.trim(), withQuirks);

  /**
  * Returns a stringified version of an [XmlElement] tree.
  * You can also call .toString() on any [XmlElement].
  */
  static String stringify(XmlElement element) => element.toString();
}
