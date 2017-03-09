
/** Oxford Energy Network Graph
 * Oxford Energy  
 * includes /Users/pg1008/Documents/Software/Processing/OxfordEnergyNetwork/JSTable.pde
 */
// globals

 boolean small=false;
 int homeSector = -1; // if set to 0-11, this sector is permanently bright; set to -1 to disable
 String[] label;
 String[] longLabel = {  
                    "Economics\nPolicy\nPolitics",
                    "Marine",  
                    "Fossil\nFuels",  //4
                    "Nuclear",                      //8
                    "Electricity\nNetworks", 
                    "Developing\nCountries", //0
                    "Teaching\n&Training",
                    "Storage", 
                    "Demand &\nEfficiency",        //11
                    "Bioenergy",  
                    "Transport",  
                    "Solar",  

                    "Oxford Energy"};

 String[] shortLabel = {  
                    "Economics","Marine","Fossil","Nuclear","Networks","Developing","Teaching",
                    "Storage","Demand","Bioenergy","Transport","Solar",  
                    "Oxford Energy"};

 String[] sublabel = {
    "and Law &\nRegulation",
    "Wave\nEco. Impact\nTidal",  
    "Technology\nEco. Impact\nMarkets",  //4
    "Fission\nSecurity\nFusion",                      //8
    "Smart Grids\nMarkets", 
    "Energy in\nDeveloping\nCountries", //0
    "DPhil\nMSc\nCourses",
    "Technologies\nStorage Media\nGrid Scale", 
    "Technologies\nEnergy Use\nPolicy",        //11
    "Production\nConversion\nImpact",  
    "Technology\nPolicy\nModelling",  
    "Novel PV\nconcepts\nCSP",  
    "180 senior researchers\naddressing major\ntechnical, social,\n economic and\npolicy issues"   
    };

 JSTable Researchers;
 ArrayList segments = new ArrayList();
 int CanvasSize;
 String[] myFile; 

// functions
 void setup() {
  if (small) {
    label= shortLabel;
    CanvasSize=220;
  } else {
    label = longLabel;
    CanvasSize=900;
  }
  frameRate(15);
  size(900,900);
  // size(CanvasSize,CanvasSize);
  //size(900,900);
  colorMode(HSB, 12);
  textAlign(CENTER);
  textFont(createFont("Poiret One",32));
  //textFont(createFont("Helvetica",32));
  noStroke();
  Researchers = new JSTable("EnergyPeople_theme.csv", ",");                 //url of the location of the data
  //myFile = loadStrings("EnergyPeople_theme.csv");
  for (int i=0; i<12; i++){
  wedge w = new wedge(i,label[i], sublabel[i]);
  segments.add(w);
  }
  centre c = new centre(12,label[12], sublabel[12]);
  segments.add(c);
  }

void XXXmousePressed(){
  int sector = getSector();
  if (sector==0) {link("../research/economics-policy-politics/");}
  if (sector==1) {link("../research/marine/");}
  if (sector==2) {link("../research/fossil-fuels/");}
  if (sector==3) {link("../research/nuclear/");}
  if (sector==4) {link("../research/electricity-networks/") ;}
  
  if (sector==5) {link("../research/energy-in-developing-countries/");}
  if (sector==6) {link("../research/teaching-training/");}
  if (sector==7) {link("../research/storage/");}
  if (sector==8 ) {link("../research/demand-efficiency/");}
  if (sector==9) {link("../research/bioenergy/");}
  if (sector==10) {link("../research/transport/");}
  if (sector==11) {link("../research/solar/");} 
  if (sector==12) {link("../about/");} 
  }

void mousePressed(){
  int sector = getSector();
  //  int line = getConnection();
  if (sector>-1) {
   wedge selected = (wedge)segments.get(sector);
   selected.toggle();
  }// else if (line>-1) {
  
  //}
  }

int getSector() {
  float relX=mouseX-CanvasSize/2;
  float relY=mouseY-CanvasSize/2;
  int sector;
  float r=sqrt(relX*relX+relY*relY);
  if (r<0.5*0.4*CanvasSize) {
    sector=12;
  } else if (r<0.5*CanvasSize*0.8) {
    float angle = +90+15+degrees(atan(relY/relX));
    if (relX<0) {angle = angle+180;}
    if (angle>360) {angle = 0;}
    sector=int(angle/30);
  } else {
    sector=-1;
  }
  return sector;
  }

