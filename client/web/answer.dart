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
  
  String displayForExplanation(bool selectedByUser, int maxPoints)
  {
    var answerString = this.text;
    var pointsColorNum = (255 * this.points / maxPoints).toInt();
    
    //TODO: better conversion to hex
    var pointsColorHex = "0";
    if (pointsColorNum == 255)
      pointsColorHex = "FF";
    else if (pointsColorNum > 0)
      pointsColorHex = 99 * this.points ~/ maxPoints;
    
    if (pointsColorNum != 0)
      answerString = "<font color=\"rgb(0,0,$pointsColorHex)\">$answerString</font>";
    if (selectedByUser)
      answerString = "=> $answerString <=";
    return answerString;
  }
  
  Element explain(bool selectedByUser, int maxPoints)
  {
    var output = new LIElement();
    output.innerHTML = displayForExplanation(selectedByUser, maxPoints);
    output.on.mouseOver.add(
        (event) => output.innerHTML = this.explanation);
    output.on.mouseOut.add(
        (event) => output.innerHTML = displayForExplanation(selectedByUser, maxPoints));
    return output;
    
  }
  
  /**
   * Constructor
   */
  Answer(this.points, this.text, this.explanation);
}
