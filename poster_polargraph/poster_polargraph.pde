/* OpenProcessing Tweak of *@*http://www.openprocessing.org/sketch/34748*@* 
 *
 *
 * adapted by Philipp Grunewald
 *
 * */



PosterRing graph;  //Main object
int w=12,           //Width of the elements           
R=180,             //radius of the graph
orX,               
orY,               
curv_fact=2,       //curve tightness of the connections
cR=360;            //colormode range
float sep=100e-4,   //sector separation
cR25=cR*.25,       //generic value one for alpha
cR75=cR*.75,       //generic value two for alpha
fSw=2.0f;          //connections strokeWeight scaling factor 
color bg=#111111;  //background color

void commonSettings (PGraphics pg){  //basic settings
  pg.colorMode(HSB,cR);
  pg.ellipseMode(RADIUS);
  pg.strokeCap(SQUARE);
  pg.imageMode(CENTER);
  pg.noFill();
  pg.smooth();
}

void setup(){
  size(900,900);
  commonSettings(g);
  orX=width/2; orY=height/2;  //Center of the graph
  graph=new PosterRing("../SSNames.txt","../connections.txt",orX,orY,R,w,curv_fact,sep);
}

void draw(){
  background(bg);         
  graph.displayBase();                              //shows the polar display of elements
  graph.creaConnect();                              //check selected connections and show them
  if (graph.hover(dist(mouseX,mouseY,orX,orY))){    //show hovered connections
    cursor(HAND);
    graph.creaConnect(atan2((mouseY-orY),(mouseX-orX)));
  }else{
    cursor(CROSS);
  }
  //text(graph.P.length,400,400); 
}

void keyPressed() {
  if (key=='s') {
    graph.t.saveTableData();
  }
  if (key=='r') {
    graph.t.revertToData();}
}


void mousePressed(){
  if (mouseButton==LEFT){
    if (graph.hover(dist(mouseX,mouseY,orX,orY))) {   //check if mouse is inside an element
      graph.click(atan2((mouseY-orY),(mouseX-orX)));  //if so, toggle its display
    }else{
      graph.all(false); //if you click outside erase everything
    }
  }else{
    graph.all(true);    //right-click shows everything
  }
}

  ////////////////////////
 // Poster Ring Class  //
////////////////////////

class PosterRing {
  Table t;                    //This is the object for storing the external data
  Table names;
  PolarElement[] P;           //Array of elements to be connected
  PGraphics b;                //PGraphics for storing these last. This way we calculate once, and we save resources
  int num,R,R1,w,numConnections=0,posX,posY,f,rh1,rh2,nG;  //see below 
  float offs;                 //idem
  int[] groupN,groupC;        //idem
  int connectionOrigin=0;           // the last clicked one is stored here. If the last clicked one is still "on", then a link with the next one is created

  //CONSTRUCTOR
  PosterRing(String namesFile, String dataFile, int posX,int posY,int R,int w,int f,float offs){
    t=new Table(dataFile," ");                 //url of the location of the data
    names= new Table(namesFile,"\t");
    this.posX=posX;
    this.posY=posY;
    this.R=R;                          //radius
    this.w=w;                          //width of the elements
    this.f=f;                          //bezier tightness
    this.offs=offs;                    //separation between elements
    num=t.getNumRows()-1;             //number of elements
    numConnections=t.totalConnections()+(67*4);    //total number of connections (with this number we'll scale the lenght of the elements)
    R1=R+(w*2);                        //text radius
    rh1=R-(w/2); rh2=R+120;          //min and max to check the hover
    nG=names.getMaxCol(0);             //higher value of group (thus, number of groups-1)
    groupN=new int[nG+1];              //number of elements in each group         
    for(int i=0;i<groupN.length;i++){  
      groupN[i]=0;                     // 
    }
    for(int i=0;i<num;i++){          //iterate over the group column, each time you find a value add one to its counter 
      groupN[names.getInt(i,0)]++;      // column "0" is group numbers
    } 
    groupC=new int[nG+1];              
    arrayCopy(groupN,groupC);          //lets keep intact that info and create a mirror to use it as a counter afterwards (see createBase method)
    P=new PolarElement[num+1];           //instantiate group of elements
    for (int i=0;i<P.length;i++){      //calculate the start angle of the element
      P[i]=new PolarElement(i,num+1);    
      if (i>0){
        int a=0;
        while (a<i){                      
          P[i].addAng(P[a++].getAmp());  //iterate over the elements adding the amplitude of the arcs till we reach current element
        }
      }
      P[i].setCoordinates();  //calculate coordinates of the centre of the element and the correspondent control point for the bezier
    } //
    createBase(); //just draw the base
  }  
 
