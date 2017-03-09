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
    Size=0;
    for (int i = 0; i<3; i++) {
      Size=Size+ int(MP_database.getInt(ID,2*(i+1)));
    }
    return int(Size);
}

 int Seperation() {
   int k = MP_database.numRows-1; // number of events
   return k;
 }

 void setColour(int i){  
   hue = (255 / MP_database.numRows - 1) * i;   
   ccolor = color(hue, 200, 200, brightness);
   // labelAlpha=128; 
  //  if (expanded) {ccolor = color(hue, 100, 100, 100);}
 } 

}
