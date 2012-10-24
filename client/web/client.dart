library test;
import 'dart:html';
import 'packages/xml/xml.dart';
part "question.dart";
part "answer.dart";
part "multiple_choice.dart";
part "multiple_select.dart";
part "test_section.dart";

TestSection oneStar = new TestSection(1);

void main() {

  query("#container").insertAdjacentElement('beforeEnd', oneStar.questions[1].display());
  for (var iterator in oneStar.questions)
  {
    //query("#container").insert = iterator.display();
  }
}
