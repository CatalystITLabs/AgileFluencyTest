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
Answer q1a2 = new Answer(1,"We go through many iterations","Q");
Answer q1a3 = new Answer(2,"We do iterations of a fixed length less than 4 weeks","Q");
//MultipleSelect q2 = new MultipleSelect("How much is documented before start of implementation?");
//Answer q2a1 = new Answer(0,"Complete product is specified","Q");
//Answer q2a2 = new Answer(1, "Basic product features, expected to change","Q");
//Answer q2a3 = new Answer(0, "Little, someone decides what to do","Q");
//Answer q2a4 = new Answer(1, "Clearly defined goals, details will be worked out","Q");

void main() {
  q1.answers.add(q1a1);
  q1.answers.add(q1a2);
  q1.answers.add(q1a3);
  oneStar.questions.add(q1);
//  q2.answers.add(q2a1);
//  q2.answers.add(q2a2);
//  q2.answers.add(q2a3);
//  q2.answers.add(q2a4);
//  oneStar.questions.add(q2);
  
  for (var iterator in oneStar.questions)
  {
    query("#container").innerHTML = iterator.display();
  }
}
