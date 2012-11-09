part of test;

/**
 * A question allowing the selection of a single answer
 */
class SingleSelect extends MultipleChoice{
  
  /**
   * the answer selected by the test taker
   */
  Answer selected;
  
  /**
   * constructor
   */
  SingleSelect(text): super(text){}
  
  /**
   * Returns true if a valid answer has been given to the question. 
   */
  bool validate()
  {
    return selected != null;
  }
  
  /**
   * Get the greatest number of points it is possible to receive on this question
   */
  int getMaximumPoints()
  {
    var highest = 0;
    for (var iterator in this.answers)
    {
      if (iterator.points > highest)
        highest = iterator.points;
    }
    return highest;
  }
  
  /**
   * Get the number of points the user earns for their answer to the question.
   */
  int getUserAnswerPoints()
  {
    if (selected == null)
      return 0;
    return selected.points;
  }
  
  /**
   * Sets the selected answer to a given index in the answers arraylist
   */
  void setAnswer(int number)
  {
    print("setting answer to $number");
    this.selected = this.answers[number];
    print("answer: ${this.selected.text}");
    enableNextButton();
  }
  
  /**
   * Return a DOM element radio button with an onclick event for this answer
   */
  Element _makeButton(Answer answer, int number)
  {
    var element = new Element.html("<input type=\"radio\" name=\"group1\">");
    element.on.click.add(
        (event) => this.setAnswer(number));
    return element;
  }
  
  /**
   * Return a Dom element explaining the question and why the answer why the test taker was scored the way they were.
   */
  Element explain() {
    print("Explaining SingleSelect");
    var output = super.explain();
    var explainAnswers = new UListElement();
    for (var answer in this.answers)
    {
      var answerExplanation = answer.explain(answer == selected, this.getMaximumPoints(), 2);
      explainAnswers.insertAdjacentElement("beforeEnd", answerExplanation);
    }
    output.insertAdjacentElement("beforeEnd", explainAnswers);
    return output;
  }
}
