library test;
import 'dart:html';
import 'packages/xml/xml.dart';
part "question.dart";
part "answer.dart";
part "multiple_choice.dart";
part "multiple_select.dart";
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
    return this.currentSection.currentQuestion.display();
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
