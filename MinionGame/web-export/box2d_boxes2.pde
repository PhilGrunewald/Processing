// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com
// Classes:
// /Users/pg1008/Documents/Software/Processing/box2d_boxes2/Bomb.pde
// /Users/pg1008/Documents/Software/Processing/box2d_boxes2/Boundary.pde
// /Users/pg1008/Documents/Software/Processing/box2d_boxes2/Box.pde
// /Users/pg1008/Documents/Software/Processing/box2d_boxes2/box2d_boxes2.pde
// /Users/pg1008/Documents/Software/Processing/box2d_boxes2/Circle.pde
// /Users/pg1008/Documents/Software/Processing/box2d_boxes2/Projectile.pde
// /Users/pg1008/Documents/Software/Processing/box2d_boxes2/Minion.pde
// Basic example of falling rectangles


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

PImage imgMinion = loadImage("/Users/pg1008/Documents/Software/Processing/box2d_boxes2/minion.png");
PImage imgMinionEvil = loadImage("/Users/pg1008/Documents/Software/Processing/box2d_boxes2/minionEvil.png");
PImage imgShrinkRay = loadImage("/Users/pg1008/Documents/Software/Processing/box2d_boxes2/ShrinkRay.png");

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
  else {background(60,60,235);}
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





// A turns into fragments after a while
class Bomb extends Circle {
int countdown =100;
  Bomb(float x1, float y1, float x2, float y2) {
    super( x1,  y1,  x2,  y2);
    
  }

  // Drawing the bomb
  void display() {
    super.display();
    Vec2 pos = box2d.getBodyPixelCoord(body);
    countdown-=1;
    if (countdown ==0) {
      noFill();
      stroke(128);
          ellipse(pos.x, pos.y, 50, 50);
          for (int i=0;i<30;i++){
            Box p = new Projectile(pos.x-3, pos.y-3,pos.x+3, pos.y+3);
            boxes.add(p); 
            p.addSpeed(new Vec2(random(-400,400), random(-400,400)));
          }
    }
  }
  
    // Is the particle ready for deletion?
  boolean done() {
    // Is it off the bottom of the screen?
    if (countdown ==0) {
      killBody();
      return true;
    }
    return false;
  }
  
}


// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

// A fixed boundary class

class Boundary {

  // A boundary is a simple rectangle with x,y,width,and height
  float x;
  float y;
  float w;
  float h;
  
  // But we also have to make a body for box2d to know about it
  Body b;

  Boundary(float x1_,float y1_, float x2_, float y2_) {
    x = (x2_+x1_)/2;
    y = (y2_+y1_)/2;
    w = x2_-x1_;
    if (w<0){w=-w;}
    h = y2_-y1_;
    if (h<0){h=-h;}
    

    // Define the polygon
    PolygonShape ps = new PolygonShape();
    // Figure out the box2d coordinates
    float box2dW = box2d.scalarPixelsToWorld(w/2);
    float box2dH = box2d.scalarPixelsToWorld(h/2);
    // We're just a box
    ps.setAsBox(box2dW, box2dH);


    // Create the body
    BodyDef bd = new BodyDef();
    bd.type = BodyType.STATIC;
    bd.position.set(box2d.coordPixelsToWorld(x,y));
    b = box2d.createBody(bd);
    
    // Attached the shape to the body using a Fixture
    b.createFixture(ps,1);
    b.setUserData(this);
  }

  void killBody() {
    box2d.destroyBody(b);
  }

  // Draw the boundary, if it were at an angle we'd have to do something fancier
  void display() {
    fill(0);
    stroke(0);
    rectMode(CENTER);
    rect(x,y,w,h);
  }

}


// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

// A rectangular box
class Box {

  // We need to keep track of a Body and a width and height

  Body body;
  float x1;
  float x2;
  float y1;
  float y2;

  float w;
  float h;
  float x;
  float y;
  color c; 

  boolean evil = false;
  // Constructor
  Box(float x1_, float y1_, float x2_, float y2_) {
    x1 = x1_;
    x2 = x2_;
    y1 = y1_;
    y2 = y2_;
    w = x2-x1;
    if (w<0){w=-w;}
    if (w==0){w=1;}
    
    h = y2-y1;
    if (h<0){h=-h;}
    if (h==0){h=1;}
    
    x = (x2+x1)/2;
    y = (y2+y1)/2;
    c= color(random(0,255),random(0,255),random(0,255));
    
    // Add the box to the box2d world
    makeBody(new Vec2(x, y), w, h);
    body.setUserData(this);
  }

  // This function removes the particle from the box2d world
  void killBody() {
    box2d.destroyBody(body);
  }

  // Is the particle ready for deletion?
  boolean done() {
    // Let's find the screen position of the particle
    Vec2 pos = box2d.getBodyPixelCoord(body);
    // Is it off the bottom of the screen?
    if (pos.y > height+w*h) {
      killBody();
      return true;
    }
    return false;
  }

void toggleEvil(){
  if (evil) {
    evil=false;  
  } else {
    evil=true;
  }
}
void makeGood(){
    evil=false;
}
void makeEvil(){
    evil=true;
}
  