  void createBase(){
    b=createGraphics(width,height,JAVA2D);
    b.beginDraw();
    commonSettings(b);
    b.strokeWeight(w);
    for (int i=0;i<P.length;i++){                  //hue depending on group 
      int eHue=getElement(i).getGroup();           //group value
      --groupC[eHue];                              //subtract one from counter
      //this may seem tricky or complex,but it's easy:
      //divide the spectre of hue by number of groups,divide the 75% of spectre of brightness by number of group elements and it the other 25% 
      color strokeColor=color(cR/(nG+1)*eHue,cR75,(cR75/groupN[eHue]*groupC[eHue])+cR25);  
      b.stroke(strokeColor,cR75);
      float n=i<P.length-1?getElement(i+1).getAng():2*PI;  //jumping over an exception
      b.arc(b.width/2,b.height/2,R,R,getElement(i).getAng()+offs,n-offs);  //drawing arcs 
    }
    b.translate(b.width/2,b.height/2);
    b.fill(cR25);
    for (int i=0;i<P.length;i++){   //draw the names
      b.rotate(P[i].getAmp()*.5);
      b.text(P[i].getElemName(),R1,0);
      b.rotate(P[i].getAmp()*.5);
    }  
    b.endDraw();
  }
  
  int getElement(float mouseAngle){  //This method is the responsible of detecting the element hovered
    float teta=(mouseAngle>0)?mouseAngle:map(mouseAngle,-PI,0,PI,2*PI);  //Atan2 can be hateful, I do this trick to handle the angles in a more intuitive way
    int element=0; 
    while (element<P.length){    
      if (P[element].getAng()>teta){
        break;
      } 
      element++;
    } 
    return element-1;  
  }
  
