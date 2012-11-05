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
    var pointsColorNum = (255 * this.points / maxPoints).toInt();
    
    //TODO: better conversion to hex
    var pointsColorHex = "0";
    if (pointsColorNum == 255)
      pointsColorHex = "FF";
    else if (pointsColorNum > 0)
      pointsColorHex = pointsColorNum.toRadixString(16);
    
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
   */
  Element explain(bool selectedByUser, int maxPoints, int displayExplanationMode)
  {
    var output = new LIElement();
    var answerText = displayForExplanation(selectedByUser, maxPoints);
    output.innerHTML = answerText;
    
    //replace answer text with explanation on hover
    if (this.explanation != null && displayExplanationMode == 1)
    {
      output.on.mouseOver.add(
          (event) => output.innerHTML = "<b>$explanation</b>");
      output.on.mouseOut.add(
          (event) => output.innerHTML = answerText);
    }
    //append answer text with explanation on hover
    if (this.explanation != null && displayExplanationMode == 2)
    {
      output.on.mouseOver.add(
          (event) => output.insertAdjacentHTML("beforeEnd", "<b>$explanation</b>"));
      output.on.mouseOut.add(
          (event) => output.innerHTML = answerText);
    }
    return output;
  }
  
  /**
   * Constructor
   */
  Answer(this.points, this.text, this.explanation);
}
