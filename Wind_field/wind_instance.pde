// A simple Particle class

class wind_instance {
  PVector location;
  int trail_length;

  wind_instance(PVector l) {
    location = l.get(); // x,y = pos, z wind level
    trail_length = 60;
  }


  // Method to update location
  void shift_left() {
    location.x -=3;
    trail_length -= 1.0; // when this is 0, end the shifting
    display();
  }

  void display() {
    fill(256-(2*location.z), 2*location.z, 0);
    ellipse(location.x,location.y-(int(location.z/3)),5,5);
  }

  void drawLine(PVector last_location){
      stroke(125);
    line(location.x-3,last_location.y-(int(last_location.z/3)), location.x,location.y-(int(location.z/3)));  
  }
  
  // Is the particle still useful?
  boolean isDead() {
    if (trail_length < 1) {
      return true;
    } else {
      return false;
    }
  }
}
