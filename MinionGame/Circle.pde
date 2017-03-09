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
