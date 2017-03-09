
/**
 * Oxford Energy  
 * includes /Users/pg1008/Documents/Software/Processing/OxfordEnergyNetwork/JSTable.pde
 */

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

void setup() {
  if (small) {
    label= shortLabel;
    CanvasSize=220;
  } else {
    label = longLabel;
    CanvasSize=600;
  }
  frameRate(15);
  size(600,600);
  size(CanvasSize,CanvasSize);
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
  if (sector>-1) {
   wedge selected = (wedge)segments.get(sector);
   selected.toggle();
  }
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
  background(12,0,12);
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
    w.drawLabel();
  }

  for (int i=0; i<12; i++){
    wedge w = (wedge)segments.get(i);
    if (w.On) {
       relatedThemes = Researchers.getThemeMatch(i);
       w.drawLinks(relatedThemes);
    }
  }
}
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////

class wedge {
  String title;
  String subtitle;
  float diameter = CanvasSize*0.8;
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
    arc(shift/2, 0, diameter+shift*2, diameter+shift*2, radians(-15-shift/8), radians(15+shift/8));     
    popMatrix();

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
      //text(nf(Researchers.getThemeMatch(i),1),200,20);      
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
}

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
    fill(8,10,10);
    //fill(labelFill,10,10);
    diameter=0.35*CanvasSize+1.7*shift;
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

  ////////////////////////////////////////
 // class to read delimited text file  //
////////////////////////////////////////

  class JSTable {
    String[][] data;           //data of the table

    int numRows,numColumns;    //number of rows and columns

    //CONSTRUCTOR
    JSTable(String source, String delimeter) {   
      String[] myFile = loadStrings(source); 
      numRows=myFile.length;
      data = new String[numRows][];
      for (int i = 0; i < myFile.length; i++) {
        //jump over empty rows
        if (trim(myFile[i]).length() == 0) {
          continue;
        }   
        data[i] = split(myFile[i],delimeter);
      }
    } 
    //METHODS
    //Get number of rows
    int getNumRows() {
      return numRows;
    }
    
    int getInt(int iRow, int iCol) {
      return parseInt(data[iRow][iCol]);
    }
    
    int getThemeSize(int theme) {
      int sumTheme =0;
      for(int i=1;i<numRows;i++){
        sumTheme=sumTheme+getInt(i,theme); // theme 0 (economics) is first col
      } 
      return sumTheme;
    }
    
    int[] getParticipantThemes(int participant) {
      int[] participantThemes = new int[12];
      for(int i=0;i<12;i++) {
        participantThemes[i] = parseInt(data[participant][i]);        
      }
      return participantThemes;   
    }
    
    int[] getThemeMatch(int theme) {
      int[] matches = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}; // 11 themes
      for(int p=1;p<numRows;p++){
        if(int(data[p][theme])==1) {
          for(int t=0;t<12;t++) {
          matches[t]=matches[t]+getParticipantThemes(p)[t];
          }
        }
      } 
      return matches;
    }
    
  } //end | tabla class

