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

void main()
{
  test.sections.add(new TestSection(1));
  test.sections.add(new TestSection(2));
  test.sections.add(new TestSection(3));
  test.sections.add(new TestSection(4));
  scriptButton();
  nextQuestion();
}
