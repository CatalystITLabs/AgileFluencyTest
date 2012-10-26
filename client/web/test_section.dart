part of test;

/**
 * A segment of the test which is graded seperately and
 * may be explained separately etc.
 */
class TestSection
{
  List<MultipleChoice> questions;
  XmlElement allQnA;
  int star;
  
 
  TestSection(int level)
  {
    ParseQuestionXml xml = new ParseQuestionXml();
    allQnA = xml.allElements;
    questions = new List<MultipleChoice>();
    star = level;
    getQnA();
  }
  
  void getQnA()
  {
    XmlCollection sections = allQnA.query({'level':star.toString()});
    
    for(XmlElement section in sections)
    {
      XmlCollection questionList = section.queryAll('question');
      
      for(XmlElement questionEle in questionList)
      {
        XmlCollection text = questionEle.query('text');
        XmlCollection explanation = questionEle.query('explanation');
        XmlCollection answerList = questionEle.queryAll('answer');
        
        Answer answer;
        List<Answer> answers = new List<Answer>();
        SingleSelect ss_question;
        MultipleSelect ms_question;
        
        for(XmlElement answerEle in answerList)
        {
          XmlCollection points = answerEle.query('points');
          XmlCollection answerTxt = answerEle.query('text');
          XmlCollection explainTxt = answerEle.query('explanation');
          
          answer = new Answer(Math.parseInt(points[0].text), answerTxt[0].text, explainTxt[0].text);
          answers.add(answer);
        }
        
        if(questionEle.attributes.containsValue('SingleSelect') || questionEle.attributes.containsValue('MultipleChoice'))
        {
          ss_question = new SingleSelect(text[0].text);
          ss_question.explanation = explanation[0].text;
          ss_question.answers.addAll(answers);
          questions.add(ss_question);
        }
        else if(questionEle.attributes.containsValue('MultipleSelect'))
        {
          ms_question = new MultipleSelect(text[0].text);
          ms_question.explanation = explanation[0].text;
          ms_question.answers.addAll(answers);
          questions.add(ms_question);
        }
      }
    }
  }
  
  /**
   * The name of the section
   */
  String name;
  
  /**
   * The current question to be displayed and answered
   */
  Question currentQuestion;
  
  bool explainAllQuestions = false;
  bool explainWrongQuestions = true;
  bool explaining = false;
  bool finished = false;
  
  void enableNextButton()
  {
    InputElement nextButton = query("#nextQuestion");
    nextButton.disabled = false;
  }
  
  void disableNextButton()
  {
    InputElement nextButton = query("#nextQuestion");
    nextButton.disabled = true;
  }
  
  /**
   * Advance this test to the next question
   */
  Question nextQuestion(){
    //first get the index of the next question
    var num;
    if (this.currentQuestion == null)
    {
      if (this.questions.length > 0)
      {
        this.currentQuestion = this.questions[0];
        return this.currentQuestion;
      }
      else
      {
        print ("Why is the question list empty?");
        return null;
      }
    }
    else
    {
      num = this.questions.indexOf(currentQuestion, 0) + 1;
    }
    
    //if a question actually corresponds to this index set currentQuestion to it
    if (this.questions.length > num)
    {
      this.currentQuestion = this.questions[num];
      //print("Next Question.");
    }
    else
    {
      print("No next Question.");
      return null;
    }
    
    assert(this.currentQuestion != null);
    return this.currentQuestion;
  }
  
  /**
   * Display the current question or page
   */
  Element display()
  {
    enableNextButton();
    //if the test section is finished stop returning pages
    if (finished)
      return null;
    
    if (explaining)
      return this.explain();
    
    if (currentQuestion != null)
    {
      disableNextButton();
      return this.currentQuestion.display();
    }
    return null;
  }
  
  
  /**
   * Return the next page of the TestSection
   */
  Element next()
  {
    //if the test section is finished stop returning pages
    if (finished)
    {
      return null;
    }
    
    //if we're explaining we're finished next
    if (explaining)
      finished = true;
    else
    {
      var question = nextQuestion();
      //if we run out of questions we explain next
      if (question == null)
        explaining = true;
    }
    
    return this.display();
  }
  
  /**
   * Explain all questions in the section as needed.
   */
  Element explain()
  {
    print("Explaining section.");
    var output = new DivElement();
    output.id="explanation";
    var percentageScore = (getUserAnswerPoints() * 100 / getMaxPoints()).toInt();
    output.addHTML("<p>$percentageScore% Agile Fluency</p>");
    for (var question in this.questions)
    {
      DivElement questionExplanation = new DivElement();
      questionExplanation.innerHTML = question.explain();
      output.insertAdjacentElement('beforeEnd', questionExplanation);
    }
    return output;
  }
  
  /**
   * Get the maximum number of points achieveable in the TestSection
   */
  int getMaxPoints()
  {
    var total = 0;
    for (var question in this.questions)
    {
      total += question.getMaximumPoints();
    }
    return total;
  }
  
  /**
   * Get the total points earned by the users answers
   */
  int getUserAnswerPoints() 
  {
    var total = 0;
    for (var question in this.questions)
    {
      total += question.getUserAnswerPoints();
    }
    return total;
  }
}