void draw() {
  cursor(ARROW);
  background(0,0,0);
  fill(0, 102, 153);
  int sector = getSector();
  int[] relatedThemes = new int[12];
  //cursor(HAND);
  for (int i=0; i<13; i++){
    wedge w = (wedge)segments.get(i);
    if (w.On) {
       w.lightUp();
       w.raise();
    } 
    else {
       w.dim();
       w.lower();
    }
    w.move();
    w.draw();
  }
  for (int i=0; i<12; i++){
    wedge w = (wedge)segments.get(i);
    w.drawLabel();
    if (w.On) {
       relatedThemes = Researchers.getThemeMatch(i);
       w.drawLinks(relatedThemes);
       w.drawOuterLinks(relatedThemes);
    }
  }

  
  for (int i=0; i<12; i++){
    wedge w = (wedge)segments.get(i);
    w.drawLabel();
  }
}
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
class link {
 link(wedge wStart, wedge wEnd) {
      PVector SP,EP,EC,SC;
 //     SP = new PVector(cRadius*cos(sAngle), cRadius*sin(sAngle));
 //     EP = new PVector(cRadius*cos(dAngle), cRadius*sin(dAngle));
 //     SC = new PVector(circularReach*cRadius*cos(sAngle-launchAngle),circularReach*cRadius*sin(sAngle-launchAngle));
 //     EC = new PVector(circularReach*cRadius*cos(dAngle+launchAngle),circularReach*cRadius*sin(dAngle+launchAngle));
 }

}
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
class wedge {
 String title;
 String subtitle;
 float diameter = CanvasSize*0.6; // was 0.8
 float labelSize = 0.035*CanvasSize+0.6;
 int labelFill =8;
 int numSlices=12;
 int intensity=12;
 int i;
 boolean On=false;
 float angle;
 float xPos=width/2;
 float yPos=height/2;
 float shift=3;
 float velocity=0;
 float targetPos=shift;
 
 wedge(int i_, String title_, String subtitle_) {  
    title=title_;
    subtitle=subtitle_;
    i=i_;
    angle=radians(-90+i*360/numSlices);
    }

 void raise(){
  targetPos=0.04*CanvasSize;
  labelSize=1.2*0.035*CanvasSize+0.6;
  labelFill=12;
  }

 void lower(){
  targetPos=0.00*CanvasSize;
  labelSize=0.035*CanvasSize+0.6;
  labelFill=12;
  }

 void dim() {
  intensity=6;
  }

 void lightUp() {
  intensity=10;
  }

 void toggle() {
  if (On) {On=false;}
  else {On=true;}
  }

 void move() {
  float k = 0.4;
  float damp = 0.5;
  int mass = 2;
  float force,accel;  
  force = -k * (shift - targetPos);  // f=-ky 
  accel = force / mass;                 // Set the acceleration, f=ma == a=f/m 
  velocity = damp * (velocity + accel);         // Set the velocity 
  shift = shift + velocity;           // Updated position 
  }

 void draw() {
  fill(i,6+shift/3,intensity);
  pushMatrix();   
  translate(xPos,yPos);
  rotate(angle);
  arc(shift/2, 0, diameter+3*2, diameter+3*2, radians(-15-3/8), radians(15+3/8));     
  popMatrix();
  }

