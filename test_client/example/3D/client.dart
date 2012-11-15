import 'dart:html';
import 'dart:math';
import "../../lib/test.dart";
import "../../packages/presentation/presentation.dart";

Test test = new Test();
SlideShow slideshow = new BasicSlideShow(query("#viewBox"));
num xPosition = -10;
num xScale = 2000;

InputElement nextBtn = query("#nextQuestion");
InputElement continueBtn = query("#continue");
InputElement explainBtn = query("#explain");

/// adds a huge map to the scene
void addBackground()
{
  var element = new ImageElement();
  element.src = "images/world_8bit.png";
  var slide = new Slide(element, 55.0, 0 , 0, 0, 0, 0);  
  slideshow.addBackgroundSlide(slide);
  //no transitions because this slide is never focused / transitioned to.
}

///Advance the test to the next question or step
void nextQuestion()
{
  //get next step from test
  var slideElement = test.next();
  assert(slideElement != null);
  
  if(test.currentSection != test.sections.last)
  {
    if(slideElement.id.startsWith("summary"))
    {
      continueBtn.style
      ..visibility = "visible";
      
      explainBtn.style
      ..visibility = "visible";
    }
  }
  else
  {
    continueBtn.style
    ..visibility = "hidden";
    
    explainBtn.style
    ..visibility = "hidden";
  }
  
  slideshow.useDynamic = true;
  //create and add a new slide for this next test step
  var x = xPosition * xScale;
  var y = sin(xPosition) * xScale * 2;
  var slide = slideshow.addElementSlide(slideElement, 1.0, xPosition * xScale, y, 0, 0, 0, 0);
  xPosition += 1;
  
  //create and add the transition to this next test step
  //var transition = new BasicTransition(slide, presentation.currentSlide);
  //presentation.transitions.add(transition);
  
  //use the presentation to progress to this next step
  slideshow.next();
}

void displaySectionExplanation()
{
  explainBtn.style
  ..visibility = "hidden";
  
  query("#return").style
  ..visibility = "visible";
  
  String summaryId = "#summary${test.currentSection.star}";
  Element explainDiv = query("#explainSection");
  Element summaryDiv = query(summaryId);
  
  test.currentSection.explain();
  
  var x = xPosition * xScale;
  var y = sin(xPosition) * xScale * 2;
  var slide = slideshow.addElementSlide(explainDiv, 1.0, xPosition * xScale, y, 0, 0, 0, 0);
  xPosition += 1;
  
  summaryDiv.style
  ..visibility = "hidden";
  
  explainDiv.style
  ..visibility = "visible";
  
  slideshow.next();
}

///Adds on click event to the next question button
void scriptButton()
{
  assert(query("#nextQuestion") != null);
  
  Element button = query('#nextQuestion');
  Element continueBtn = query("#continue");
  
  button.on.click.add((event)
  {
    nextBtn.style
    ..visibility = "hidden";
    
    nextQuestion();
  });
  
  continueBtn.on.click.add((event)
  {
    explainBtn.style
    ..visibility = "hidden";
    
    nextQuestion();
    
    if(!test.currentSection.atSummary)
    {
      continueBtn.style
      ..visibility = "hidden";
    }
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
    
    test.currentSection.explain();
    
    var x = xPosition * xScale;
    var y = sin(xPosition) * xScale * 2;
    var slide = slideshow.addElementSlide(summaryDiv, 1.0, xPosition * xScale, y, 0, 0, 0, 0);
    xPosition += 1;
    
    explainDiv.style
    ..visibility = "hidden";
    
    summaryDiv.style
    ..visibility = "visible";
    
    slideshow.next();
  });
}

/// move the camera back to see the map and trigger the test to begin
void startTest()
{
  // Why are these x and y coordinates needed to center the background?
  slideshow.cam.move(1, 1330, 400, 50000, 0, 0, 0);
  window.setTimeout(()
  {
    nextQuestion();
    scriptButton();
  }, 1500);
}

/// add splash screen and event to trigger the test
void addSplash()
{
  // add splash background image
  var splashBackground = new ImageElement();  splashBackground.src = "images/splash_8bit.png";  splashBackground.id = "splashBackground";
 
  // add start button
  var startButton = new ImageElement();
  startButton.src = "images/start_8bit.png";
  startButton.id = "startButton";
  
  // create div for splash slide and add to slideshow behind the map
  var slideElement = new DivElement();
  slideElement.insertAdjacentElement("beforeEnd",splashBackground);
  slideElement.insertAdjacentElement("beforeEnd", startButton);
  var slide = slideshow.addElementSlide(slideElement, 1.0, 0, 0, -2000, 0, 0, 0);
  
  // set camera at splash slide and script start button
  slideshow.cam.focusOnSlide(slide, 0);
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
