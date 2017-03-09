/**
 * LoadFile 1
 * 
 * Loads a text file that contains two numbers separated by a tab ('\t').
 * A new pair of numbers is loaded each frame and used to draw a point on the screen.
 */
HScrollbar hs_date;  // Two scrollbars

wind_site ws1135, ws583, ws708, ws1395; 
wind_trail wt1135, wt583, wt708, wt1395;

import java.util.Iterator;

PImage fig_GB;
String[] lines;
String[] demand_data;
float[] load;

int index = 0;
int screen_width = 1300;

void setup() {
  size(1300, 600, P3D);
  background(255);
  stroke(0);
  frameRate(20);

  hs_date = new HScrollbar(width/4, height-16, width/2, 16, 16);

  lines       = loadStrings("winddd.txt");
  demand_data = loadStrings("2010_12_20_42HH_load.csv");
  

  
  fig_GB = loadImage("fig_GB.png");
  ws583 = new wind_site(new PVector(870,300));
  wt583 = new wind_trail(new PVector(650,300));
  
  ws708 = new wind_site(new PVector(800,200));
  wt708 = new wind_trail(new PVector(650,200));
  
  ws1135 = new wind_site(new PVector(800,450));
  wt1135 = new wind_trail(new PVector(650,450));
  
  ws1395 = new wind_site(new PVector(850,120));
  wt1395 = new wind_trail(new PVector(650,120));
  //ws.run();
}

void draw() {
  
  
  
  
  noStroke();
  image(fig_GB, screen_width/2, 0);
  if (index < lines.length) {
    String[] pieces = split(lines[index], '\t');
    if (pieces.length >= 2) {
      int x = int(pieces[0]) * 1;
      int y = int(pieces[1]) * 10;
  
  float cameraY = height/1.0;
  float fov = width/2.0245;//mouseX/float(width) * PI/2;
  float cameraZ = cameraY / tan(fov / 2.0);

// //  perspective(fov, 1, cameraZ/10.0, cameraZ*10.0);
  
// rotateX(mouseY/float(height) * PI);
//  translate(0, -100, -200);
  
      background(155);
      image(fig_GB, screen_width/2, 0);
      
      if (x == 1135) {
        if (y>0) {
           ws1135.update(y);
           wt1135.addDot(y);
           }
       } else if (x == 583) {
        if (y>0) {
           ws583.update(y);
           wt583.addDot(y);
           }
       } else if (x == 708) {
        if (y>0) {
           ws708.update(y);
           wt708.addDot(y);
           }
       } else if (x == 1395) {
        if (y>0) {
           ws1395.update(y);
           wt1395.addDot(y);
           }
}

      ws583.display();
      wt583.display();
      ws708.display();
      wt708.display();
      ws1135.display();
      wt1135.display();
      ws1395.display();
      wt1395.display();
      
      hs_date.update();
      hs_date.display();

      
     // if (index == 30) {

    }
    // Go to the next line for the next run through draw()
    index = index + 1;
  }
}
