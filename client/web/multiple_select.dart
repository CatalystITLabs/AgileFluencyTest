part of test;

/**
 * a multiple select question
 */
class MultipleSelect extends Question{
  /**
   * the selectable answers for this question
   */
  List<Answer> answers = new List<Answer>();
  
  /**
   * the answer selected by the test taker
   */
  List<Answer> selected = new List<Answer>();
  
  /**
   * constructor
   */
  MultipleSelect(text){
    this.text = text;
  }
  
  /**
   * Get the greatest number of points it is possible to receive on this question
   */
  List<Answer> getBestAnswers() {
    List<Answer> best = new List<Answer>();;
    for (var iterator in this.answers) {
      if (iterator.points > 0)
        best.add(iterator);
    }
    return answers;
  }
  
  /**
   * Return a DOM element radio button with an onclick event for this answer
   */
  Element _makeCheckBox(Answer answer, int number)
  {
    var element = new Element.html("<input type=\"checkbox\" name=\"${number.toString()}\">");
    //element.on.click.add(
    //    (event) => this.setAnswer(number));
    return element;
  }
  
  /**
   * Get the question displayed in html.
   */
  Element display()
  {
    var output = new DivElement();
    output.insertAdjacentElement('beforeEnd',new Element.html("""<p>${this.text}</p>"""));
    var number = 0;
    for (var iterator in this.answers)
    {
      var button = this._makeCheckBox(iterator, number);
      number++;
      output.insertAdjacentElement('beforeEnd', button);
      output.addText(iterator.text);
      output.addHTML("<br/>");
    }
    output.addHTML("<input id=\"submit\" type=\"button\" value=\"Click Me.\">");
    return output;
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
    for (var iterator in this.selected)
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
    for (var iterator in this.selected)
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
