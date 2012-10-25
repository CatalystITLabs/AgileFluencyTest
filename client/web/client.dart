import 'dart:html';
import "test.dart";

Test test = new Test();

void nextQuestion()
{
  query("#question").innerHTML= test.next().innerHTML;
}

Element nextButton()
{
  var element = new Element.html("<input id=\"nextQuestion\" type=\"button\" value=\"Next Question\">");
  element.on.click.add(
      (event) => nextQuestion());
  return element;
}

void main()
{
  test.sections.add(new TestSection(1));
  nextQuestion();
  query("#container").insertAdjacentElement('beforeEnd', nextButton());
}
