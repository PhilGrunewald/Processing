/**
 * Simple Maths Quiz
 * by Philipp Grunewald.  
 * 
 * Enter the answer to the times question,
 * with every right answer the fountain gets happier.
 */
import java.util.Iterator;

ParticleSystem ps;

String lastInput = new String();
String currentInput = new String();
boolean correctAnswer = false;
int intA = int(random(11)+1);
int intB = int(random(11)+1);
int hitCount = 0;
int maxCount = 0;
int totalCount = 0;

void setup() {
  //size(640,360);
  size(1000,600);
  smooth();
  ps = new ParticleSystem(new PVector(width/1.2,height/3));
}
//alpha

void keyPressed()
{
 if(key == ENTER)
 {
   if (int(currentInput)==(intA * intB)) {
     correctAnswer = true;
     hitCount = hitCount +1;
     totalCount = totalCount +1;
     if (totalCount % 10 == 0) {
      ps.addStar(totalCount);
     }
     if (hitCount > maxCount) {
        maxCount = hitCount;
     }
     //intA = int(random(8)+4);
     //intB = int(random(8)+4);
     intA = int(random(4)+1);
     intB = int(random(5)+1);
   }
   else
   {
     correctAnswer = false;
     hitCount = 0;
   }
   lastInput = "";
   currentInput = "";
 }
 else if(key == BACKSPACE && currentInput.length() > 0)
 {
   currentInput = currentInput.substring(0, currentInput.length() - 1);
 }
 else
 {
   currentInput = currentInput + key;
 }
}


void draw() {
  background(0, 0, 255);
  fill(100, 100, 255);
  noStroke();
  rect(0,height/1.5,width,height/2);
  noFill();
  stroke(255, 255);
  rect(width/1.2-10,height/1.5,20,(height/3 - height/1.5));
  
  if (correctAnswer) {
    ps.addParticle(hitCount);
    text("That's " +str(hitCount) + " in a row!", width/4, height/4);
  } else {
    text(str(intA) + " x " + str(intB) + "= " + str(intA*intB) + ". Keep trying!", width/4, height/4);
  }
  text("Your best series is " +str(maxCount) + " in a row!", width/4, height/1.5);
  ps.run();
  fill(0);
  textSize(24);
 text(str(intA) + " x " + str(intB) + "= ", width/8, height/3);
 fill(255, 0, 0);
 text(currentInput, width/4, height/3);
}
