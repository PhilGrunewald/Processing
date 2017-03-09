// Based on a concept from 
// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com
// Classes:
// ./Bomb.pde
// ./Boundary.pde
// ./Box.pde
// ./box2d_boxes2.pde
// ./Circle.pde
// ./Projectile.pde
// ./Minion.pde
// Basic example of falling rectangles

// TODO!!
// needs box2d library to be place in this folder

import pbox2d.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.joints.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.collision.shapes.Shape;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.contacts.*;

// A reference to our box2d world
PBox2D box2d;

// A list we'll use to track fixed objects
ArrayList<Boundary> boundaries;
// A list for all of our rectangles
ArrayList<Box> boxes;

int x1,x2,y1,y2;
int gravity = 0;
float MenuX=40;
float MenuTargetX=40;
float MenuSpeed=0;

boolean circleOn = false;

String Mode = "ShrinkRay";

PImage imgMinion = loadImage("minion.png");
PImage imgMinionEvil = loadImage("minionEvil.png");
PImage imgShrinkRay = loadImage("ShrinkRay.png");

void setup() {
imgMinion.resize(0,50);
imgMinionEvil.resize(0,50);
imgShrinkRay.resize(0,50);
  size(1440,850);
  // Initialize box2d physics and create the world
  box2d = new PBox2D(this);
  box2d.createWorld();
  // We are setting a custom gravity
  box2d.setGravity(0, gravity);

  // Turn on collision listening!
  box2d.listenForCollisions();

  // Create ArrayLists	
  
  boxes = new ArrayList<Box>();
 
  boundaries = new ArrayList<Boundary>();

}



void keyPressed(){
   if (key == ' ') {
     Box p = new Bomb(mouseX-5,mouseY-5,mouseX+5,mouseY+5); 
     boxes.add(p);
  } 
  
   if (key == 'g') {
     if (gravity <0) {
       gravity=0;
     } else {
        gravity=-10; 
     }
     box2d.setGravity(0, gravity);
   }
  
   if (key == 'b') {Mode ="Box";}
   if (key == 'c') {Mode ="Circle";}
   if (key == 'v') {Mode ="Bullet";}
   if (key == 'x') {Mode ="Boundary";}
   if (key == 'm') {
           if (Mode == "Evil") {
            Mode = "Minion";
            } else {
            Mode ="Evil";
            }
           }
  if (key == 'r') {
    for (int i = boxes.size()-1; i >= 0; i--) {
    Box b = boxes.get(i);
      boxes.remove(i);
      b.killBody();
  }
  }
  
  if (key == 'R') {
    for (int i = boundaries.size()-1; i >= 0; i--) {
    Boundary b = boundaries.get(i);
      boundaries.remove(i);
      b.killBody();
  }
  }
}

void mousePressed(){
  x1=mouseX;
  y1=mouseY;
  if (x1<75) {
    if (y1<75)
    {Mode ="Boundary";}
    else if (y1<155) {
      Mode ="Box";
    }
    else if (y1<235) {
      Mode ="Circle";
    }
    else if (y1<315) {
      Mode ="Bullet";
    }
     else if (y1<395) {
      if (Mode == "Evil") {
        Mode = "Minion";
        } else {
        Mode ="Evil";
        }
    }
     else if (y1<475) {
        Mode = "ShrinkRay";
    }
  }
}
void mouseDragged() {
  if (Mode =="Boundary") {fill(0,0,0); rect((mouseX+x1)/2,(mouseY+y1)/2,mouseX-x1,mouseY-y1);}
  if (Mode =="Box") {stroke(0,100,0); rect((mouseX+x1)/2,(mouseY+y1)/2,mouseX-x1,mouseY-y1);}
  if (Mode =="Circle") {stroke(0,0,100); ellipse((mouseX+x1)/2,(mouseY+y1)/2,mouseX-x1,mouseY-y1);}
  if (Mode =="Evil") {image(imgMinionEvil,(mouseX+x1)/2,(mouseY+y1)/2,mouseX-x1,mouseY-y1);}
  if (Mode =="Minion") {image(imgMinion,(mouseX+x1)/2,(mouseY+y1)/2,mouseX-x1,mouseY-y1);}
  if (Mode =="Bullet") {stroke(0,100,0); line(x1,y1,mouseX,mouseY);}
  if (Mode =="ShrinkRay") {
    stroke(240,10,10); 
    line(20,height-20,mouseX,mouseY);
    }
}

