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


