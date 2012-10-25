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
    
    //to be replaced by a setter, using an outside source for the questions
    switch(star){
      case 1: this.questions = oneStarQuestions(); break;
//      case 2: this.questions = twoStarQuestions(); break;
//      case 3: this.questions = threeStarQuestions(); break;
//      case 4: this.questions = fourStarQuestions(); break;
      default: break;
    }
  }
  
  /**
   * This method will store all of the one star questions into the Test Section
   */
  List<Question> oneStarQuestions()
  {
    List<Question> q = new List<Question>();
    MultipleSelect q1 = new MultipleSelect("How often in development do you produce fully working, documented, and tested software?");
    q1.answers.add(new Answer(0,"When it's finished","Q"));
    q1.answers.add(new Answer(1,"We go through many iterations","Q"));
    q1.answers.add(new Answer(2,"We do iterations of a fixed length less than 4 weeks","Q"));
    MultipleSelect q2 = new MultipleSelect("How much is documented before start of implementation?");
    q2.answers.add(new Answer(0,"Complete product is specified","Q"));
    q2.answers.add(new Answer(1, "Basic product features, expected to change","Q"));
    q2.answers.add(new Answer(0, "Little, someone decides what to do","Q"));
    q2.answers.add(new Answer(1, "Clearly defined goals, details will be worked out","Q"));
    MultipleSelect q3 = new MultipleSelect("How often do you adjust or improve your way of working?");
    q3.answers.add(new Answer(0,"Nearly never, management takes care","Q"));
    q3.answers.add(new Answer(1,"We hold regular meetings and change things","Q"));
    q3.answers.add(new Answer(0,"After something important went wrong","Q"));
    q3.answers.add(new Answer(1,"Every day we identify issues and take actions","Q"));
    MultipleSelect q4 = new MultipleSelect("Is there a collection of items and features describing the product?");
    q4.answers.add(new Answer(0,"One big requirements document","Q"));
    q4.answers.add(new Answer(1,"List prioritized by customer/business needs","Q"));
    q4.answers.add(new Answer(0,"Some parts, not always up to date","Q"));
    q4.answers.add(new Answer(1,"List with user stories and estimated difficulty","Q"));
    MultipleSelect q5 = new MultipleSelect("Do you know someone who is responsible for the product?");
    q5.answers.add(new Answer(0,"No, we use documents to communicate","Q"));
    q5.answers.add(new Answer(1,"One person is responsible and always available","Q"));
    q5.answers.add(new Answer(0,"Group of people is responsible","Q"));
    q5.answers.add(new Answer(1,"Direct contact to a customer representative","Q"));
    MultipleSelect q6 = new MultipleSelect("How is the team's work planned?");
    q6.answers.add(new Answer(0,"Management decides what's needed","Q"));
    q6.answers.add(new Answer(1,"Team implements high value items first","Q"));
    q6.answers.add(new Answer(0,"Developers know what's important","Q"));
    q6.answers.add(new Answer(1,"Team and customer plan multiple iterations","Q"));
    MultipleSelect q7 = new MultipleSelect("How do teams track their work?");
    q7.answers.add(new Answer(0,"Write down how many hours spent","Q"));
    q7.answers.add(new Answer(1,"Estimate weekly the remaining work","Q"));
    q7.answers.add(new Answer(0,"Write weekly status report","Q"));
    q7.answers.add(new Answer(1,"Update daily how much work is remaining","Q"));
    MultipleSelect q8 = new MultipleSelect("Do you know if your team efficiency improves over time?");
    q8.answers.add(new Answer(0,"I don't know, we don't measure this","Q"));
    q8.answers.add(new Answer(1,"Team can compare efficiency of past iterations","Q"));
    q8.answers.add(new Answer(0,"We can measure time spent and overtime","Q"));
    q8.answers.add(new Answer(1,"Team knows velocity and improves it","Q"));
    MultipleSelect q9 = new MultipleSelect("How are big decisions make during development");
    q9.answers.add(new Answer(0,"Management can handle the big decisions for the team","Q"));
    q9.answers.add(new Answer(0,"The project leader or tech leader decides how we solve problems","Q"));
    q9.answers.add(new Answer(1,"We plan everything out from the beginning so that we won't have to make any big decisions during development","Q"));
    q9.answers.add(new Answer(0,"We decide everything as a group during our meetings","Q"));
        
    q.add(q1);
    q.add(q2);
    q.add(q3);
    q.add(q4);
    q.add(q5);
    q.add(q6);
    q.add(q7);
    q.add(q8);
    q.add(q9);
    return q;
  }
  
  TestSection twoStarQuestions()
  {
    return this;
  }
  
  TestSection threeStarQuestions()
  {
    return this;
  }
  
  TestSection fourStarQuestions()
  {
    return this;
  }
  
  Question currentQuestion;
  
  Question nextQuestion(){
    var num;
    if (this.currentQuestion == null)
      num = 0;
    else
      num = this.questions.indexOf(currentQuestion, 0) + 1;
    
    if (this.questions.length > num)
    {
      this.currentQuestion = this.questions[num];
      print("Next Question.");
    }
    else
      print("Finished. Do something else here.");
    
    return this.currentQuestion;
  }
  
  Element display()
  {
    return this.currentQuestion.display();
  }
}