void mouseReleased(){
  x2=mouseX;
  y2=mouseY;
  if ((x1-x2)*(x1-x2)+(y1-y2)*(y1-y2)>3){ // Minimum size requirement
  if (Mode =="Boundary") {boundaries.add(new Boundary(x1,y1,x2,y2));}  
  if (Mode =="Box") {Box p = new Box(x1,y1,x2,y2); boxes.add(p);}
  if (Mode =="Circle") {Box p = new Circle(x1,y1,x2,y2); boxes.add(p);}
  if (Mode =="Bullet") {
        Box p = new Projectile(x1-3,y1-3,x1+3,y1+3); 
        boxes.add(p); 
        p.addSpeed(new Vec2(x2-x1,y1-y2));
        }
  }
  if (Mode =="Evil") {Box p = new Minion(x1,y1,x1+15,y1+25); boxes.add(p); p.makeEvil();}
  if (Mode =="Minion") {Box p = new Minion(x1,y1,x1+15,y1+25); boxes.add(p);}
  if (Mode =="ShrinkRay") {
        Box p = new Projectile((20)-6,(height-20)-6,(20)+6,(height-20)+6); 
        boxes.add(p); 
        p.addSpeed(new Vec2((x2-(20))/10,((height-20)-y2)/10));
        }

}


// Collision event functions!
void beginContact(Contact cp) {
  // Get both fixtures
  Fixture f1 = cp.getFixtureA();
  Fixture f2 = cp.getFixtureB();
  // Get both bodies
  Body b1 = f1.getBody();
  Body b2 = f2.getBody();

  // Get our objects that reference these bodies
  Object o1 = b1.getUserData();
  Object o2 = b2.getUserData();

  if (o1.getClass() == Projectile.class && o2.getClass() == Minion.class) {
    Minion p2 = (Minion) o2;
    p2.makeGood();
  }
  if (o2.getClass() == Projectile.class && o1.getClass() == Minion.class) {
    Minion p1 = (Minion) o1;
    p1.makeGood();
  }

}

void endContact(Contact cp) {}

float swingSpeed(float tempY, float restY, float speed) {
  //Spring(240, 260,  40, 0.98, 8.0, 0.1, springs, 0);
    float k = 0.1;
    float damp = 0.72;
    int mass = 1;
    float force,accel;
   
    force = -k * (tempY - restY);  // f=-ky 
    accel = force / mass;                 // Set the acceleration, f=ma == a=f/m 
    speed = damp * (speed + accel);         // Set the velocity 
  return speed;
}

void drawMenu(float x) {
  rectMode(CENTER);
  int w=30; //half width
  // Display mode
  strokeWeight(4);
  if (Mode =="Boundary") {stroke(255,0,0);} else {stroke(100,100,100);} 
  fill(200,200,200); rect(x,40,70,70);
  fill(0); rect(x,40,50,10);
  
  if (Mode =="Box") {stroke(255,0,0);} else {stroke(100,100,100);}
  fill(200,200,200); rect(x,120,70,70);
  fill(200,0,0); rect(x,120,50,50);
  
  if (Mode =="Circle") {stroke(255,0,0);} else {stroke(100,100,100);}
  fill(200,200,200); rect(x,200,70,70);
  fill(0,0,200); ellipse(x,200,50,50);
  
  if (Mode =="Bullet") {stroke(255,0,0);} else {stroke(100,100,100);}
  fill(200,200,200); rect(x,280,70,70);
  stroke(0,200,0); line(x-20,260,x+20,300);

  if ((Mode =="Evil")||(Mode =="Minion")) {stroke(255,0,0);} else {stroke(100,100,100);}
  fill(200,200,200); rect(x,360,70,70);
  if (Mode == "Evil") {image(imgMinionEvil, x, 320);}
  else {image(imgMinion, x-10, 330);}

  if (Mode =="ShrinkRay") {stroke(255,0,0);} else {stroke(100,100,100);}
  fill(200,200,200); rect(x,440,70,70);
  image(imgShrinkRay, x-36, 420);  
}


void draw() {
  if (gravity==0) {background(40);}
  else {
        background(0,255,0);
      //  noCursor();
      }
  box2d.step();

  if (mouseX <70) {
    MenuTargetX=40;
  } else {
    MenuTargetX=-40;
  }
  MenuSpeed = swingSpeed(MenuX,MenuTargetX,MenuSpeed);
  MenuX     = MenuX+MenuSpeed;
  drawMenu(MenuX);

  // Display all the boundaries
  for (Boundary wall: boundaries) {
    wall.display();
  }
  
  for (int i = 0; i<boxes.size(); i++) {
    Box b = boxes.get(i);
      b.display();
  }

  if (Mode =="ShrinkRay") {
    pushMatrix();
    translate(20,height-20);
    float dY = (height-mouseY);
    float dX = (-mouseX);
    rotate(atan(dY/dX));
    image(imgShrinkRay,0,-20);
    image(imgMinion,10,-20);
    popMatrix();
  }
  // Boxes that leave the screen, we delete them
  // (note they have to be deleted from both the box2d world and our list
  for (int i = boxes.size()-1; i >= 0; i--) {
    Box b = boxes.get(i);
    if (b.done()) {
      boxes.remove(i);
    }
  }
}