  // Drawing the box
  void display() {
    // We look at each body and get its screen position
    Vec2 pos = box2d.getBodyPixelCoord(body);
    // Get its angle of rotation
    float a = body.getAngle();

    rectMode(CENTER);
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(-a);
    fill(c);
    stroke(0);
    strokeWeight(2);
    rect(0, 0, w, h);
    popMatrix();
  }

  FixtureDef makeFixture(PolygonShape sd) {
   // Define a fixture
    FixtureDef fd = new FixtureDef();
    fd.shape = sd;
    // Parameters that affect physics
    fd.density = 1;
    fd.friction = 0.3;
    fd.restitution = 0.5;
    return fd;
  }

  // This function adds the rectangle to the box2d world
  void makeBody(Vec2 center, float w_, float h_) {

    // Define a polygon (this is what we use for a rectangle)
    PolygonShape sd = new PolygonShape();
    float box2dW = box2d.scalarPixelsToWorld(w_/2);
    float box2dH = box2d.scalarPixelsToWorld(h_/2);
    sd.setAsBox(box2dW, box2dH);

    //body = createBody(center);
    BodyDef bd = new BodyDef();
    bd.type = BodyType.DYNAMIC;
    bd.position.set(box2d.coordPixelsToWorld(center));
    body = box2d.createBody(bd);
    
    body.createFixture(makeFixture(sd));
  }
  
void addSpeed(Vec2 speed) {
  body.setLinearVelocity(speed);
}
  
}


class Circle extends Box {

  Circle(float x1, float y1, float x2, float y2) {
    super( x1,  y1,  x2,  y2);
  }
  void display() {
    // We look at each body and get its screen position
    float a = body.getAngle();
    Vec2 pos = box2d.getBodyPixelCoord(body);
    ellipseMode(CENTER);
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(-a);
    fill(c);
    stroke(0);
    strokeWeight(2);
    ellipse(0, 0, w, w);
    popMatrix();
  }


  void makeBody(Vec2 center, float w_, float h_) {

    // Define a polygon (this is what we use for a rectangle)
    PolygonShape sd = new PolygonShape();
    float box2dW = box2d.scalarPixelsToWorld(w_/2);
    float box2dH = box2d.scalarPixelsToWorld(h_/2);
    sd.setAsBox(box2dW, box2dH);

    CircleShape circle = new CircleShape();
    circle.m_radius = box2d.scalarPixelsToWorld(w_/2);
    
    //body = createBody(center);
    BodyDef bd = new BodyDef();
    bd.type = BodyType.DYNAMIC;
    bd.position.set(box2d.coordPixelsToWorld(center));
    body = box2d.createBody(bd);
    
    body.createFixture(circle,1.0);
  }



  
}
class EvilMinion extends Box {

  EvilMinion(float x1, float y1, float x2, float y2) {
    super( x1,  y1,  x2,  y2);
  }


void display() {
    // We look at each body and get its screen position
    float a = body.getAngle();
    float v_a = body.getAngularVelocity();
    Vec2 pos = box2d.getBodyPixelCoord(body);
    ellipseMode(CENTER);
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(-a);
    if (evil) {image(imgMinionEvil, -17, -35);}
    else {image(imgMinion, -17, -35);}
    popMatrix();
    if (a>0.1) {
    body.setAngularVelocity((v_a-0.3)*0.9);
    } else if (a<-0.1) {
     body.setAngularVelocity((v_a+0.3)*0.9);
    }
  }

}
class Minion extends Box {

  Minion(float x1, float y1, float x2, float y2) {
    super( x1,  y1,  x2,  y2);
  }


void display() {
    // We look at each body and get its screen position
    float a = body.getAngle();
    float v_a = body.getAngularVelocity();
    Vec2 pos = box2d.getBodyPixelCoord(body);
    ellipseMode(CENTER);
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(-a);
    if (evil) {image(imgMinionEvil, -17, -35);}
    else {image(imgMinion, -17, -35);}
    popMatrix();
    if (a>0.1) {
    body.setAngularVelocity((v_a-0.3)*0.9);
    } else if (a<-0.1) {
     body.setAngularVelocity((v_a+0.3)*0.9);
    }
  }

}
class Projectile extends Circle {

  Projectile(float x1, float y1, float x2, float y2) {
    super( x1,  y1,  x2,  y2);
  }
  
  FixtureDef makeFixture(PolygonShape sd) {
   // Define a fixture
    FixtureDef fd = new FixtureDef();
    fd.shape = sd;
    // Parameters that affect physics
    fd.density = 30;
    fd.friction = 0.3;
    fd.restitution = 0.5;
    return fd;
  }

  // This function adds the rectangle to the box2d world
  void makeBody(Vec2 center, float w_, float h_) {

    // Define a polygon (this is what we use for a rectangle)
    PolygonShape sd = new PolygonShape();
    float box2dW = box2d.scalarPixelsToWorld(w_/2);
    float box2dH = box2d.scalarPixelsToWorld(h_/2);
    sd.setAsBox(box2dW, box2dH);

    //body = createBody(center);
    BodyDef bd = new BodyDef();
    bd.type = BodyType.DYNAMIC;
    bd.bullet = true;
    bd.position.set(box2d.coordPixelsToWorld(center));
    body = box2d.createBody(bd);
    
    body.createFixture(makeFixture(sd));
  }
  

  

}

