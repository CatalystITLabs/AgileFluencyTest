import 'dart:html';
import "../../lib/test.dart";
import "../../packages/presentation/presentation.dart";

Test test = new Test();
SlideShow slideshow = new BasicSlideShow(query("#viewBox"));
num xPosition = 0;
InputElement nextBtn = query("#nextQuestion");
InputElement continueBtn = query("#continue");

void addBackground()
{
  var element = new ImageElement();
  element.src = "images/pixel_map_generic_wloc.png";
  var slide = new Slide(element, 100.0, 0, 0, -50, 0, 0, 0);
  slideshow.addBackgroundSlide(slide);
  //no transitions because this slide is never focused / transitioned to.
}

///Advance the test to the next question or step
void nextQuestion()
{
  //get next step from test
  var slideElement = test.next();
  assert(slideElement != null);
  
  if(slideElement.id.startsWith("summary"))
  {
    continueBtn.style
    ..visibility = "visible";
  }
  else
  {
    continueBtn.style
    ..visibility = "hidden";
  }
  
  //create and add a new slide for this next test step
  var slide = slideshow.addElementSlide(slideElement, 1.0, xPosition, 0, 0, 0, 0, 0);
  xPosition += 2000;
  
  //create and add the transition to this next test step
  //var transition = new BasicTransition(slide, presentation.currentSlide);
  //presentation.transitions.add(transition);
  
  //use the presentation to progress to this next step
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
    nextQuestion();
    
    if(!test.currentSection.atSummary)
    {
      continueBtn.style
      ..visibility = "hidden";
    }
  });
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
  nextQuestion();
  slideshow.start();
  scriptButton();
}

void main()
{
  // relative location of the questions on the server
  var url = "../questions.xml";//"../testQs.xml";//"../questions.xml";
  // async request to get the file at the given url
  var request = new HttpRequest.get(url, onSuccess);
}
