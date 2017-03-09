// a line of previous wind levels moving out to the left

class wind_trail {
  ArrayList<wind_instance> trail;
  PVector location;  
  PVector last_location;  
  
  wind_trail(PVector site_location) {
    location = site_location.get();
    trail = new ArrayList<wind_instance>();
  }
  
  void addDot(int wind) {
    location.z = wind;
    trail.add(new wind_instance(location));
    run();
    // PG
//        point(location.x,location.y+location.z);
//        ellipse(location.x,location.y+location.z,5,5);
  }
  
  void display() {
    last_location = new PVector(0,0,0);
    
   Iterator<wind_instance> this_dot = trail.iterator();
    while (this_dot.hasNext()) {
      wind_instance wi = this_dot.next();
      wi.display(); 
      wi.drawLine(last_location);
      last_location = wi.location.get();
    }
  }
  
  void run() {
   Iterator<wind_instance> this_dot = trail.iterator();
    while (this_dot.hasNext()) {
      wind_instance wi = this_dot.next();
      wi.shift_left();
      if (wi.isDead()) {
            this_dot.remove();  
      }
    }
  }
}