  void creaConnect(float beta){                        //display hovered connections  
    int i=getElement(beta); 
    text(P[i].getElemName(),50,35);                        //take name
    text(P[i].getElemInfo(),50,55);                         //take info 
    int eHue=getElement(i).getGroup();           //this the group value
    color strokeColor=color(cR/(nG+1)*eHue,cR75,(cR75/groupN[eHue]*groupC[eHue])+cR25);  
    pushMatrix();
    translate (posX,posY); 
    rotate(atan2((P[i].getYc()-posY),(P[i].getXc()-posX)));
    fill(#eeeeee,cR75);                                //overwrite the text of the base, I dont like this much but I was lazy to change it
    text(P[i].getElemName(),R1,0);
    popMatrix(); 
    doConnections(i,strokeColor);                 //draw connections
  }
  
  void creaConnect () {                 //display selected connections
    for (int i=0; i<P.length; i++){
      if (P[i].getOn()){   
        int eHue=getElement(i).getGroup();           //this the group value
        ++groupC[eHue];                              // make it a bit brighter
        color strokeColor=color(cR/(nG+1)*eHue,cR75,(cR75/groupN[eHue]*groupC[eHue])+cR25);  
        doConnections(i,strokeColor);       //do the job
      }
    }
  }
   
  void doConnections(int e,color connection_color){    //element to connect and colour of connections
    noFill(); 
    stroke(bg);
    strokeWeight(1);
    ellipse(P[e].getXc(),P[e].getYc(),w*.5,w*.5);            //this little ellipse clarifies elements selected
    stroke(connection_color);
    for (int j=0; j<num+1;j++){
      if(P[e].getRel(j)>0){ 
      strokeWeight(P[e].getRel(j)/fSw);                //do thicker lines as connection goes stronger
      noFill();
      bezier(P[e].getXc(),P[e].getYc(),P[e].getCx1(),P[e].getCy1(),P[j].getCx1(),P[j].getCy1(),P[j].getXc(),P[j].getYc());  //make connections 
      }   
    }
  } 
   
  void click(float beta){   //Select elements clicked
  //  if ((P[connectionOrigin].on)&&(connectionOrigin!=getElement(beta))) { // uncomment to allow creating links visually...
  //      t.addConnection(connectionOrigin,getElement(beta)+1);
  //      P[connectionOrigin].makeFriends();
  //      //P[connectionOrigin].toggleOn();
  //      } else {
         P[getElement(beta)].toggleOn();
         connectionOrigin=getElement(beta);
  //      }
    
  }
  
  void all (boolean onOff){            //Clean all selected connections
    for (int i=0;i<P.length;i++){
      P[i].setOn(onOff);
    }
  }
  
  boolean hover (float d){  //Is the mouse inside an element (anyone)?
    return (d>=rh1 && d<=rh2)?true:false;
  }
  
  void displayBase(){  //show the base
    image(b,posX,posY); 
  }
   
  PolarElement getElement(int n_ord){  //a method for getting the elements inside the graph
    return P[n_ord];
  }
   
  
  //////////////////////////
 // Polar Element Class  //
//////////////////////////

  class PolarElement{
    int[] rels;          //relationship values array
    int ord,nElem,group; //position, number of elements linked to this and group of the element
    float amp,ang,       //element amplitude, beginning angle                     
    xc,yc,cx1,cy1;       //extreme point and control point of a bezier going to this element
    String name,info;     //information about the element
    boolean on=false;    //boolean to check whether an element is selected or not
   // ArrayList<int> relations; 

    //CONSTRUCTOR
    PolarElement(int ord,int nElem){
      this.ord=ord; this.nElem=nElem;               
      rels= new int[nElem];                  
      int Connections=5;                            //total strength of relationships
      for (int j=0; j<t.getNumColumns(ord); j++){
        rels[t.getInt(ord,j)-1]+=1;  //PG 29May every time an ID appears in this row the link strengthens (normally we'd expect only one mention of each ID)
        Connections+=2;
      }
    
      amp  =(PI*Connections/numConnections);            //make amplitude proportional to total weight of relationships
      group=names.getInt(ord,0);          
      name =names.getString(ord,1)  + " (" + str(t.getNumColumns(ord)) +")";
      info =names.getString(ord,2);   
    } 
    
    //GET methods
    float   getAmp(){return amp;}  
    float   getAng(){return ang;}     
    int   getGroup(){return group;}
    String  getElemName(){return name;}
    String  getElemInfo(){return info;}    
    float    getXc(){return xc;}
    float    getYc(){return yc;}
    float   getCx1(){return cx1;}
    float   getCy1(){return cy1;}
    boolean  getOn(){return on;}
    int     getRel(int position){return rels[position];}    
    
    //SET methods
    void addAng(float numberToAdd){
     ang+=numberToAdd; 
    }
    void setCoordinates(){
     xc = posX + (R-w/2) * cos (ang+(amp/2));
     yc = posY + (R-w/2) * sin (ang+(amp/2));
     cx1= posX + (R/f)   * cos (ang+(amp/2));
     cy1= posY + (R/f)   * sin (ang+(amp/2));
    }
    void toggleOn(){
      on=!on;
    }
    void setOn(boolean toSet){
      on=toSet; 
    } 

    void makeFriends() {
       for (int j=0; j<t.getNumColumns(ord); j++){
        rels[t.getInt(ord,j)-1]+=1;  //PG 29May every time an ID appears in this row the link strengthens (normally we'd expect only one mention of each ID) //<>//
      }
    }

  } //  

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
  graph=new PosterRing("../SSNames.txt","../connections.txt",orX,orY,R,w,curv_fact,sep);
    }

    void revertToData() {
    
  graph=new PosterRing("../SSNames.txt","../connections.txt",orX,orY,R,w,curv_fact,sep);
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
           Connections+=t.getNumColumns(i);
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
    

    
  } //end | tabla class
}//end | PosterRing class
