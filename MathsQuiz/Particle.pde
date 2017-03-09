// A simple Particle class

class Particle {
  PVector location;
  PVector velocity;
  PVector acceleration;
  float lifespan;
  float joy;
  color farbe;
  PShape box;

  Particle(PVector l, float joy_) {
    joy = joy_;
    acceleration = new PVector(0,0.05);
    velocity = new PVector(random(-1,1),random(-joy/5,0));
    location = l.get();
    lifespan = 255.0;
    farbe = color(128+random(-10*joy,10*joy),128+random(-10*joy,10*joy),128+random(-10*joy,10*joy));
  }

  void run() {
    update();
    display();
  }

  // Method to update location
  void update() {
    velocity.add(acceleration);
    location.add(velocity);
    lifespan -= 1.0;
    if (location.y > height/1.5)   {
      acceleration.y = -0.15;
      velocity.x = -0.04*(location.x-width/1.2);
      } else {acceleration.y = 0.05;}
  }

  // Method to display
  void display() {
    //stroke(255,lifespan);
    fill(farbe ,lifespan);
    ellipse(location.x,location.y,8,8);
  }
  
  // Is the particle still useful?
  boolean isDead() {
    if (lifespan < 0.0) {
      return true;
    } else {
      return false;
    }
  }
}

