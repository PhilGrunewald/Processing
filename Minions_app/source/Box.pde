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


