import 'dart:html';
import "test.dart";

Test test = new Test();

/**
 * Advance the test to the next question or step
 */
void nextQuestion()
{
  assert(query("#question") != null);
  //replace the elements in the current question div with the next step in the Test
  query("#question").elements= test.next().elements;
  //add a next button
  //query("#question").insertAdjacentElement('beforeEnd', nextButton());
}


void scriptButton()
{
  assert(query("#nextQuestion") != null);
  Element button = query('#nextQuestion');
  button.on.click.add(
      (event) => nextQuestion());
}

/**
 * call back method is called by the request get method
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
  scriptButton();
  nextQuestion();
}

void main()
{
  // relative location of the questions on the server
  var url = "../client/web/questions.xml";
  // async request to get the file at the given url
  var request = new HttpRequest.get(url, onSuccess);
}
