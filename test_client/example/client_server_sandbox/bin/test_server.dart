
import "package:crimsonhttp/crimson.dart";
import "package:mongo_dart/mongo_dart.dart";

import "dart:io";
import "dart:json";

/**
 *  Class   : MongoTestServer
 *  
 *  Purpose : This is the webservice server which will handle webservice requests from either the
 *            client or report dart web applications served up client side.  These applications
 *            will send requests to either store a list of sections (which contain lists of stamps, date,
 *            and id) or get the same to/from the Mongo database.
 *   
 */
class MongoTestServer
{
  DbCollection _testResults;
  const num _port = 8083;
  const String _serverAddress = "172.16.6.26";
  
  /*
   * Database collection should follow the following format for its objects : 
   *  

  Map dbRow = {"_id":null, "date":"2012/01/01",
                           "stampList":[
                                        {
                                          "section":"1",
                                          "fluency":50,
                                          "totalAgile":"5/9",
                                          "mostAgile":"2/9"
                                        },
                                        {
                                          "section":"2",
                                          "fluency":30,
                                          "totalAgile":"3/9",
                                          "mostAgile":"1/9"
                                        }
                                       ]
              };
  */

  /**
   *  Constructor   : MongoTestServer
   *  
   *  Purpose       : The constructor will open the database and only start up the actual main program (which will
   *                  set up the web services) once the database has been opened and collection that the server
   *                  will use has been assigned.
   */
  MongoTestServer()
  {
    Db db = new Db("mongodb://labs.catalystsolves.com/AgileFluency");

    // Open the database and once it has been opened, assign the collection to a class variable and
    // kick off the server's web services via the run() method.
    db.open().then((theFuture) 
        { 
          _testResults = db.collection("AgileFluency");
          print ("Database name : ${db.databaseName}");
          
          return this.run();
        });
  }
  
  /**
   *  Method  : run
   *  
   *  Purpose : This method is started by the constructor once the database has been connected to and
   *            the collection we will read from has been assigned.  It sets up the web service
   *            endpoints and routes handling them for the server.
   */
  void run()
  {
    CrimsonHttpServer server = new CrimsonHttpServer();
    CrimsonModule module = new CrimsonModule(server);

    Directory cwd() => new Directory(new File(".").fullPathSync());

    var d = cwd();
    print("Working Directory :${d.path}");
        
    module.handlers.addEndpoint(new Route("/results", "GET", getResults));
    module.handlers.addEndpoint(new Route("/persist", "POST", saveResults));
    module.handlers.addEndpoint(new StaticFile("test_client/example/client_server_sandbox/web"));
    
    server.modules["*"] = module;
    
    server.listen(_serverAddress, _port);
  }
  
  /**
   *  Method  : getResults
   *  
   *  Purpose : This method will handle a get request for an object given its ID in the query parameter.
   *            It will build a Mongo ObjectId out of that and query the database for the object that
   *            matches, stringifying that object into a json string and putting that in the response body. 
   */
  Future getResults(HttpRequest request, HttpResponse response, Map data)
  {
    Completer completer = new Completer();

    // Get the query parameter id which is the mongo ID :
    String objectIdStr = request.queryParameters['id'];

    // If an id was found...
    if (objectIdStr != null)
    {
      try
      {
        // get the Mongo objectId :
        BsonBinary bsonBinaryId = new BsonBinary.fromHexString(objectIdStr);
        ObjectId objectId = new ObjectId.fromBsonBinary(bsonBinaryId);

        // search for objects with that ID (should only find one) :
        Cursor reportCursor = _testResults.find({'_id':objectId});

        // for each document found, stringify it and dump that string into 
        // the response's body :
        reportCursor.each((Map rpt) 
            {
              response.outputStream.writeString(JSON.stringify(rpt));
            }
        // Once all documents have been put in the body as json strings, 
        // complete the handling of the request :
          ).then((dummy) 
            {
              completer.complete(data);
            }
          );
      }
      // If any exceptions occur, print to console and complete the
      // handling of the request with the exception sent back :
      // (bad ID's, document not found, etc are examples of exceptions that might occur)
      catch(e)
      {
        print("Exception : $e");
        response.statusCode = 404;
        completer.complete(data);
      }
    }
    // No id found, so just complete the handling of the request :
    else
    {
      response.statusCode = 404;
      completer.complete(data);
    }
    
    return completer.future;
  }
  
  String getObjectIdNumber(String docId)
  {
    String endParenRemoved = docId.substring(0, docId.length-1);
    String objIdNum = endParenRemoved.substring(endParenRemoved.indexOf("(")+1);
    
    return objIdNum;
  }

  /**
   *  Method  : saveResults
   *  
   *  Purpose : This method will take the post data which is a json string and 
   *            parse it into an object which will subsequently be stored to
   *            the Mongo database.
   */
  Future saveResults(HttpRequest request, HttpResponse response, Map data)
  {
    Completer completer = new Completer();
    
    // Set up buffers for callbacks to make use of later : 
    StringBuffer requestBody = new StringBuffer();
    StringInputStream input = new StringInputStream(request.inputStream);

    // Set up callback for when data is available (will just drop that data into
    // the requestBody buffer :
    input.onData = () => requestBody.add(input.read());
    
    // Set up callback for when there is no more data to be read (request body will
    // be parsed by JSON into an object and dropped into Mongo DB.  Then ID for the
    // new entry into Mongo will be put into response body :
    input.onClosed = () 
      {
        // read the request body into a single string :
        String postData = requestBody.toString();

        // if there is data read from the request...
        if (postData != null)
        {

          try
          {
            // parse the string into a Map object :
            Map assessmentResults = JSON.parse(postData);
            
            // set the _id to null so that we get an autogenerated Mongo ID :
            assessmentResults["_id"] = null;
            
            // save the object to the database :
            _testResults.save(assessmentResults);

            // take the autogenerated Mongo ID and stringify it :
            var docId = assessmentResults["_id"].toString();

            // Drop the stringified ID into the response :
            response.outputStream.writeString(getObjectIdNumber(docId));
        
            // complete the request handling :
            completer.complete(data);
          }
          // If an exception occurred...
          catch(e)
          {
            // Print it to the console :
            print("Exception : $e");
        
            // complete the request handling with the exception :
            response.statusCode = 404;
            completer.complete(data);
          }
        }
        // if there is no data read from the request...
        else
        {
          // complete the request handling...nothing to do.
          response.statusCode = 404;
          completer.complete(data);
        }
      };

  // return the future object...request will be handled in future by callback
  return completer.future;
  }
  
}

/**
 *  Method  : main
 *  
 *  Purpose : This method is the main method and invoked when the program is executed.
 *            It will create a new instance of the server and that object's constructor
 *            will handle starting up the rest.
 */
void main() 
{
  // Kick off the test server...
  new MongoTestServer();
  print("Server Started...");
}
