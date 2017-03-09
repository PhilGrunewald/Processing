// UKERC Meeting Place event Visualization
// based on bit torrent simulation from:
// created by http://www.aphid.org/btsim/
//
// 26 Sep 2013 Philipp Grünewald
//
// /Users/pg1008/Documents/Software/Processing/MP_Events_g/MP_Events_g.pde
// includes:
// /Users/pg1008/Documents/Software/Processing/MP_Events_g/Participant.pde
// /Users/pg1008/Documents/Software/Processing/MP_Events_g/Event.pde
// /Users/pg1008/Documents/Software/Processing/MP_Events_g/Table.pde
// /Users/pg1008/Documents/Software/Processing/MP_Events_g/Peer.pde
// /Users/pg1008/Documents/Software/Processing/MP_Events_g/Connection.pde

float angle = 0;
ArrayList peers = new ArrayList();
ArrayList participants = new ArrayList();
ArrayList events = new ArrayList();
float rot = 5;
int initialCategories = 3;
int initialPeers = 1;
Table MP_database;

String dummy="test";
void setup()
{
  size(900, 600);
  fill(255);
  fill(0);
  textAlign(CENTER);

  MP_database = new Table("MP_events.txt", "\t");                 //url of the location of the data
  switchToEvents();
}


void clearItems() {
  for (int i = peers.size()-1; i >= 0; i--) {
      peers.remove(i);
    }
}

void switchToEvents() {
 clearItems();
 for (int i = 1; i < MP_database.numRows; i++) {
  Event e = new Event(i);
  peers.add(e);
  events.add(e);
 }
}



void switchToSector() {
  for (int i = 0; i < participants.size(); i++)
  {
    Participant p = (Participant)participants.get(i);  
    p.targetLocation.set(width/2+(p.sectorID-1)*300,height/3);
  }
}


void switchToParticipants() {
 clearItems();
 for (int i = 0; i < 3; i++) {
  Participant p = new Participant(1,1,4);
  peers.add(p);
 }
}

  int getItemID() {
    int ItemID = -1;
    float distance = 1000;
    for (int i = 0; i < peers.size(); i++) {
      Peer p = (Peer)peers.get(i);
        if ((((p.cxpos-mouseX)*(p.cxpos-mouseX))+((p.cypos-mouseY)*(p.cypos-mouseY)))<distance) {
        distance=(((p.cxpos-mouseX)*(p.cxpos-mouseX))+((p.cypos-mouseY)*(p.cypos-mouseY)));
        ItemID =i;
        }
      } 
      return ItemID;
  }
  
  int getItemID(ArrayList l) {
    int ItemID = -1;
    float distance = 1000;
    for (int i = 0; i < l.size(); i++) {
      Peer p = (Peer)l.get(i);
        if ((((p.cxpos-mouseX)*(p.cxpos-mouseX))+((p.cypos-mouseY)*(p.cypos-mouseY)))<distance) {
        distance=(((p.cxpos-mouseX)*(p.cxpos-mouseX))+((p.cypos-mouseY)*(p.cypos-mouseY)));
        ItemID =i;
        }
      } 
      return ItemID;
  }
  
  void addParticipants(Event e) {
    int eventID=e.eventID-1;
    for (int Sector = 0; Sector < 3; Sector++){
      //String participantOrganisations = new String[];
      String[] participantOrganisations = split(MP_database.getString(eventID,3+(Sector*2)),",");
      //dummy=str(eventID);
       for (int i = 0; i < participantOrganisations.length; i++) {
        Participant p = new Participant(i,Sector,eventID);
        Peer q = (Peer)peers.get(eventID);
        p.getLabel();
        p.setOrigin(q.cxpos,q.cypos);
        //p.setOrigin(q.cxpos,peers.get(eventID).cypos);
        //p.originX=peers.get(eventID).cxpos;
        //p.originY=peers.get(eventID).cypos;//-300;

        peers.add(p);      // participants.add(p);
        participants.add(p);
        e.brightness=e.brightness-(250/p.numParticipants);
     }
    }
  }
  
  void removeParticipants(Event e){
    for (int j = 0; j < participants.size(); j++)
     {
      Participant p = (Participant)participants.get(j);
      if (p.eventID==e.eventID-1) {
        p.collapsing=true;
      }
    }
  }
  
  void mousePressed(){
    int ItemID=getItemID(events);
    if (ItemID>-1){
       Event e = (Event)events.get(ItemID);
       if (e.expanded) { // withdraw partcipants
         removeParticipants(e);
       }
       else { // show participants
         addParticipants(e);      
       }
       e.toggleExpand();      
    }

//    ItemID=getItemID(participants);
//    if (ItemID>-1){
//       Participant p = (Participant)participants.get(ItemID);
//       if (p.showConnections) 
//          {p.showConnections=false;} 
//       else 
//          {p.showConnections=true;}  
//       p.trackMouse=true;   
//    }
  }
  
  void mouseReleased() {
    int ItemID=getItemID(participants);
    if (ItemID>-1){
       Participant p = (Participant)participants.get(ItemID);
       p.trackMouse=false;   
    }  
  
  }
  
  void mouseMoved(){
    int ItemID=getItemID(events);
    
    if (ItemID>-1) {
      Event e = (Event)events.get(ItemID);
      e.showLabel();
      dummy=str(ItemID);
    }
    
    int pID=getItemID(participants);
    if (pID>-1) {
      Participant p = (Participant)participants.get(pID);
      p.showLabel();
      dummy=str(ItemID);
      }

  }

