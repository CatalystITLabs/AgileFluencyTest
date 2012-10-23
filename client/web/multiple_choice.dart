part of test;
//part 'question.dart';
//part 'answer.dart';

/**
 * A multiple choice question
 */
class MultipleChoice extends Question{
  
  /**
   * the selectable answers for this question
   */
  List<Answer> answers = new List<Answer>();
  
  /**
   * the answer selected by the test taker
   */
  Answer selected;
  
  /**
   * Constructor
   */
  MultipleChoice(text){
    this.text = text;
  }
  
  /**
   * Get the greatest number of points it is possible to receive on this question
   */
  int getMaximumPoints() {
    var highest = 0;
    for (var iterator in this.answers) {
      if (iterator.getPoints() > highest)
        highest = iterator.getPoints();
    }
    return highest;
  }
  
  /**
   * Get the number of points the user earns for their answer to the question.
   */
  int getSelectedPoints() {
    if (selected == null)
      return 0;
    return selected.points;
  }
  
  /**
   * Get the question displayed in html.
   */
  String display()
  {
    var output = new StringBuffer();
    output.add("<p>");
    output.add(this.text);
    output.add("</p>");
    for (var iterator in this.answers)
    {
      output.add("<input type=\"radio\" name=\"group1\" onClick=\"test()\"");
      output.add(iterator.text);
      output.add("\">");
      output.add(iterator.text);
      output.add("<br/>");
    }
    output.add("<br/>");
    output.add("<input type=\"button\" value=\"Submit\">");
    return output.toString();
  }
  
  
  bool gotMaxPoints() 
  {
   return selected.points == this.getMaximumPoints(); 
  }
    
  String explain() {
    var output = new StringBuffer();
    output.add("You selected: ");
    output.add(selected.text);
    output.add("<br/>");
    output.add(selected.explanation);
    for (var iterator in this.answers)
    {
      if (iterator.points == this.getMaximumPoints()) 
      {
        output.add("<br/>");
        output.add("A maximally agile answer is: ");
        output.add(iterator.text);
        output.add("<br/>");
        output.add(iterator.explanation);
      }
    }
  }
  
}
