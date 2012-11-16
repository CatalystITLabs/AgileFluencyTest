import 'dart:html';
import 'dart:math';
import "../../lib/test.dart";
import "../../packages/presentation/presentation.dart";

Test test = new Test();
SlideShow slideshow = new BasicSlideShow(query("#viewBox"));
num currentSlidePosition = -10;
num slidePositionXScale = 2000;
num slidePositionYScale = 4000;

/*********default camera position*********/
num camTransDuration = 1;
num camX = 1330;
num camY = 400;
num camZ = 50000;
num camXr = 0; 
num camYr = 0;
num camZr = 0;

InputElement nextBtn = query("#nextButton");
InputElement continueBtn = query("#nextButton");
InputElement explainBtn = query("#explainBtn");

/// adds a huge map to the scene
void addBackground()
{
  var element = new ImageElement();
  element.src = "images/world_8bit.png";
  var slide = new Slide(element, 50.0, 0 , 0, 0, 0, 0);  
  slideshow.addBackgroundSlide(slide);
  //no transitions because this slide is never focused / transitioned to.
}

/**
 * wrapper method for the camera move method that sets the default camera
 * positions as arguments
 */
void lookAtMap()
{
  slideshow.cam.move(camTransDuration, camX, camY, camZ, camXr, camYr, camZr);
}

///Advance the test to the next question or step
void nextQuestion()
{
  //get next step from test
  var slideElement = test.next();
  assert(slideElement != null);
  

  if(slideElement.id.startsWith("summary"))
  {
    if(test.currentSection != test.sections.last)
    {
      continueBtn.style.visibility = "visible";
    }
    else
    {
      continueBtn.style.visibility = "hidden";
    }
    explainBtn.style
    ..visibility = "visible";
  }
  else
  {
    explainBtn.style
    ..visibility = "hidden";
  }
  
  slideshow.useDynamic = true;
  currentSlidePosition += 1;
  //create and add a new slide for this next test step
  var x = currentSlidePosition * slidePositionXScale;
  var y = sin(currentSlidePosition) * slidePositionYScale;
  var slide = slideshow.addElementSlide(slideElement, 1.0, currentSlidePosition * slidePositionXScale, y, 0, 0, 0, 0);
  
  //use the presentation to progress to this next step
  slideshow.next();
}

/**
 * Shows the explanation and return button.
 * Hides the summary and explain button.
 */
void displaySectionExplanation()
{
  explainBtn.style.visibility = "hidden";
  query("#return").style.visibility = "visible";
  
  String summaryId = "#summary${test.currentSection.star}";
  Element explainDiv = query("#explainSection");
  Element summaryDiv = query(summaryId);
  summaryDiv.style.visibility = "hidden";
  
  test.currentSection.explain();
  
  var x = currentSlidePosition * slidePositionXScale;
  var y = sin(currentSlidePosition) * slidePositionXScale * 2;
  var slide = slideshow.addElementSlide(explainDiv, 1.0, currentSlidePosition * slidePositionXScale, y, 0, 0, 0, 0);

  slideshow.cam.lookAtSlide(slide, 1);
  slideshow.next();
}

///Adds on click events to the buttons
void scriptButton()
{  
  Element nextButton = query('#nextButton');
  
  nextButton.on.click.add((event)
  {
    nextBtn.style
    ..visibility = "hidden";
      
    if(test.currentSection.atSummary)
    {
      String summaryId = "#summary${test.currentSection.star}";
      Element summaryDiv = query(summaryId);
      summaryDiv.style.visibility = "visible";
    }

    lookAtMap();
    nextQuestion();
    
  });
    
  explainBtn.on.click.add((event)
  {  
    displaySectionExplanation();
  });
  
  query("#return").on.click.add((event)
  {
    explainBtn.style
    ..visibility = "visible";
    
    query("#return").style
    ..visibility = "hidden";
    
    String summaryId = "#summary${test.currentSection.star}";
    Element explainDiv = query("#explainSection");
    Element summaryDiv = query(summaryId);
    summaryDiv.style.visibility = "visible";
    
    //test.currentSection.explain();
    
    var x = currentSlidePosition * slidePositionXScale;
    var y = sin(currentSlidePosition) * slidePositionXScale * 2;
    var slide = slideshow.addElementSlide(summaryDiv, 1.0, currentSlidePosition * slidePositionXScale, y, 0, 0, 0, 0);
    //xPosition += 1;
    lookAtMap();
    slideshow.next();
  });
}

/// move the camera back to see the map and trigger the test to begin
void startTest()
{
  lookAtMap();
  window.setTimeout(()
  {
    nextQuestion();
    scriptButton();
  }, 1500);
}

/// add splash screen and event to trigger the test
void addSplash()
{
  // div for splash slide and add to slideshow behind the map
  var slideElement = query("#splash");
  var startButton = query("#startButton");
  var slide = slideshow.addElementSlide(slideElement, 1.0, 0, 0, -2000, 0, 0, 0);
  
  // set camera at splash slide and script start button
  slideshow.cam.lookAtSlide(slide, 0);
  startButton.on.click.add((event) =>  startTest());
  // sets splash as the current slide and gives it focus
  slideshow.start();
}

/**
 * call back method is called by the HttpRequest get method
 * processes the the response text by passing it to the test 
 * section constructor
 * 
 * method also serves as user input entry point
 */ 
onSuccess(HttpRequest request)
{
  for(int i=1; i<5; i++)
  {
    test.sections.add(new TestSection(i, request.responseText));
  }
  
  addBackground();
  addSplash();
}

void main()
{
  // relative location of the questions on the server
  var url = "../questions.xml";//"../testQs.xml";//"../questions.xml";
  // async request to get the file at the given url
  var request = new HttpRequest.get(url, onSuccess);
}
