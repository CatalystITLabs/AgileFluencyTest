part of test;

class TestSection
{
  List<MultipleChoice> questions;
  XmlElement allQnA;
  int star;
  
  /**
   * 
   */
  TestSection(int level)
  {
    ParseQuestionXml xml = new ParseQuestionXml();
    allQnA = xml.allElements;
    questions = new List<MultipleChoice>();
    star = level;
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
          ss_question.answers.addAll(answers);
          questions.add(ss_question);
        }
        else if(questionEle.attributes.containsValue('MultipleSelect'))
        {
          ms_question = new MultipleSelect(text[0].text);
          ms_question.answers.addAll(answers);
          questions.add(ms_question);
        }
      }
    }
  }
}
