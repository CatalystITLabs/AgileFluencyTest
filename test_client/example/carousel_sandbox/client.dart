import 'dart:html';
import "../../lib/test.dart";
import "../../packages/presentation/presentation.dart";

Test test = new Test();
SlideShow presentation = new BasicSlideShow(query("#viewBox"));
Slide explanation;
var wheelRadius = 300; 
var angleStep = 0;
var currentAngle = 0;


class Carousel
{
  num wheelRadius; 
  num angleStep;
  num currentAngle;
  
  DivElement element;
  
  Carousel(List<Element> contents)
  {
    element = new DivElement();
    currentAngle = 0.0;
    
    angleStep = 360 / contents.length;
    int index = 0;
    
    for (var item in contents)
    {
      var angle = index * (360 / contents.length);
      var slide = presentation.makeSlideFromElement(item, 1, 0, 0, 0, 0, 0, 0);
      item.style.transform = "rotateX(${angle}deg) translateZ(${wheelRadius}px)";
      element.insertAdjacentElement("beforeEnd", slide.element);
      index++;
    }
  }
  
  addControl()
  {
    var x = presentation.cam.viewBox.clientWidth - 200;
    var z = wheelRadius;
    ImageElement control = new ImageElement();
    control.src = "images/arrow_right_8bit.png";
    control.style.transform = "translateX(${x}px) translateY(${200}px) translateZ(${z}px) rotateZ(90deg)";
    element.insertAdjacentElement("beforeEnd", control);
  }
}
DivElement explanationWheel()
{
  print("Explaining section.");
  var output = new DivElement();
  var angle = 0.0;
  var explanations = test.currentSection.explanations();
  angleStep = 360 / explanations.length;
  //Explanation section
  output.id = "explanation";
  int index = 0;
  
  for (var questionExplanation in explanations)
  {
    angle = index * (360 / explanations.length);
    var slide = presentation.makeSlideFromElement(questionExplanation, 1, 0, 0, 0, 0, 0, 0);
    questionExplanation.style.transform = "rotateX(${angle}deg) translateZ(${wheelRadius}px)";
    output.insertAdjacentElement("beforeEnd", slide.element);
    index++;
  }
  
  var x = presentation.cam.viewBox.clientWidth - 200;
  var z = wheelRadius;
  ImageElement downArrow = new ImageElement();
  downArrow.src = "images/arrow_right_8bit.png";
  downArrow.style.transform = "translateX(${x}px) translateY(${200}px) translateZ(${z}px) rotateZ(90deg)";
  output.insertAdjacentElement("beforeEnd", downArrow);
  
  return output;
  /*
  ImageElement upArrow = new ImageElement();
  upArrow.src = "images/arrow_right_8bit.png";
  upArrow.style.transform = "translateX(${x}px) translateZ(${z}px) rotateZ(-90deg)";
  output.insertAdjacentElement("beforeEnd", upArrow);
  */
}

void addTestSlide()
{
  // your content here
  //var slideElement = test.currentSection.displayCurrentQuestion();
  var slideElement = test.currentSection.summary();
    
  
  //your callbacks here
  slideElement.on.click.add((event) => toExplanation());
  
  presentation.addElementSlide(slideElement, 1.0, 500, 500, 0, 0, 0, 0);
  explanation = presentation.addBackgroundElementSlide(explanationWheel(), 1.0, 0, 0, 0, 0, 0, 0);
  //slides width is determined by their container
  explanation.element.style.width = "95%";
  
}

void toExplanation()
{
  print("toExplanation");
  //explanation.element.classes.remove("slide");
  //presentation.cam.focusOnSlide(explanation, 1.0);
  var widthOffset = explanation.element.clientWidth ~/2;
  var heightOffset = wheelRadius ~/ 2;
  var depthOffset = wheelRadius;
  presentation.cam.move(1.0, widthOffset, heightOffset, depthOffset, 0, 0, 0);
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
