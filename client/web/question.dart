part of test;

/**
 * An abstract test question
 */
abstract class Question {
  
  /**
   * The text of the question itself (ex. "What color is the sky?")
   */
  String text;
  
  /**
   * Get the greatest number of points it is possible to receive on this question
   */
  int getMaximumPoints();
  
  /**
   * returns whether the users answer actually earns the maximum number of points for this question
   */
  bool gotMaxPoints()
  {
    return this.getUserAnswerPoints() == this.getMaximumPoints();
  }
  
  /**
   * Get the number of points the user earns for their answer to the question.
   */
  int getUserAnswerPoints();
  
  /**
   * Explain why the answer why the test taker was scored the way they were.
   */
  String explain();
  
  /**
   * Get the question displayed in html.
   */
  Element display();
}
