part of test;
//part 'question.dart';
//part 'answer.dart';

/**
 * A multiple choice question
 */
class MultipleChoice extends Question{
  
  /**
   * The text of the question itself (ex. "What color is the sky?")
   */
  //String text;
  
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
    var highest = -99999;
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
    return selected.points;
  }
  
  /**
   * Get the question displayed in html.
   */
  String display() {
    var output = new StringBuffer();
    output.add("<p>");
    output.add(this.text);
    output.add("</p>");
    for (var iterator in this.answers) {
      output.add(iterator.text);
      output.add("<br/>");
    }
    return output.toString();
  }
  
}
