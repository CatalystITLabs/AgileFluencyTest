library test;
import 'dart:html';
part "question.dart";
part "answer.dart";
part "multiple_choice.dart";
part "multiple_select.dart";
part "test_section.dart";

TestSection oneStar = new TestSection(1);
MultipleSelect q1 = new MultipleSelect("How often in development do you produce fully working, documented, and tested software?");
Answer q1a1 = new Answer(0,"When it's finished","Q");
Answer q1a2 = new Answer(1,"Q","Q");
Answer q1a3 = new Answer(2,"Q","Q");
MultipleSelect q2 = new MultipleSelect("");
Answer answerFour = new Answer(0,"Q","Q");

void main() {
  q1.answers.add(q1a1);
  q1.answers.add(q1a2);
  q1.answers.add(q1a3);
  oneStar.questions.add(q1);
  
  query("#container").innerHTML = q1.display();
}
