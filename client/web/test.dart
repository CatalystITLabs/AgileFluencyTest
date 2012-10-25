library test;
import 'dart:html';
import 'packages/xml/xml.dart';
import 'dart:math' as Math;
part "question.dart";
part "answer.dart";
part "multiple_choice.dart";
part "multiple_select.dart";
part "single_select.dart";
part "parse_question_xml.dart";
part "test_section.dart";

class Test {
  List<TestSection> sections = new List<TestSection>();
  
  TestSection currentSection;

  /**
   * set the currentSection to the next TestSection in sections
   */
  TestSection nextSection()
  {
    var num;
    if (this.currentSection == null)
      num = 0;
    else
      num = this.sections.indexOf(this.currentSection, 0) + 1;
    
    if (this.sections.length > num)
    {
      this.currentSection = this.sections[num];
      print("Next Question.");
    }
    else
      print("Finished. Do something else here.");
    
    return this.currentSection;
  }
  
  /**
   * return an html dom element for the current state of the test
   */
  Element display() {
    var header = this.currentSection.name;
    if (header == null)
      header = "Section ${this.sections.indexOf(currentSection) + 1}";
    var questionNumber = this.currentSection.questions.indexOf(this.currentSection.currentQuestion, 0) + 1;
    var sectionLength = this.currentSection.questions.length;
    header = "$header: Question $questionNumber of $sectionLength";
    Element output = this.currentSection.display();
    output.insertAdjacentHTML("afterBegin", "<h4>$header</h4><br/>");
    return output;
  }
  
  /**
   * Move on to the next state of the test and return an html dom element
   */
  Element next() {
    if (this.currentSection == null)
      this.nextSection();
    assert(this.currentSection != null);
    
    this.currentSection.nextQuestion();
    return this.display();
  }
}
