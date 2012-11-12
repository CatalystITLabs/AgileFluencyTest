import 'dart:html';
import "../../lib/test.dart";
import "../../packages/presentation/presentation.dart";

Test test = new Test();
SlideShow presentation = new BasicSlideShow(query("#viewBox"));

void addTestSlide()
{
  // your content here
  //var slideElement = test.currentSection.displayCurrentQuestion();
  //var slideElement = test.currentSection.explain();
  var slideElement = new DivElement();
  slideElement.style.backgroundImage = "../3D/images/splash_8bit.png";
    
  
  //your callbacks here
  slideElement.on.click.add((event) => done());
  
  presentation.addElementSlide(slideElement, 1.0, 200, 200, 0, 0, 0, 0);
  
}

void done()
{
  presentation.cam.move(1.0, 0, 0, 100000, 0, 0, 0);
}

void addBackground()
{
  var element = new ImageElement();
  element.src = "../../example/3D/images/world_8bit.png";
  //var slide = presentation.addElementSlide(element, 100.0, 0, 0, -50, 0, 0, 0);
  var slide = new Slide(element, 100.0, 0, 0, -50, 0, 0, 0);
  presentation.addBackgroundSlide(slide);
  //no transitions because this slide is never focused / transitioned to.
}

void startSplash()
{
  var element = new DivElement();
  element.id = "splash";
  element.style.backgroundImage = "../../example/3D/images/splash_8bit.png";
  element.style.width = "100%";
  element.style.height = "100%";
  element.style.opacity = "1.0";
  
  var _testEvent;
  if (_testEvent == null)
    _testEvent = (event) => addBackground();
  
  var startButton = new ImageElement();
  startButton.src = "../../example/3D/images/start_8bit.png";
  startButton.on.click.add(_testEvent);
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
  addBackground();
  startSplash();
  addTestSlide();
  presentation.start();
}

void main()
{
  startSplash();
  // relative location of the questions on the server
  var url = "../questions.xml";
  // async request to get the file at the given url
  var request = new HttpRequest.get(url, onSuccess);
}
