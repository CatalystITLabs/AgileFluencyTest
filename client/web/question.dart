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
   * Optional text on the question to explain a question a user might
   * have gotten wrong, or just want to know more about.
   */
  String explanation;
  
  /**
   * Returns true if a valid answer has been given to the question. 
   */
  bool validate()
  {
    return true;
  }
  
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
  String explain() {
    var output = new StringBuffer();
    output.add("\"$this.text\"<br/>");
    if (this.explanation != null)
      output.add("$this.explanation<br/>");
  }
  
  /**
   * Get the question displayed in html.
   */
  Element display();
  
  void enableNextButton()
  {
    InputElement nextButton = query("#nextQuestion");
    nextButton.disabled = false;
  }
}
