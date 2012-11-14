library test;
import 'dart:html';
import '../packages/xml/xml.dart';
import '../packages/presentation/presentation.dart';
import 'dart:math' as Math;

part "src/question.dart";
part "src/answer.dart";
part "src/multiple_choice.dart";
part "src/multiple_select.dart";
part "src/single_select.dart";
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
    
    //get the index of the next section
    if (this.currentSection == null)
      num = 0;
    else
      num = this.sections.indexOf(this.currentSection, 0) + 1;
    
    //if the index is valid set current section to it
    if (this.sections.length > num)
    { 
      print("Next Section.");
      this.currentSection = this.sections[num];
      //set the next question if not at the beginning of the section
      if(num!=0)
      {
        currentSection.nextQuestion();  
      }
    }
    else
    {
      print("No more TestSections. Do something else here.");
    }
    
    return this.currentSection;
  }
  
  /**
   * return an html dom element for the current state of the test
   */
  Element display() {
    
    //display question or explanation
    Element output = this.currentSection.display();
    if (output == null)
    {
      output = new Element.html("<p>No output from TestSection.</p>");
    }
    return output;
  }
  
  /**
   * Move on to the next state of the test and return an html dom element
   */
  Element next() {
    //if there is no currentSection grab the first TestSection
    if (this.currentSection == null)
      this.nextSection();
    assert(this.currentSection != null);

    //get the next step from the section
    var next = this.currentSection.next();
    
    //if there is nothing next in the section
    if (next == null)
    {
      var section = this.nextSection();
      
      if (section == null || currentSection == null)
      {
        return new Element.html("<p>Its finished! Do something here.</p>");
      }
    }
    
    return this.display();
  }
}
