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
  var slideElement = test.currentSection.summary();
  
  var stamp1 = new ImageElement();
  stamp1.classes.add("stamp");
  stamp1.src = "images/stamp_1.png";
  stamp1.style.left = "3%";
  stamp1.style.top = "6%";
  stamp1.style.transform = "rotateZ(10deg)";
  var stamp2 = new ImageElement();
  stamp2.classes.add("stamp");
  stamp2.src = "images/stamp_2.png";
  stamp2.style.left = "26%";
  stamp2.style.top = "3%";
  stamp2.style.transform = "rotateZ(-18deg)";
  var stamp3 = new ImageElement();
  stamp3.classes.add("stamp");
  stamp3.src = "images/stamp_3.png";
  stamp3.style.left = "6%";
  stamp3.style.top = "44%";
  stamp3.style.transform = "rotateZ(-7deg)";
  var stamp4 = new ImageElement();
  stamp4.classes.add("stamp");
  stamp4.src = "images/stamp_4.png";
  stamp4.style.left = "24%";
  stamp4.style.top = "42%";
  stamp4.style.transform = "rotateZ(5deg)";
  
  slideElement.insertAdjacentElement("beforeEnd", stamp1);
  slideElement.insertAdjacentElement("beforeEnd", stamp2);
  slideElement.insertAdjacentElement("beforeEnd", stamp3);
  slideElement.insertAdjacentElement("beforeEnd", stamp4);
  
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
