// a wind location

class wind_site {
  PVector location;
  int w;
  int lifespan;
  
  
  wind_site(PVector site_location) {
    location = site_location.get();
  }
  

  void update(int wind) {
    if (wind>0) {
      w=wind;
      }
  }

  // Method to display
  void display() {   
    fill(200, 200, 200);
    ellipse(location.x, location.y, w/3, w/3);
    stroke(128,20,20);
    strokeWeight(30);
    strokeCap(ROUND);
    line(location.x, location.y, 0, location.x, location.y, w/3);
    strokeWeight(1);
  }
}

