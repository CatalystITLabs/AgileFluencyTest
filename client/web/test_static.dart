part of test;

class TestStatic
{
  //static Path getMyPath() => new Path('${currentMirrorSystem().libraries['test'].url}/');
  //final urlOfLib = getMyPath();
  final urlOfLib = currentMirrorSystem().libraries['test'].url;
  
  
  String getFile(String fileName) {
    var url = "$urlOfLib/$fileName";

    // call the web server asynchronously
    var request = new HttpRequest.get(url, onSuccess);
    return request.responseText;
  }
  
  // print the raw response text from the server
  onSuccess(HttpRequest req)
  {
     print(req.responseText); // print the received raw text
  }
}

