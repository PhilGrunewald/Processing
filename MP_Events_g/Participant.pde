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
    numParticipants=MP_database.getInt(eventID+1,2)+MP_database.getInt(eventID+1,4)+MP_database.getInt(eventID+1,6);
  
    String[] participantOrganisations = split(MP_database.getString(eventID+1,3+(sectorID*2)),",");
   if (ID<participantOrganisations.length) {
    Label=participantOrganisations[ID];  }
   else {Label="no name"; } 
    return Label;
}

  int getSize() {
    int Size=5;
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
   //showLabel();
   for (int i=0; i<participants.size(); i++) {
     Participant p = (Participant)participants.get(i);
     if (p.eventID==eventID){
       if (p.sectorID!=sectorID){
         if (connectionCase<3) {
          if (p.sectorID==connectionCase) {
          stroke(hue,255,255,255);
          strokeWeight(0.1);
          line(cxpos, cypos,p.cxpos,p.cypos);
          p.showLabel();
          }
         } 
         if (connectionCase==3) {
          stroke(hue,255,255,255);
          strokeWeight(0.1);
          line(cxpos, cypos,p.cxpos,p.cypos);
          
          
          } 
       }
     }
   }
 }
}
