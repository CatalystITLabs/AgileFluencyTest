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
   * Constructor
   */
  Answer(this.points, this.text, this.explanation);
}