void removePeer()
{
  int i = int(random(0, peers.size() - 1));
  ((Peer)peers.get(i)).removing = 1;
}

void keyPressed()
{
  if (key == 's') { 
    switchToSector();
  }
  if (key == 'e') { 
    switchToEvents();
  }
  if (key == 'p') { 
    switchToParticipants();
  }
  if (key == '-') { 
    removePeer();
  }
}

void draw()
{
  background(50);
  text(dummy, 150, 160);

  if (rot >= 0)
  {
    if (rot < 360)
    {
      rot += .05;
    }
    else
    {
      rot = rot - 360;
    }
  }

  for (int i = 0; i < participants.size(); i++)
  {
    Participant p = (Participant)participants.get(i);
    
    for (int j = 0; j < participants.size(); j++)
    { 
      Participant q = (Participant)participants.get(j);  
      if (i!=j) {
      p.updateRepell(q);
      }
    }
    
//    
    if (p.trackMouse) {p.targetLocation.set(mouseX,mouseY);}

    if (p.showConnections) {p.drawConnections();}
    p.updateAttraction();
  }


  for (int i = 0; i < participants.size(); i++)
  {
    Participant p = (Participant)participants.get(i);
    p.moveSelf();
    p.drawSelf();
    p.reConfigure(i);
    if ((p.collapsing)&&(p.nearHome))
    {
      Event e = (Event)events.get(p.eventID);
      e.brightness=e.brightness+(250/p.numParticipants);
      participants.remove(i);
      p=null;
    }
  }
    for (int i = 0; i < participants.size(); i++)
  {
    Participant p = (Participant)participants.get(i);
    p.drawLabel();
  }
  
  
  for (int i = 0; i < events.size(); i++)
  {
    Event e = (Event)events.get(i);
    e.moveSelf();
    e.drawSelf();
    e.drawLabel();
    e.reConfigure(i);
    //ellipse(i*100, 100, 20, 50);
  }
}

