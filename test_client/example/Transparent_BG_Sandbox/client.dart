import 'dart:html';
import "../../lib/test.dart";
import "../../packages/presentation/presentation.dart";

Test test = new Test();
SlideShow presentation = new BasicSlideShow(query("#viewBox"));

void addTestSlide()
{
  
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
  //var viewBox = query("#viewBox");
  //viewBox.style.transition = "1s";
  
  window.setTimeout(()
  {
    //viewBox.innerHTML = "";
    //viewBox.style.backgroundImage = "none";
    //addBackground();
    //addSplash();
  }, 1000);
  
}

void main()
{
  // relative location of the questions on the server
  //var url = "../questions.xml";
  // async request to get the file at the given url
  //var request = new HttpRequest.get(url, onSuccess);
  
  
}
