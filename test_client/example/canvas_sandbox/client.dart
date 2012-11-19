import 'dart:html';
import "../../packages/presentation/presentation.dart";

SlideShow slideshow = new BasicSlideShow(query("#viewBox"));

void done()
{
  slideshow.cam.move(1.0, 0, 0, 100000, 0, 0, 0);
}

/**
 * Draw a small circle representing a seed centered at (x,y).
 */
void drawPath(CanvasRenderingContext2D context, num fromX, num fromY, num toX, num toY) {
  context.beginPath();
  context.moveTo(fromX, fromY);
  var midX = (fromX + toX) / 2;
  var midY = (fromY + toY) / 2 - 50;
  context.quadraticCurveTo(midX, midY, toX, toY);
  context.lineWidth = 10;

  // line color
  context.strokeStyle = 'black';
  context.stroke();
}

Element makeCanvas()
{
  var width = 1366;
  var height = 847;
  var canvas = new CanvasElement();
  var context = canvas.context2d;
  canvas.width = width;
  canvas.height = height;
  
  var image = new ImageElement();
  image.src = "images/world_8bit.png";
  image.on.load.add( (event)
      {
      context.clearRect(0, 0, width, height);
      context.drawImage(image, 0, 0);
      drawPath(context, 200, 400, 400, 500);
      }
  );

  return canvas;
}

void addBackground()
{
  var slideElement = new DivElement();
  slideElement.insertAdjacentElement("beforeEnd", makeCanvas());
  slideElement.insertAdjacentText("afterBegin", "Top");
  slideElement.insertAdjacentText("beforeEnd", "Bottom");
  var slide = new Slide(slideElement, 1.0, 0 , 0, 0, 0, 0);  
  slideshow.addBackgroundSlide(slide);
  slideshow.cam.lookAtSlide(slide, 0);
  slideshow.cam.move(3.0, slideshow.cam.position.x, slideshow.cam.position.y, 1000, 0, 0, 0);
  //no transitions because this slide is never focused / transitioned to.
}

void main()
{
  addBackground();
  slideshow.start();
  query("#container").insertAdjacentElement("beforeEnd", makeCanvas());
 
}
