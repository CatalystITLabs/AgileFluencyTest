import 'dart:html';
import 'dart:math';
import "../../lib/test.dart";
import "../../packages/presentation/presentation.dart";

// generates test content and grades
Test test = new Test();

// powers 3d transitions 
SlideShow slideshow = new BasicSlideShow(query("#viewBox"));

// slide placement settings
num currentSlidePosition = -15.5;

// camera default settings
num camTransDuration = 1;
num camX = 1330;
num camY = 400;
num camZ = 50000;
num camXr = 0; 
num camYr = 0;
num camZr = 0;

// page controls
InputElement nextButton = query("#nextButton");
InputElement backButton = query("#backButton");
InputElement continueButton = query("#nextButton");
InputElement explainButton = query("#explainButton");
InputElement finishButton = query("#finishButton");

// track earned stamps
//ImageElement stamp = new ImageElement();
List<Element> stampsEarned = new List<Element>();

/// returns an element with the section stamp Element
Element getStamp(int number, bool placed)
{
  var stampContainer = new DivElement();
  var dateTxt = new ParagraphElement();
  var stamp = new ImageElement();
  //String id;
  /*Date today = new Date.now();
  //var dfmt = new DateFormat();
  dateTxt.style
  ..textAlign = "center"
  ..fontFamily = "Courier New"
  ..fontSize = "1.2em"
  ..transform = "rotate(20deg)";
  dateTxt.innerHTML = today.toLocal().toString();
  dateTxt.style.zIndex = "1";*/
 
  stamp.classes.add("stamp");
  stamp.src = "images/stamp_$number.png";
  if(!placed)
  {
    stamp.id = "stamp${number}Unplaced";
    
    window.setTimeout(()
      {
        stamp.id = "stamp${number}Placed";
        stampsEarned.add(stamp);
        
      }, 100);
  }
  else
  {
    stamp.id = "stamp${number}Placed";
  }
  stampContainer.style.width = "250px";
  //stampContainer.insertAdjacentElement("beforeEnd", dateTxt);
  stampContainer.insertAdjacentElement("beforeEnd", stamp);
  
  return stampContainer;
}

/// adds a huge map to the scene
void addBackground()
{
  var element = new ImageElement();
  element.src = "images/world_8bit.png";
  var slide = new Slide(element, 50.0, 0 , 0, 0, 0, 0);  
  slideshow.addBackgroundSlide(slide);
  //no transitions because this slide is never focused / transitioned to.
}


/// adds a new slide on the map
Slide addSlideToMap(Element slideContents)
{
  // use a sin wave and scale it to look like a global journey
  num slidePositionXScale = 2000;
  num slidePositionYScale = 10000;
  num waveScale = 2.0;
  num waveShift = -3.0;
  var x = currentSlidePosition * slidePositionXScale;
  var y = sin(currentSlidePosition / waveScale + waveShift) * slidePositionYScale;
  return slideshow.addElementSlide(slideContents, 1.0, currentSlidePosition * slidePositionXScale, y, 0, 0, 0, 0);
}

/**
 * wrapper method for the camera move method that sets the default camera
 * positions as arguments
 */
void lookAtMap()
{
  slideshow.cam.move(camTransDuration, camX, camY, camZ, camXr, camYr, camZr);
}

/// Reset all buttons to hidden
void hideButtons()
{
  nextButton.style.visibility = "hidden";
  continueButton.style.visibility = "hidden";
  backButton.style.visibility = "hidden";
  explainButton.style.visibility = "hidden";
  finishButton.style.visibility = "hidden";
}

/// Make visible all buttons used by the summary page
void enableSummaryButtons()
{
  finishButton.style.visibility = "visible";
  if(test.currentSection != test.sections.last)
    continueButton.style.visibility = "visible";
  explainButton.style.visibility = "visible";
}

