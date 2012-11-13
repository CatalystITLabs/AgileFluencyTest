import 'dart:html';
import "../../lib/test.dart";
import "../../packages/presentation/presentation.dart";

Test test = new Test();
SlideShow presentation = new BasicSlideShow(query("#viewBox"));

void addTestSlide()
{
  // your content here
  //var slideElement = test.currentSection.displayCurrentQuestion();
  var slideElement = test.currentSection.explain();
  //var slideElement = test.currentSection.summary();
  
  //your callbacks here
  //slideElement.on.click.add((event) => done());
  
  presentation.addElementSlide(slideElement, 1.0, 200, 200, 0, 0, 0, 0);
  
}

void done()
{
  presentation.cam.move(1.0, 0, 0, 100000, 0, 0, 0);
}

void addBackground()
{
  var element = new ImageElement();
  element.src = "images/pixel_map_generic_wloc.png";
  //var slide = presentation.addElementSlide(element, 100.0, 0, 0, -50, 0, 0, 0);
  var slide = new Slide(element, 100.0, 0, 0, -50, 0, 0, 0);
  presentation.addBackgroundSlide(slide);
  //no transitions because this slide is never focused / transitioned to.
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
  test.next();
  test.nextSection();
  addBackground();
  addTestSlide();
  presentation.start();
}

void main()
{
  // relative location of the questions on the server
  var url = "../questions.xml";
  // async request to get the file at the given url
  var request = new HttpRequest.get(url, onSuccess);
}
