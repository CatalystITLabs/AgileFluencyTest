part of test;

/**
 * A question allowing for the selection of multiple answers
 * (ie. "Choose all that apply")
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
  List<Answer> getBestAnswers()
  {
    List<Answer> best = new List<Answer>();
    for (var iterator in this.answers)
    {
      if (iterator.points > 0)
        best.add(iterator);
    }
    return best;
  }
  
  /**
   * Add or remove an answer from the selectedAnswers list
   */
  toggleAnswer(int answerIndex)
  {
    var answer = this.answers[answerIndex];
    var selectedIndex = this.selectedAnswers.indexOf(answer, 0);
    if (selectedIndex == -1)
      this.selectedAnswers.add(answer);
    else
      this.selectedAnswers.removeAt(selectedIndex);
    enableNextButton();
  }
  
  /**
   * Return a DOM element radio button with an onclick event for this answer
   */
  Element _makeButton(Answer answer, int number)
  {
    var element = new Element.html("<input type=\"checkbox\" name=\"${number.toString()}\">");
    element.on.click.add(
        (event) => this.toggleAnswer(number));
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
    print("Explaining MultipleSelect");
    var output = new StringBuffer();
    output.add(super.explain());
    
    //explain the user selected answers
    output.add("You selected: <br/>");
    for (var iterator in this.selectedAnswers)
    {
      output.add("${iterator.text}<br/>");
      if (iterator.explanation != null)
        output.add("${iterator.explanation}<br/>");
    }
    
    //explain the best answers
    output.add("<br/>The best set of option is: <br/>");
    for (var iterator in this.getBestAnswers())
    {
      output.add("${iterator.text}<br/>");
      if (iterator.explanation != null)
        output.add("${iterator.explanation}<br/>");
    }
    print(output.toString());
    return output.toString();
  }
}
