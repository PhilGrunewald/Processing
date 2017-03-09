// A simple Particle class

class Star extends Particle {
  
  Star(PVector l, float joy_) {
    super (l, joy_);
  }

  // Method to update location
  void update() {
    velocity.add(acceleration);
    velocity.x *= 0.9;
    velocity.y *= 0.9;
    location.add(velocity);
    //lifespan -= 1.0;
    if (location.y > height/1.2)   {
      acceleration.y = -0.5;
      acceleration.x = -0.6;
      } else {acceleration.y = 0.5;}
    if (location.x <10*joy) {
      acceleration.x=0;
      acceleration.y=0;
      velocity.x=0;
      velocity.y=0;
    }
  }

void star(float x, float y, float radius1, float radius2, int npoints) {
  float angle = TWO_PI / npoints;
  float halfAngle = angle/2.0;
  beginShape();
  for (float a = 0; a < TWO_PI; a += angle) {
    float sx = x + cos(a) * radius2;
    float sy = y + sin(a) * radius2;
    vertex(sx, sy);
    sx = x + cos(a+halfAngle) * radius1;
    sy = y + sin(a+halfAngle) * radius1;
    vertex(sx, sy);
  }
  endShape(CLOSE);
}

  // Method to display
  void display() {
    fill(255, 0, 0 , 255);
    star(location.x,location.y,40,20,5);
  }
}