//class Connection
//{
//  int lastdraw;
//  Peer from;
//  Peer to;
//  boolean stream;
//  ArrayList kibbles = new ArrayList();
//  int deadkibbles;
//  int speed;
//  Bit theBit;
//
//  Connection(Peer f, Peer t, Bit b)
//  {
//    theBit = (Bit)b;
//    from = f;
//    to = t;
//    stream = true;
//    lastdraw = millis();
//    deadkibbles = 0;
//    speed = int(random(30,500));
//  }
//
//  int getIdxTo()
//  {
//    return to.index;
//  }
//
//  int getIdxFrom()
//  {
//    return from.index;
//  }
//
//
//  void manageKibbles()
//  {
//    if ( from.removing >= 1 || to.removing >= 1 || deadkibbles > 125 )
//    { 
//      stream = false;  
//    }
//    else
//    {
//      if (lastdraw < millis() - speed)
//      {   
//        newKibble();
//      }
//    }
//    drawKibbles();
//  }
//
//
//  void newKibble()
//  {
//    Kibble k = new Kibble();
//    k.starttime = millis();
//    k.endtime = k.starttime + 5000;
//    kibbles.add(k);
//    lastdraw = millis();
//  }
//
//  void drawKibbles()
//  {
//    for (int i = 0; i < kibbles.size(); i++)
//    {
//      Kibble k = (Kibble)kibbles.get(i);
//      if(millis() > k.endtime)
//      {
//        kibbles.remove(i);
//        deadkibbles++;
//      }
//      else
//      {
//        float diff = (millis() - k.starttime) / (k.endtime - k.starttime);
//
//        float xpos = from.cxpos * (1 - diff) + (to.cxpos) * diff;
//        float ypos = from.cypos * (1 - diff) + (to.cypos) * diff;
//
//        colorMode(HSB);
//        fill(theBit.bitHue, 255, 255);
//        stroke(theBit.bitHue, 255, 255);
//        strokeWeight(k.big);
//        ellipse(xpos, ypos, k.big, k.big);
//      }
//    }
//
//  }
//
//}


class Event extends Peer {
int brightness=255;

  Event(int ID){
  super(ID);
  eventID=ID;
  }

String getLabel() {
    Label=MP_database.getString(ID,0);
    return Label;
}

  int getSize() {
    int intSize=0;
    for (int i = 0; i<3; i++) {
      intSize=intSize+ MP_database.getInt(ID,2*(i+1));
    }
    intSize=int(intSize*(cypos/height));
    Size=intSize;
    return 50;//Size;
}

 int Seperation() {
   int k = MP_database.numRows-1; // number of events
   return k;
 }

 void setColour(int i){  
   hue = (255 / MP_database.numRows - 1) * i;   
   ccolor = color(hue, 200, 200, brightness);
     
  //  if (expanded) {ccolor = color(hue, 100, 100, 100);}
 } 

}
class Participant extends Peer {
int numParticipants;
boolean showConnections=false;
boolean trackMouse=false;



  Participant(int ID, int sectorID_, int eventID_){
  super(ID);
  sectorID=sectorID_;
  eventID=eventID_;
  expanded=true;
  }

String getLabel() {
    //Label=MP_database.getString(0, 2*(ID+1));  
    numParticipants=MP_database.getInt(eventID+1,2)+MP_database.getInt(eventID+1,4)+MP_database.getInt(eventID+1,6);
  
//    participantOrganisations = new String[];
    ////String[] participantOrganisations = split(MP_database.getString(eventID+1,3+(sectorID*2)),",");
    String[] participantOrganisations = split(MP_database.getString(eventID+1,3+((sectorID-1)*2)),",");
    
    //Label=participantOrganisations[ID];  
    Label="testing12";  
   //Label=str(eventID); 
    return Label;
}

  int getSize() {
    int Size=15;
    return Size;
}

 void setColour(int i){
     //ehue = (255 / peers.size() - 1) * i;
      hue = (255 / 3 - 1) * sectorID;
      ccolor = color(hue, 255, 155+labelAlpha, 133+labelAlpha);
 } 
 
 int Seperation() {
      int k=numParticipants;
   return k;
 }
 
