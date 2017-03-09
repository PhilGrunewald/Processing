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
