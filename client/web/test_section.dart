part of test;

class TestSection {
  List<Question> questions;
  
  /**
   * star is used in reference to the Agile Fluency article.
   */
  int star;
  
  /**
   * default constructor
   */
  TestSection(int level){
    this.star = level;
    this.questions = new List<Question>();
  }
  
}
