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
   * Get the number of points the user earns for their answer to the question.
   */
  int getUserAnswerPoints();
  
  /**
   * Get the question displayed in html.
   */
  String display();
  
  bool gotMaxPoints();
  
  String explain();
}
