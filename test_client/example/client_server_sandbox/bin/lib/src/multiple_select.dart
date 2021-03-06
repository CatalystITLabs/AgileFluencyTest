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
   * Get a list containing the highest scoring combination of answers
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
    
    query("#nextButton").style.visibility = "visible";
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
   * Return a Dom element explaining the question and why the answer why the test taker was scored the way they were.
   */
  Element explain()
  {
    print("Explaining MultipleSelect");
    var output = super.explain();
    var explainAnswers = new UListElement();
    for (var answer in this.answers)
    {
      var isSelected = this.selectedAnswers.indexOf(answer) != -1;
      var answerExplanation = answer.explain(isSelected, 1, 3);
      explainAnswers.insertAdjacentElement("beforeEnd", answerExplanation);
    }
    output.insertAdjacentElement("beforeEnd", explainAnswers);
    return output;
  }
}
