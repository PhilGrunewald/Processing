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
int connectionCase=3; // 3 is all, 0 with business, 1 with gov,  2 with acies. 
String dummy="Imper";
void setup()
{
  size(900, 600);
  textAlign(CENTER);

  MP_database = new Table("MP_events3.txt", "\t");                 //url of the location of the data
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



void showSearchMatch() {
  for (int i = 0; i < participants.size(); i++)
  {
    Participant p = (Participant)participants.get(i);
    String[] matchTest = match(p.Label,dummy);
    if (matchTest != null) {
      p.showLabel();
      p.showConnections=true;
    }
  }
}

void sortByRandom() {
  for (int i = 0; i < participants.size(); i++)
  {
    Participant p = (Participant)participants.get(i);  
    p.targetLocation.set(0.2*width + width*random(0.6),0.2*height + height*random(0.4));
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
      String[] participantOrganisations = split(MP_database.getString(eventID+1,3+(Sector*2)),",");
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

    ItemID=getItemID(participants);
    if (ItemID>-1){
       Participant p = (Participant)participants.get(ItemID);
       if (p.showConnections) 
          {p.showConnections=false;} 
       else 
          {p.showConnections=true;
          //p.showLabel();
          }  
       //p.trackMouse=true;   
    }
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
    }
    
    int pID=getItemID(participants);
    if (pID>-1) {
      Participant p = (Participant)participants.get(pID);
      p.showLabel();
      }

  }

void autoConnect() {
  for (int i=0; i<participants.size(); i++) {
    Participant p = (Participant)participants.get(i);
       if (p.showConnections) 
          {p.showConnections=false;} 
       else 
          {p.showConnections=true;} 
  }
}

void autoRun() {
  for (int i=0; i<events.size(); i++) {
    Event e = (Event)events.get(i);
       if (e.expanded) { // withdraw partcipants
         //removeParticipants(e);
       }
       else { // show participants
         addParticipants(e);      
       e.toggleExpand();      
       }
  }
}

void resetAll() {
   for (int i=0; i<events.size(); i++) {
    Event e = (Event)events.get(i);
       if (e.expanded) { // withdraw partcipants
         removeParticipants(e);
       e.toggleExpand();      
       }
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
    sortByRandom();
    //switchToEvents();
  }
  if (key == 'p') { 
    switchToParticipants();
  }
  if (key == 'a') { 
    autoRun();
  }
  if (key == 'c') { 
    autoConnect();
  }
  if (key == 'f') {
    showSearchMatch();
  }
  if (key == 'x') {
    resetAll();
  }
  if (key == '0') {
    connectionCase=0; // 0 with business.
  }
  if (key == '1') {
    connectionCase=1; // 1 with gov
  }
  if (key == '2') {
    connectionCase=2;// 2 with acies.
  }
  if (key == '3') {
    connectionCase=3;// 3 is all, 
  }
   
}

void draw()
{
  background(255);
  //text(dummy, 150, 160);

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

