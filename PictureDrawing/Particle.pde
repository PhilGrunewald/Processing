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
    velocity = new PVector(random(-1,1),random(-1,1));
    location = l.get();
    lifespan = 255.0;
    //farbe = color(128+random(-10*joy,10*joy),128+random(-10*joy,10*joy),128+random(-10*joy,10*joy));
  }

  void run() {
    update();
    display();
  }

  // Method to update location
  void update() {
    velocity.add(acceleration);
    location.add(velocity);
    lifespan -= 0.1;
    if (location.y > height)   {
       location.y = height-1; 
       velocity.y = -velocity.y;
      }//else {acceleration.y = 0.05;}
    if (location.y < 0)   {
       location.y = 1; 
       velocity.y = -velocity.y;
      }
    if (location.x > width)   {
      location.x = width-1; 
      velocity.x = -velocity.x;
      }  
    if (location.x < 0)   {
       location.x = 1; 
       velocity.x = -velocity.x;
      }
    farbe = myPicture.get((int)(location.x),(int(location.y)));
  }

  // Method to display
  void display() {
    //stroke(255,lifespan);
      noStroke();
    fill(farbe ,lifespan);
    ellipse(location.x,location.y,20,2);
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

