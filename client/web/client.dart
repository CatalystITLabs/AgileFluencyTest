library test;
import 'dart:html';
import 'packages/xml/xml.dart';
part "question.dart";
part "answer.dart";
part "multiple_choice.dart";
part "multiple_select.dart";
part "test_section.dart";


TestSection currentSection = new TestSection(1);
Question currentQuestion;

void nextQuestion() {
  var num;
  if (currentQuestion == null)
    num = 0;
  else
    num = currentSection.questions.indexOf(currentQuestion, 0) + 1;
  
    if (currentSection.questions.length > num)
    {
      currentQuestion = currentSection.questions[num];
      print("Next Question.");
    }
    else
      print("Finished.");
    
    query("#question").innerHTML= currentQuestion.display().innerHTML;
}

Element nextButton()
{
  var element = new Element.html("<input id=\"nextQuestion\" type=\"button\" value=\"Next Question\">");
  element.on.click.add(
      (event) => nextQuestion());
  return element;
}

void main() {
  nextQuestion();
  //query("#container").addHTML("<input id=\"nextQuestion\" type=\"button\" value=\"Next Question\">");
  //query("#nextQuestion").on.click((event) => nextQuestion())
  query("#container").insertAdjacentElement('beforeEnd', nextButton());
}
