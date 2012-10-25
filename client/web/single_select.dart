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
  
  String explain() {
    var output = new StringBuffer();
    output.add(super.explain());
    
    //Explain the user selected answer
    output.add("You selected: ${selected.text}");
    if (selected.explanation != null)
      output.add("<br/>${selected.explanation}");
    
    //Explain better answers
    for (var iterator in this.answers)
    {
      if (iterator.points > this.selected.points) 
      {
        if (this.selected.points < this.getMaximumPoints())
          output.add("<br/> A better option is: ");
        else
          output.add("<br/> The best option is: ");
        
        output.add(iterator.text);
        if (iterator.explanation != null)
          output.add("<br/> ${iterator.explanation}");
      }
    }
    
    return output.toString();
  }
}
