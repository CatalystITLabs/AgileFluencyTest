import 'dart:html';
import "../../lib/test.dart";
import "../../packages/presentation/presentation.dart";

Test test = new Test();
SlideShow presentation = new BasicSlideShow(query("#viewBox"));

void addTestSlide()
{
  // your content here
//  var slideElement = test.currentSection.displayCurrentQuestion();
  //var slideElement = test.currentSection.explain();
//  var slideElement = test.currentSection.summary();
  var slideElement = new DivElement();


//  slideElement.style.backgroundSize = "100%";
//  slideElement.style.backgroundImage = "images/splash_8bit.png";
//  slideElement.style.padding = "0em";
  
//  slideElement.style.backgroundColor = "#FFF";
  var imageElement = new ImageElement();
  imageElement.src = "images/splash_8bit.png";
  imageElement.style.height = "100%";
  imageElement.style.width = "auto";
  imageElement.style.marginLeft = "auto";
  imageElement.style.marginRight = "auto";
  
  
  var startButton = new ImageElement();
  startButton.src = "images/start_8bit.png";
  startButton.style.position = "absolute";
  startButton.style.bottom = "5em";
  startButton.style.left = "55%";
  startButton.style.textAlign = "center";
  startButton.style.marginLeft = "auto";
  startButton.style.marginRight = "auto";
//  startButton.style.float = "right";
  startButton.style.bottom = "5em";
  
  //your callbacks here
  startButton.on.click.add((event) => done());
//  imageElement.insertAdjacentElement("beforeEnd", startButton);
  slideElement.insertAdjacentElement("beforeEnd", imageElement);
  slideElement.insertAdjacentElement("beforeend", startButton);
  presentation.addElementSlide(slideElement, 1.0, 200, 200, 0, 0, 0, 0);
  
}

void done()
{
  presentation.cam.move(1.0, 0, 0, 100, 90, 90, 90);
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
