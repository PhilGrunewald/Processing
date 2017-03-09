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
