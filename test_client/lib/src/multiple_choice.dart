part of test;

/**
 * An abstract question that with a set of answers to choose from
 */
abstract class MultipleChoice extends Question
{
  
  /**
   * the selectable answers for this question
   */
  List<Answer> answers = new List<Answer>();
  
  /**
   * Constructor
   */
  MultipleChoice(text)
  {
    this.text = text;
  }
  
  /**
   * Return a DOM element radio button with an onclick event for this answer
   */
  Element _makeButton(Answer answer, int number);
  
  /**
   * Builds the answers into a dom element with an html form
   */
  Element displayAnswers()
  {
    var output = new DivElement();
    output.id = "answers";
    var number = 0;
    for (var iterator in this.answers)
    {
      var button = this._makeButton(iterator, number);
      number++;
      output.insertAdjacentElement('beforeEnd', button);
      output.addText(iterator.text);
      output.addHTML("<br/>");
    }
    return output;
  }
  
  /**
   * Build the question into a DOM element.
   */
  Element display()
  {
    var output = new DivElement();
    output.id = "question";
    output.insertAdjacentElement('beforeEnd', new Element.html("""<p>${this.text}</p>"""));
    output.insertAdjacentElement('beforeEnd', this.displayAnswers());
    //output.addHTML("<input id=\"nextQuestion\" type=\"button\" value=\"Next Question\">");
    return output;
  }
}
