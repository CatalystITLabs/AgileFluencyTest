part of test;

/**
 * A possible answer to a multiple choice style question
 */
class Answer {
  /**
   * the point value for this answer (ex. 0 for incorrect answers)
   */
  int points;
  /**
   * the text of the answer (ex. "The code will generate a NullPointerException.")
   */
  String text;
  
  /**
   * 
   */
  String explanation;
  
  Answer(this.points, this.text, this.explanation);
}
