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
  String name;
  String description;
  String reference;
  
  //navigation
  ///The current question to be displayed and answered
  Question currentQuestion;
  bool atSummary = false;
  bool atExplanation = false;
  bool finished = false;
  
  //explantation settings
  bool explainCorrectQuestions = false;
  
  /**
   *  constructor inits the star level, list of questions and the XML element to query
   */ 
  TestSection(int level, String xml)
  {
    questions = new List<MultipleChoice>();
    star = level;
    allQnA = XML.parse(xml);
    getQnA();
  }
  
  /**
   *  queries the XML element by it's star level, then queries for componenets of a question w/i a section
   */  
  void getQnA()
  { 
    XmlCollection sections = allQnA.query({'level':star.toString()});
    
    for(XmlElement section in sections)
    {
      XmlCollection sectionName = section.query('name');
      this.name = sectionName.last.toString();
      XmlCollection sectionDescription = section.query('description');
      this.description = sectionDescription.last.toString();
      XmlCollection referenceURL = section.query('reference');
      this.reference = referenceURL.last.text;
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
   * Display the current question
   */
  Element displayCurrentQuestion()
  {
    var output = new DivElement();
    var sectionHeader = "Destination ${this.star}: ${this.name}";
    var questionNumber = this.questions.indexOf(this.currentQuestion,0) + 1;
    var sectionLength = this.questions.length;
    var header = "$sectionHeader<br/> Question $questionNumber of $sectionLength";
    output.addHTML("<h4>$header</h4>");
    output.insertAdjacentElement("beforeEnd",this.currentQuestion.display());
    return output;
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
    
    if (atSummary){
      if (! this.atExplanation)
        return this.summary();
      else return this.explain();
    }
    
    if (currentQuestion != null)
    {
      disableNextButton();
      return displayCurrentQuestion();
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
    if (atSummary)
      finished = true;
    else
    {
      var question = nextQuestion();
      //if we run out of questions we explain next
      if (question == null)
        atSummary = true;
    }
    
    return this.display();
  }
  
  /**
   * Provide questions and explanations, to be drilled down using CSS3 3D effects
   */
  Element explain()
  {
    print("Explaining section.");
    var output = new DivElement();
     
    //Explanation section
    output.id = "explanation";
    for (var question in this.questions)
    {
      DivElement questionExplanation = question.explain();
      questionExplanation.id = "explanation";
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
  
  void toExplanation()
  {
    atSummary = false;
    atExplanation = true;
  }
  
  /**
   * Brief summary section: stamp, progress, and review of section.
   */
  Element summary()
  {
    print("Summary section.");
    var output = new DivElement();
    var best = 0;
    var agile = 0;
    output.id = "summary";
    
    output.addHTML("<h4>Destination ${this.star}: ${this.name}<br/>Summary</h4>");
    
    var image = "../../example/3D/images/stamp_${this.star}.png";
    
    //calculations
    var percentageScore = (getUserAnswerPoints() * 100 ~/ getMaxPoints()).toInt();
    for (var question in this.questions)
    {
      if (question.getUserAnswerPoints() == question.getMaximumPoints())
        best++;
      if (question.getUserAnswerPoints() > 0)
        agile++;
    }
        
    /*
     * If we want to use the section images for bullets
     * output.style.listStyleImage = "url($image)";
     */
    
    //stamp image placeholder. The plan will be to zoom into this, to show the summary information.
    output.addHTML("<img src='$image' alt='Placeholder for stamp'/>");
    
    //Progress information...
    output.addHTML("<h4>Destination ${this.star} Progress:</h4><ul>");
    output.addHTML("<li>Total Agile Answers: $agile/${this.questions.length}</li>");
    output.addHTML("<li>Most Fluent Answers: $best/${this.questions.length}</li>");
    output.addHTML("<li>Estimated Progress: ${percentageScore}%</li></ul>");
    
    //section summary
    output.addHTML("<p>${this.description}</p>");
    output.addHTML("<p>Learn more about ${this.name} <a href='${this.reference}'>here</a></p>");
   
    //link explanation
    //TODO: modify on click event to actually do something
    var link = new ButtonElement();
    link.on.click.add(
        (event) => toExplanation());
    link.text = "Question Explanations";
    output.insertAdjacentElement("beforeEnd", link);
    return output;
  }
}
