part of test;

/**
 * A possible answer to a multiple choice style question
 */
class Answer {
  /**
   * The point value for this answer (ex. 0 for incorrect answers)
   */
  int points;
  
  /**
   * The text of the answer (ex. "The code will generate a NullPointerException.")
   */
  String text;
  
  /**
   * An optional explanation of why this answer is correct, incorrect, or gets the point value that it does 
   */
  String explanation;
  
  /**
   *  returns an html string of the answer text formatted for the explanation
   */
  String displayForExplanation(bool selectedByUser, int maxPoints)
  {
    var answerString = this.text;
    var pointsColorNum = (255 * Math.min(this.points, maxPoints) ~/ maxPoints).toInt();
    
    //Hex value for the answer formatting, based on points.
    var pointsColorHex = pointsColorNum.toRadixString(16);
    
    if (pointsColorNum != 0)
      answerString = "<font color=\"rgb(0,0,$pointsColorHex)\">$answerString</font>";
    if (selectedByUser)
      answerString = "=> $answerString <=";
    return answerString;
  }
  
  /**
   * Returns a dom element of the answer for the explanation page.
   * Takes in parameters for whether this answer was selected by the test taker,
   * the highest point value answer for the question, and a display mode for the
   * answer's explanation. 
   * 0 = don't display answer explanations
   * 1 = replace text with explanation on hover
   * 2 = append text with explanation on hover
   * 3 = modal text with explanations on click
   */
  Element explain(bool selectedByUser, int maxPoints, int displayExplanationMode)
  {
    var output = new LIElement();
    var answerText = displayForExplanation(selectedByUser, maxPoints);
    output.innerHTML = "$answerText &nbsp";
    
    //replace answer text with explanation on hover
    if (this.explanation != null && this.explanation != "" && displayExplanationMode == 1)
    {
      output.on.mouseOver.add(
          (event) => output.innerHTML = "<b>$explanation</b>");
      output.on.mouseOut.add(
          (event) => output.innerHTML = answerText);
    }
    //append answer text with explanation on hover
    if (this.explanation != null && this.explanation != "" && displayExplanationMode == 2)
    {
      output.on.mouseOver.add(
          (event) => output.insertAdjacentHTML("beforeEnd", "<b>$explanation</b>"));
      output.on.mouseOut.add(
          (event) => output.innerHTML = answerText);
    }
    if (this.explanation != null && this.explanation != "" && displayExplanationMode == 3)
    {
      //Add explanation button
      var explainButton = new InputElement();
      explainButton.type = "image";
      explainButton.src = "images/question_8bit.png";
      output.insertAdjacentElement("beforeEnd", explainButton);
      
      //Add modal explanation
      var modal = new DivElement();
      modal.innerHTML= "<p>$explanation</p>";
      modal.classes.add("modal");
      output.insertAdjacentElement("beforeEnd", modal);
      //var showEvent = (event) => showModal(output, modal);
      //var hideEvent = (event) => hideModal(output, modal);
      
      hideModal(explainButton, modal);
    }
    return output;
  }
  
  // listeners for toggleListener
  // These must be in object scope to remove them during different executions
  //  of the toggleListener.
  var _showEvent;
  var _hideEvent;
  var _skipEvent; 
  
  ///Switches the on click event listeners for showing/hiding the modal explanation
  void toggleListener(int step, Element button, Element modal)
  {
    print("toggleListener: step: $step");
    /*
     * Unfortunately it seems that document.on.click is processed after the
     * answer.on.click is done processing. That means that even if your answer.on.click
     * event adds a document.on.click, the document.on.click will be invoked
     * immediately of the same click. To get around this problem, answer.on.click
     * adds an intermediary document.on.click event that does nothing but add the 
     * true desired document.on.click event.
     */
    if (_showEvent == null)
      _showEvent = (event) => showModal(button, modal);
    if (_hideEvent == null)
      _hideEvent = (event) => hideModal(button, modal);
    if (_skipEvent == null)
      _skipEvent = (event) => toggleListener(3, button, modal);
    
    if (step == 1)
    {
      button.on.click.add(_showEvent);
      document.on.click.remove(_hideEvent);
    } 
    else if (step == 2)
    {
      button.on.click.remove(_showEvent);
      document.on.click.add(_skipEvent);
    }
    else
    {
      document.on.click.remove(_skipEvent);
      document.on.click.add(_hideEvent);
    }
    
  }
  
  /// show the modal and set up event to hide on document click
  void showModal(Element button, Element modal)
  {
    modal.style
    ..boxShadow = "1.0em 1.0em 1.0em rgba(0,0,0,0.2)"
    //..transform = "translateZ(3em)"
    ..transform = "translateX(-1em) translateY(-1em)"
    ..opacity = "1"
    ..visibility = "visible";
    toggleListener(2, button, modal);
  }
  
  /// hide the modal and set up event to show on button click
  void hideModal(Element button, Element modal)
  {
    modal.style
    ..boxShadow = "-0.2em -0.2em -0.2em rgba(0,0,0,0.3)"
    //..transform = "translateZ(-3em)"
    ..transform = "translateX(0em) translateY(0em)"
    ..opacity = "0"
    ..visibility = "hidden";
    toggleListener(1, button, modal);
  }
  
  
  /**
   * Constructor
   */
  Answer(this.points, this.text, this.explanation);
}