 void drawConnections() {
   showLabel();
   for (int i=0; i<participants.size(); i++) {
     Participant p = (Participant)participants.get(i);
     if (p.eventID==eventID){
       //if (participants.get(i).sectorID!=sectorID){
               
       stroke(hue,255,255,255);
       strokeWeight(0.1);
       line(cxpos, cypos,p.cxpos,p.cypos);
       p.showLabel();
       //}
     }
   }
 }
}
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
  
  float attract_factor=1;
  
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
   attract_factor=(d_attract*d_attract)/10;
   
   if (collapsing) {
     attract_factor=30000;
     if (d_attract<10){nearHome=true;}
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
   if (d_repell<180) {
     repell_factor=180/(d_repell+1);
   }
   
   F_repell.mult(repell_factor);
   accelaration.add(F_repell);// ** a=F/mass 

}

  void reConfigure(int i)
  {
    velocity.add(accelaration);
    velocity.mult(0.6);
    if (cxpos>width) {velocity.x=-velocity.x;}
    if (cxpos<0) {velocity.x=-velocity.x;}
    if (cypos>width) {velocity.y=-velocity.y;}
    if (cypos<0) {velocity.y=-velocity.y;}
    
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
    expos = screenX(0, 2000/Seperation());
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
      fill(255,labelAlpha); 
      text(Label,cxpos, cypos);
      labelAlpha=labelAlpha*0.96;
      fill(ccolor);
  }
}
class Sector extends Peer {
  
  Sector(int ID){
  super(ID);
  }

String getLabel() {
    Label=MP_database.getString(0, 2*(ID+1));
    return Label;
}

}
  ////////////////////////////////////////
 // class to read delimited text file  //
////////////////////////////////////////

  class Table {
    String[][] data;           //data of the table

    int numRows,numColumns;    //number of rows and columns

    //CONSTRUCTOR
    Table(String source, String delimeter) {   
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
      //numColumns=data[0].length;
    }

    void saveTableData() {
      String[] myData = new String[numRows];
      for (int i=0;i<numRows;i++){
        String[] thisRow = new String[getNumColumns(i)];
        for (int j=0;j<thisRow.length;j++){
            thisRow[j]=data[i][j];
           }
           myData[i] =join(thisRow," ");
      }

       saveStrings("../connections.txt",myData);
  //graph=new PosterRing("../SSNames.txt","../connections.txt",orX,orY,R,w,curv_fact,sep);
    }

    void revertToData() {
    
 // graph=new PosterRing("../SSNames.txt","../connections.txt",orX,orY,R,w,curv_fact,sep);
    }

    //METHODS
    //Get number of rows
    int getNumRows() {
      return numRows;
    }

    void addConnection(int row, int connectee) {
      String[] newRow = new String[getNumColumns(row)+1];
      for (int j=0;j<getNumColumns(row);j++){
         newRow[j]=data[row][j];
      }
      newRow[getNumColumns(row)]=str(connectee);
      data[row]= newRow;
    }
    
    //Get number of columns in this row PG 31 May 2013
    int getNumColumns(int row) {
      numColumns=data[row].length;
      return numColumns; 
    } 

    //Get value as a string 
    String getString(int iRow, int iCol) { //<>//
      return data[iRow][iCol];
    }

    int getInt(int iRow, int iCol) {
      return parseInt(data[iRow][iCol]);
    }

    // get total number of connections
    int totalConnections(){
      int Connections=0;
      for (int i=0;i<numRows;i++){
      //     Connections+=t.getNumColumns(i);
        }
      return Connections;
    }
    
    //returns maximum value in a column
    int getMaxCol(int j){
      int vmax=0;
      for(int i=0;i<getNumRows();i++){
        int cval=getInt(i,j);
        vmax=vmax<cval?cval:vmax;
      } 
      return vmax;
    }
    
    int getSumCol(int j){
      int sumCol=0;
      // start at row 1 (row 0 is the header)
      for(int i=1;i<numRows;i++){
        sumCol=sumCol+getInt(i,j);
      } 
      return sumCol;
    }
    
  } //end | tabla class

