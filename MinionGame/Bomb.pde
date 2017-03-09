
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


