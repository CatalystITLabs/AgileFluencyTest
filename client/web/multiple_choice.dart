part of test;
//part 'question.dart';
//part 'answer.dart';

/**
 * A multiple choice question
 */
class MultipleChoice extends Question
{
  
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
  MultipleChoice(text)
  {
    this.text = text;
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
  int getSelectedPoints()
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
  }
  
  /**
   * Return a DOM element radio button with an onclick event for this answer
   */
  Element _makeRadioButton(Answer answer, int number)
  {
    var element = new Element.html("<input type=\"radio\" name=\"group1\">");
    element.on.click.add(
        (event) => this.setAnswer(number));
    return element;
  }
  
  /**
   * Build the question into a DOM element.
   */
  Element display()
  {
    var output = new DivElement();
    output.insertAdjacentElement('beforeEnd',new Element.html("""<p>${this.text}</p>"""));
    var number = 0;
    for (var iterator in this.answers)
    {
      var button = this._makeRadioButton(iterator, number);
      number++;
      output.insertAdjacentElement('beforeEnd', button);
      output.addText(iterator.text);
      output.addHTML("<br/>");
    }
    output.addHTML("<input id=\"submit\" type=\"button\" value=\"Click Me.\">");
    return output;
  }
  
  bool gotMaxPoints() 
  {
    return selected.points == this.getMaximumPoints(); 
  }
    
  String explain() {
    var output = new StringBuffer();
    output.add("You selected: ${selected.text}");
    output.add("<br/>${selected.explanation}");
    
    for (var iterator in this.answers)
    {
      if (iterator.points == this.getMaximumPoints()) 
      {
        output.add("<br/> The best option is: ");
        output.add(iterator.text);
        output.add("<br/> ${iterator.explanation}");
      }
    }
    return output.toString();
  }
}
