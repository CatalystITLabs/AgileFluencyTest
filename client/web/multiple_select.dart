part of test;

/**
 * a multiple select question
 */
class MultipleSelect extends MultipleChoice{
  
  /**
   * the answer selected by the test taker
   */
  List<Answer> selectedAnswers = new List<Answer>();
  
  /**
   * constructor
   */
  MultipleSelect(text): super(text){}
  
  /**
   * Get the greatest number of points it is possible to receive on this question
   */
  List<Answer> getBestAnswers() {
    List<Answer> best = new List<Answer>();;
    for (var iterator in this.answers) {
      if (iterator.points > 0)
        best.add(iterator);
    }
    return best;
  }
  
  /**
   * Return a DOM element radio button with an onclick event for this answer
   */
  Element _makeButton(Answer answer, int number)
  {
    var element = new Element.html("<input type=\"checkbox\" name=\"${number.toString()}\">");
    //element.on.click.add(
    //    (event) => this.setAnswer(number));
    return element;
  }
  
  /**
   * Get the greatest number of points it is possible to receive on this question
   */
  int getMaximumPoints()
  {
    var total = 0;
    for (var iterator in this.answers)
    {
      if (iterator.points > 0)
      {
        total += iterator.points;
      }
    }
    return total;
  }
  
  /**
   * Get the number of points the user earns for their answer to the question.
   */
  int getUserAnswerPoints()
  {
    var total = 0;
    for (var iterator in this.selectedAnswers)
    {
      total += iterator.points;
    }
    return total;
  }
  
  /**
   * Explain why the answer why the test taker was scored the way they were.
   */
  String explain()
  {
    var output = new StringBuffer();
    
    output.add("You selected: <br/>");
    for (var iterator in this.selectedAnswers)
    {
      output.add("${iterator.text}<br/>");
      output.add("${iterator.explanation}<br/>");
    }
    output.add("<br/>The best set of option is: <br/>");
    for (var iterator in this.getBestAnswers())
    {
      output.add("${iterator.text}<br/>");
      output.add("${iterator.explanation}<br/>");
    }
    return output.toString();
  }
}