///Advance the test to the next question or step
void nextQuestion()
{
  //get next step from test
  Element slideElement = test.next();
  assert(slideElement != null);
  
  hideButtons();

  if(slideElement.id.startsWith("summary"))
  {
    enableSummaryButtons();
    
    //for( int x = 1; x<= test.currentSection.star; x++)
    //{
      num sectionFluency = 100*(test.currentSection.getUserAnswerPoints()/test.currentSection.getMaxPoints());
      
      //if(!stampsEarned.isEmpty)
      //{
        for(Element stamp in stampsEarned)
        {
          //if(stampsEarned.last != stamp)
          //{
            slideElement.insertAdjacentElement("beforeEnd", stamp);
          //}
        }
      //}
      
      //stamp passport if the user has earned an acceptable level of fluency for the section
      if(sectionFluency > 70)
      {
         // stamp is not place...set id to unplaced, then use callback function to switch it to placed
         Element stamp = getStamp(test.currentSection.star, false); 
         slideElement.insertAdjacentElement("beforeEnd", stamp);
         // set the stamp to placed...no animation needed
         //stamp = getStamp(test.currentSection.star, true);
         //stampsEarned.add(stamp);
      }
    //}
  }
  
  slideshow.useDynamic = true;
  currentSlidePosition += 1;
  //create and add a new slide for this next test stepaddSlideToMap
  addSlideToMap(slideElement);
  
  //use the presentation to progress to this next step
  slideshow.next();
}

/**
 * Shows the explanation and return button.
 * Hides the summary and explain button.
 */
void displaySectionExplanation()
{
  backButton.style.visibility = "visible";
  nextButton.style.visibility = "visible";
  
  String summaryId = "#summary${test.currentSection.star}";
  Element explainDiv = query("#explainSection");
  Element summaryDiv = query(summaryId);
  summaryDiv.style.visibility = "hidden";
  
  //Just copy the output from Test into our existing div
  var explainContent = query("#explainContent");
  explainContent.elements = test.currentSection.explain().elements;
  
  //add to slide, zoomin, and focus the slide
  var slide = addSlideToMap(explainDiv);
  slideshow.cam.lookAtSlide(slide, 1);
  slideshow.next();
}

///Adds on click events to the buttons
void scriptButton()
{  
  Element nextButton = query('#nextButton');
  
  nextButton.on.click.add((event)
  {      
    if(test.currentSection.atSummary)
    {
      String summaryId = "#summary${test.currentSection.star}";
      Element summaryDiv = query(summaryId);
      summaryDiv.style.visibility = "visible";
    }
    
    lookAtMap();
    nextQuestion();
  });
    
  explainButton.on.click.add((event)
  {  
    hideButtons();
    displaySectionExplanation();
  });
  
  backButton.on.click.add((event)
  {    
    hideButtons();
    enableSummaryButtons();
    
    String summaryId = "#summary${test.currentSection.star}";
    Element explainDiv = query("#explainSection");
    Element summaryDiv = query(summaryId);
    summaryDiv.style.visibility = "visible";

    addSlideToMap(summaryDiv);

    lookAtMap();
    slideshow.next();
  });
  
  finishButton.on.click.add((event)
  {
    hideButtons();
    Element finalSection = query("#finalSection");
    
    var slide = slideshow.addElementSlide(finalSection, 1.0, 0,0,0,0,0,0);
    
    slideshow.cam.lookAtSlide(slide, 1);
    slideshow.next();
  });
}

/// move the camera back to see the map and trigger the test to begin
void startTest()
{
  lookAtMap();
  window.setTimeout(()
  {
    nextQuestion();
    scriptButton();
  }, 1500);
}

/// add splash screen and event to trigger the test
void addSplash()
{
  // div for splash slide and add to slideshow behind the map
  var slideElement = query("#splash");
  var startButton = query("#startButton");
  var slide = slideshow.addElementSlide(slideElement, 1.0, 0, 0, -2000, 0, 0, 0);
  
  // set camera at splash slide and script start button
  slideshow.cam.lookAtSlide(slide, 0);
  startButton.on.click.add((event) =>  startTest());
  // sets splash as the current slide and gives it focus
  slideshow.start();
}

/**
 * call back method is called by the HttpRequest get method
 * processes the the response text by passing it to the test 
 * section constructor
 * 
 * method also serves as user input entry point
 */
onSuccess(HttpRequest request)
{
  // load test content from xml
  for(int i=1; i<5; i++)
  {
    test.sections.add(new TestSection(i, request.responseText));
  }
  
  var viewBox = query("#viewBox");
  viewBox.style.transition = "0.5";
  
  window.setTimeout(()
  {
    //clear loading screen
    viewBox.style.backgroundImage = "none";
    viewBox.innerHTML = "";
    
    //add map and first slide
    addBackground();
    addSplash();
  }, 500);
}

void main()
{
  // relative location of the questions on the server
  var url = "../questions.xml";
  // async request to get the file at the given url
  var request = new HttpRequest.get(url, onSuccess);
}