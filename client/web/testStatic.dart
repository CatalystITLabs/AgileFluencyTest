import 'dart:mirrors';
part of test;

class TestStatic
{
  static Path getMyPath() => new Path('${currentMirrorSystem().libraries['asd'].url}/resources/');
  getLanguageData(String languageName, onSuccess(HttpRequest req)) {
    var url = "http://my-site.com/programming-languages/$languageName";

    // call the web server asynchronously
    var request = new HttpRequest.get(url, onSuccess);
  }
  
  // print the raw json response text from the server
  onSuccess(HttpRequest req)
  {
     print(req.responseText); // print the received raw JSON text
  }
  
}

