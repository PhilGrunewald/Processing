class Peer
{
  int sectorID;
  int eventID;
  int index;
  int ID;
  float pwait = random(1,9)*1000;
  float originX = width/2;
  float originY = height/1.2;
  float sxpos; // x of peer
  float sypos; // y of peer
  float expos; // x of where peer should be
  float eypos; // y of where peer should be
  float cxpos;
  float cypos;
  float smovetime;
  float emovetime;
  float percent;
  ArrayList knex = new ArrayList();
  ArrayList actBits = new ArrayList();
  float hue;
  color ccolor;
  int removing;
  int lastcheck;
  ArrayList myBits = new ArrayList();
  ArrayList needBits = new ArrayList();
  
  PVector velocity = new PVector(0,0);
  PVector accelaration = new PVector(0,0);
  
  float attract_factor=0;
  
  PVector targetLocation = new PVector(width/2,height/3);
  
  boolean expanded=false; // toggled when clicked
  boolean collapsing=false;  // set true when item is to be removed
  boolean nearHome=false; // set true to signal that removal can be executed
  boolean dragMode = false;
  
  float Size=0;
  String Label;
  float labelAlpha=128;//=true;

  Peer(int ID_)
  {
    ID=ID_;
    Size = getSize();
    Label=getLabel();
    
    int szv = peers.size();
    if (szv == 0)
    {
      szv++;
    }
    pushMatrix();
    //translate(originX, originY);
    translate(originX, originY);
    ellipseMode(CENTER);
    float angle = 3 ;
    rotate(radians(angle));
    expos = screenX(0, 230);
    eypos = screenY(0, 230);
    setOrigin();

    smovetime = millis();
    emovetime = smovetime + 1250;
    percent = 50;
    colorMode(HSB);

    lastcheck = millis();

    hue = 5;

    popMatrix();
    //setupBits();
  }
  
  void setOrigin(){
    sxpos = width / 2;
    sypos = height / 2;
  }
  
  void setOrigin(float x, float y){
    originX=x;
    originY=y;
    sxpos=x;
    sypos=y;
  }
  
  
  String getLabel() {
    Label=MP_database.getString(0, 2*(ID+1));
    return Label;
  }

  int getSize() {
    Size = MP_database.getSumCol(2*(ID+1));
    return int(Size);
  }



  void toggleExpand(){
    if (expanded) 
      {expanded=false;}
    else 
      {expanded=true;}
  }
  

  void updateAttraction() {
   PVector thisLocation = new PVector(cxpos,cypos);
   PVector F_attract = PVector.sub(targetLocation,thisLocation);   
   

   float d_attract = F_attract.mag();                              // Distance between objects 
   attract_factor=(d_attract*d_attract)/0.1;
   
   if (collapsing) {
     attract_factor=80000;
     if (d_attract<15){nearHome=true;}
   }


   F_attract.normalize();
   F_attract.mult(attract_factor);
   accelaration.add(F_attract);// ** a=F/mass 
   
  }

  void updateRepell(Peer p) {
   PVector thisLocation = new PVector(cxpos,cypos);
   PVector otherLocation = new PVector(p.cxpos,p.cypos);

   PVector F_repell = PVector.sub(thisLocation,otherLocation);   

   float repell_factor=0;
   float d_repell = F_repell.mag();                              // Distance between objects 
   if (d_repell<280) {
     repell_factor=5*280/(d_repell+1);
   }
   
   F_repell.mult(repell_factor);
   accelaration.add(F_repell);// ** a=F/mass 

}

  void reConfigure(int i)
  {
    velocity.add(accelaration);
    velocity.mult(0.4);
//    if (cxpos>width) {velocity.x=-velocity.x;}
//    if (cxpos<0) {velocity.x=-velocity.x;}
//    if (cypos>width) {velocity.y=-velocity.y;}
//    if (cypos<0) {velocity.y=-velocity.y;}
    
    if (collapsing) {
      Event e = (Event)events.get(eventID);
      targetLocation.x=e.cxpos;
      targetLocation.y=e.cypos;
    }
    
   //setOrigin(originX+2,originY+2);
   setOrigin(originX+0.0001*velocity.x,originY+0.0001*velocity.y);
    //int k;
    pushMatrix();
    translate(originX, originY);
    
    ellipseMode(CENTER);    
    float angle = ((360 / Seperation()) * i) + rot;
    rotate(radians(angle));
    sxpos = cxpos;//+velocity.x;
    sypos = cypos;//+velocity.y;
    expos = screenX(0, 4000/Seperation());
    eypos = screenY(0, 500/Seperation());
    
    smovetime= millis();
    emovetime= smovetime + 1000;

    popMatrix();
    //shue = chue;
    setColour(i);
    
    accelaration.mult(0);
    accelaration.mult(0);
  }
  
 int Seperation() {
   int k;
     if (peers.size() == 0)
    {
      k = 1;
    }
    else
    {
      k = peers.size();
    }
   return k;
 }
  
 void setColour(int i){
     hue = (255 / peers.size() - 1) * i;
     ccolor = color(hue, 255, 255, 133);
   // if (expanded) {ccolor = color(hue, 100, 100, 100);}
 } 

  void moveSelf()
  {
    if (millis() > emovetime)
    {
      cxpos = expos;
      cypos = eypos;
    } 
    else
    {
      float diff = (millis() - smovetime) / (emovetime - smovetime);
      cxpos = sxpos * (1 - diff) + expos * diff;
      cypos = sypos * (1 - diff) + eypos * diff;
    }
  }
  
  void showLabel() {
      labelAlpha=128;
  }

  void drawSelf() {
    fill(ccolor);
    noStroke();
    ellipseMode(CENTER);
    ellipse(cxpos, cypos, Size, Size);
  }
  
  void drawLabel() {
      //fill(255,labelAlpha); 
      fill(0,labelAlpha); 
      text(Label,cxpos, cypos);
      labelAlpha=labelAlpha*0.96;
      fill(ccolor);
  }
}