 void drawOuterLinks(int[] rThemes) {
  strokeWeight(1);
  noFill();
  pushMatrix();   
  PVector MousePos;
  MousePos = new PVector(mouseX-xPos,mouseY-yPos);
  float m=MousePos.mag();
  float a=MousePos.heading2D();
  MousePos.x= m* cos(a-angle);
  MousePos.y= m* sin(a-angle);
  
  translate(xPos,yPos);
  rotate(angle);
  for(int t=0;t<12;t++) {
    stroke(t,6+shift/3,intensity);
    wedge w = (wedge)segments.get(t);
    if((w.On)&(i>t)){
     float  cRadius =  (diameter+shift*2)/2;
     for(int r=0;r<rThemes[t];r++) {
      // the most is around 40 connections - in that case spread the starting point by the full 10 degrees - the fewer, the tighter
      float sAngle = radians(10-(20*r/rThemes[t]));  // spread end points by 20 degrees
      float dAngle = (w.angle-angle+sAngle)*(shift/36);       
      float circularReach = (i-t); //1+dAngle/2;
      float launchAngle=radians(5*circularReach);
      if(circularReach>6){
        circularReach=-1*(circularReach-12);
        launchAngle=radians(-5*circularReach);
        } 
      circularReach=0.9+ circularReach/3.0;

      //float dMouse =sqrt(sq(modelX(mouseX,mouseY,0)-cRadius*cos(sAngle))+sq(modelY(mouseX,mouseY,0)-cRadius*sin(sAngle)));

      PVector SP,EP,EC,SC;
      SP = new PVector(cRadius*cos(sAngle), cRadius*sin(sAngle));
      EP = new PVector(cRadius*cos(dAngle), cRadius*sin(dAngle));
      SC = new PVector(circularReach*cRadius*cos(sAngle-launchAngle),circularReach*cRadius*sin(sAngle-launchAngle));
      EC = new PVector(circularReach*cRadius*cos(dAngle+launchAngle),circularReach*cRadius*sin(dAngle+launchAngle));
      
      float dMouseS = SP.dist(MousePos);
      float dMouseE = EP.dist(MousePos);

      if(dMouseS<20 || dMouseE<20){strokeWeight(5);}
      bezier(SP.x, SP.y, SC.x, SC.y, EC.x, EC.y, EP.x, EP.y);
      strokeWeight(1);
      }
    }
    //srokeWeight(relatedThemes[t]/2);
    if(rThemes[t]==0) {noStroke();}  // has no connections
    if(t==i) {noStroke();}                 // link to self
    }
  popMatrix();
  noStroke();
  }

 void drawLinks(int[] rThemes) {
  pushMatrix();   
  translate(xPos,yPos);
  rotate(angle);
  for(int t=0;t<12;t++) {
    wedge w = (wedge)segments.get(t);
    stroke(t,6+shift/3,intensity);
    //strokeWeight(relatedThemes[t]/2);
    strokeWeight(1);
    noFill();
    if(rThemes[t]==0) {noStroke();}  // has no connections
    if(t==i) {noStroke();}                 // link to self
    centre c = (centre)segments.get(12);
    float  cRadius = c.getRadius();
    for(int r=0;r<rThemes[t];r++) {
      float iAngle = radians(5-(10*rThemes[i]/40*r/rThemes[t])); 
      // the most is around 40 connections - in that case spread the starting point by the full 10 degrees - the fewer, the tighter
      float sAngle = radians(10-(20*r/rThemes[t]));  // spread end points by 20 degrees
      float dAngle = w.angle-angle+sAngle;       
      bezier(cRadius*cos(-iAngle),cRadius*sin(-iAngle),0.5*cRadius,0,0.5*cRadius*cos(dAngle),0.5*cRadius*sin(dAngle),cRadius*cos(dAngle),cRadius*sin(dAngle));
      }
    }
  popMatrix();
  //fill(12);
  //text(str(shift),200,20);      
  noStroke();
  }

 void drawLabel() {
  textSize(labelSize);
  pushMatrix();   
  translate(xPos,yPos);
  rotate(angle);
  fill(labelFill);
  translate(0.3*CanvasSize+1.5*shift,0);
  rotate(-angle);
  if (small) {
    text(title,0,0);
  } else {
    if ((i==0)||(i==4)||(i==5)||(i==8)) {
    text(title,0,-0.03*CanvasSize);
    } else {
    text(title,0,0);
    }
  }
  popMatrix();
  fill(0);
  //if (shift>0.03*CanvasSize) {text(subtitle,0.3*CanvasSize,20);}
  }
 } // end class wedge

//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////

class centre extends wedge{
 centre(int i_, String title_, String subtitle_) {  
  super(i_,title_, subtitle_);
  float diameter = 0;
  }

 float getRadius() {
  return diameter/2;
  }

 void draw() {
  pushMatrix();   
  translate(xPos,yPos);
  fill(8,10,0);
  //fill(labelFill,10,10);
  //diameter=0.35*CanvasSize+1.7*shift;
  diameter=0.6*CanvasSize;//+1.7*shift;
  ellipse(0,0,diameter,diameter);
  popMatrix();
  }

 void matchColour(int sector) {
	labelFill=sector;
  }

 void drawLabel() {
  pushMatrix();   
  translate(xPos,yPos);
  textSize(1.4*labelSize);
  //fill(labelFill);
  fill(12);
  //text(title,0,-0.045*CanvasSize);
  textSize(0.7*labelSize);
  //text(subtitle,0,-0.01*CanvasSize);
  popMatrix();
  }
 
}

