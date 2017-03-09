class Sector extends Peer {
  
  Sector(int ID){
  super(ID);
  }

String getLabel() {
    Label=MP_database.getString(0, 2*(ID+1));
    return Label;
}

}
