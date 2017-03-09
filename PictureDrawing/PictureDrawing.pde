/**
 * Simple Maths Quiz
 * by Philipp Grunewald.  
 * 
 * Enter the answer to the times question,
 * with every right answer the fountain gets happier.
 */
import java.util.Iterator;

ParticleSystem ps;
PImage myPicture;

String lastInput = new String();
String currentInput = new String();
boolean correctAnswer = false;
int intA = int(random(11)+1);
int intB = int(random(11)+1);
int hitCount = 1;
int maxCount = 0;
int totalCount = 0;

void setup() {
  size(860, 460);
  //size(460, 345);
  smooth();
  ps = new ParticleSystem(new PVector(width/2,10));
  myPicture = loadImage("/Users/pg1008/Documents/Software/Processing/PictureDestruction/dino.jpg");
  //myPicture = loadImage("http://www.distributed-energy.de/wp-content/uploads/2015/04/DSCN0799.jpg");

}

void draw() {
  //background(0, 0, 255);
  fill(100, 100, 255);
  noStroke();
  
  ps.addParticle(hitCount);
  ps.run();

 loadPixels();
 image(myPicture, 210, 200);
 myPicture.loadPixels();
 updatePixels();

 myPicture.updatePixels();

 
}
