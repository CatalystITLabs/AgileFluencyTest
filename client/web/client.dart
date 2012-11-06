import 'dart:html';
import "test.dart";
import "package:presentation/presentation.dart";

Test test = new Test();
Presentation presentation = new Presentation(query("#question"));
num xPosition = 0; 

///Advance the test to the next question or step
void nextQuestion()
{
  //get next step from test
  var element = test.next();
  assert(element != null);
  
  //create and add a new slide for this next test step
  var slide = presentation.addElementSlide(element, 1.0, xPosition, 0, 0, 0, 0, 0);
  xPosition += 2000;
  
  //create and add the transition to this next test step
  var transition = new BasicTransition(slide, presentation.currentSlide);
  presentation.transitions.add(transition);
  
  //use the presentation to progress to this next step
  presentation.next();
}

///Adds on click event to the next question button
void scriptButton()
{
  assert(query("#nextQuestion") != null);
  Element button = query('#nextQuestion');
  button.on.click.add(
      (event) => nextQuestion());
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
  
  nextQuestion();
  nextQuestion();
  scriptButton();
}

void main()
{
  // relative location of the questions on the server
  var url = "../client/web/questions.xml";
  // async request to get the file at the given url
  var request = new HttpRequest.get(url, onSuccess);
}
