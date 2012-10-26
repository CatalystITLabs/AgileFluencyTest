import 'dart:html';
import "test.dart";

Test test = new Test();

/**
 * Advance the test to the next question or step
 */
void nextQuestion()
{
  //replace the elements in the current question div with the next step in the Test
  query("#question").elements= test.next().elements;
  //add a next button
  query("#question").insertAdjacentElement('beforeEnd', nextButton());
}

/**
 * generates a button that can be added to a page with a script to advance the test
 */
Element nextButton()
{
  var element = new Element.html("<input id=\"nextQuestion\" type=\"button\" value=\"Next Question\" disabled=\"disabled\">");
  element.on.click.add(
      (event) => nextQuestion());
  return element;
}

void main()
{
  test.sections.add(new TestSection(1));
  nextQuestion();
}
