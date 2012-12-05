import 'dart:html';
import 'dart:math';
import 'dart:json';
import "../lib/test.dart";
import "../packages/presentation/presentation.dart";

// Server Info :  
String _serverAddress = "172.16.4.27";
String _serverPort = "8083";

// powers 3d transitions 
SlideShow slideshow = new BasicSlideShow(query("#viewBox"));

// slide placement settings
num currentSlidePosition = 0;

// camera default settings
num camTransDuration = 1;
num camX = 1330;
num camY = 400;
num camZ = 50000;
num camXr = 0; 
num camYr = 0;
num camZr = 0;

/// adds a huge map to the scene
void addBackground()
{
  var element = new ImageElement();
  element.src = "images/world_8bit.png";
  var slide = new Slide(element, 50.0, 0 , 0, 0, 0, 0);  
  slideshow.addBackgroundSlide(slide);
  //no transitions because this slide is never focused / transitioned to.
}

///Gets information from the URI parameter ../report.dart?id=HEXSTRING
Map<String, String> getUriParams(String uriSearch) {
  if (uriSearch != '') {
    final List<String> paramValuePairs = uriSearch.substring(1).split('&');

    var paramMapping = new HashMap<String, String>();
    paramValuePairs.forEach((e) {
      if (e.contains('=')) {
        final paramValue = e.split('=');
        paramMapping[paramValue[0]] = paramValue[1];
      } else {
        paramMapping[e] = '';
      }
    });
    return paramMapping;
  }
}

/**
 * wrapper method for the camera move method that sets the default camera
 * positions as arguments
 */
void lookAtMap()
{
  slideshow.cam.move(camTransDuration, camX, camY, camZ, camXr, camYr, camZr);
}

void displayResults(jsonResults)
{
  var viewBox = query("#viewBox");
  viewBox.style.transition = "0.5";
  
  viewBox.style.backgroundImage = "none";
  viewBox.innerHTML = "";

  addBackground();
  lookAtMap();
  
  window.setTimeout(()
  {
    //add map and first slide
    addSummary(jsonResults);
  }, 1500);
}

/// adds a new slide on the map
Slide addSlideToMap(Element slideContents)
{
  // use a sin wave and scale it to look like a global journey
  num slidePositionXScale = 2000;
  num slidePositionYScale = 10000;
  num waveScale = 2.0;
  num waveShift = -3.0;
  var x = currentSlidePosition * slidePositionXScale;
  var y = sin(currentSlidePosition / waveScale + waveShift) * slidePositionYScale;
  return slideshow.addElementSlide(slideContents, 1.0, x, y, 0, 0, 0, 0);
}

///create summary slide, then add to map
void addSummary(jsonResults)
{
  /// Summary for each completed section: stamp and progress.
  //content for the right side
  var output = new DivElement();
  
  //stamp image placeholder. The plan will be to zoom into this, to show the summary information.
  
  //use section parameter from testResults
  output.id = "report";
  output.classes.add("summary");
  
  //passport image as a backdrop
  var passport = new ImageElement();
  passport.classes.add("passportImage");
  //TODO: add logic to use the correct passport (with animation).
  passport.src = "images/passport_m.png";
  passport.style.zIndex = "-10";
  output.insertAdjacentElement("beforeEnd", passport);
  
  //content for the right side
  var content = new ParagraphElement();
  content.classes.add("detail");

  var theDate = jsonResults['date'];
  
  content.addHtml("<h3>Date of assessment: $theDate</h3>");

  var sectionList = jsonResults['stampList'];
  
  for (var i=0; i<sectionList.length; i++)
  {
    var Fluency = sectionList[i]['fluency'];
    var TotalAgile = sectionList[i]['totalAgile'];
    var MostAgile = sectionList[i]['mostAgile'];
    var Section = sectionList[i]['section'];
    
    content.addHtml("<h4>Section $Section : $Fluency% fluency</h4>");
    
    //Progress information...
    content.addHtml("<li>Total Agile Answers: $TotalAgile</li>");
    content.addHtml("<li>Most Fluent Answers: $MostAgile</li></ul>");
  }
  
  output.insertAdjacentElement("beforeEnd", content);
  
  var slideElement = query("#summary");
  var slide = slideshow.addElementSlide(output, 1.0, 0, 0, 2000, 0, 0, 0);
  
  // set camera at splash slide and script start button
  slideshow.cam.lookAtSlide(slide, 2);
  // sets splash as the current slide and gives it focus
  slideshow.start();
}

String getIdFromUri()
{
  var uriSearch = window.location.search;
  Map paramMapping = getUriParams(uriSearch);
  
  if (paramMapping == null)
    return null;
  
  String hexString = paramMapping['id'];
  
  return hexString;
}

/// request information should be passed to server application. This will then be presented on a slide.
void main()
{
  var hexstring = getIdFromUri();
  
  print("hexstring : $hexstring");

  if (hexstring != null)
  {
    //query the server application for the results
    HttpRequest req = new HttpRequest();
    
    req.on.load.add((Event e) {
        var responseText = req.responseText;
        var jsonObj = JSON.parse(req.responseText);
        displayResults(jsonObj);
      }
    );
    
    req.on.error.add((Event e) {
        print("Error!");
      }
    );
    
    req.open("GET", "http://$_serverAddress:$_serverPort/results?id=$hexstring");
    req.send();
  }
}