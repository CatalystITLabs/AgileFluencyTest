library test;
import 'dart:html';
part "question.dart";
part "answer.dart";
part "multiple_choice.dart";
part "multiple_select.dart";
part "test_section.dart";

MultipleChoice testQuestion = new MultipleChoice("What color is the sky?");
Answer a1 = new Answer(0,"Red.","Perhaps you have some form of color blindness. If the sky is actually red, you may be in trouble.");
Answer a2 = new Answer(1,"Blue.","The sky is indeed blue most of the time.");

void submit()
{
  query("#container").addHTML(testQuestion.explain());
}

void main()
{
  testQuestion.answers.add(a1);
  testQuestion.answers.add(a2);
  
  //query("#container").innerHTML = testQuestion.display();
  query("#container").insertAdjacentElement('beforeEnd', testQuestion.display());
  query("#submit").on.click.add((event) => submit());
}
