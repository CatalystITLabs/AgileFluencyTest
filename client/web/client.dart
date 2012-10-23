library test;
import 'dart:html';
part "question.dart";
part "answer.dart";
part "multiple_choice.dart";
part "multiple_select.dart";
part "test_section.dart";

TestSection oneStar = new TestSection(1);

void main() {

  for (var iterator in oneStar.questions)
  {
    query("#container").innerHTML = iterator.display();
    //wait for user to interact.
  }
}
