import java.util.Iterator;

String dataPath = "./data/";

int tuc_max = 30;
int tuc_min =  1;
int maxY = 8;
int conditionValue = 2;

int selected_tuc = tuc_min;

String[] tucName = new String[100];
String[] demoHeader;
int[][] demo;
int[][] pact;
int[][] pact_hist;
int[][] lact;
boolean stack_off = true;

String[] readHeader(String FileName){
// polymorphing for when no delimiter specified
 return readHeader(FileName, ",");
}

String[] readHeader(String FileName, String deliminator){
 String[] allLines = loadStrings(FileName); 
 return split(allLines[0], deliminator); 
}

int[][] readFile(String FileName){
// polymorphing for when no delimiter specified
 return readFile(FileName, ",");
}

int[][] readFile(String FileName, String deliminator){
// function to return all fields in a text file as an integer array
 String[] allLines = loadStrings(FileName); 
 String[] headerLine = split(allLines[0], deliminator); 
 int[][] valueArray = new int[allLines.length][headerLine.length];    // space = rows * cols
 for(int row = 1; row < allLines.length; row++){           // cycle through lines, skip headers in row=0
  String[] colItems = split(allLines[row], deliminator); 
  for(int col = 0; col < colItems.length; col++){          // cycle though columns
   valueArray[row][col] = int(colItems[col]);
  }
 }
 return valueArray;
}

String[] read_tuc(String tucFile){
// read time use codes into 100 long array
 String[] tucList = loadStrings(tucFile); 
 for(int row = 1; row < tucList.length; row++){           // fewer than 99 (list with gaps), skip row 0 - that is "-1 = missing"
  String[] colItems = split(tucList[row], '\t'); 
  tucName[int(colItems[0])]=colItems[1];
 }
 return tucName;
}

int[][] histogram(int data[][]){
// count instances of tuc's for each time interval
int[][] temp = new int[data[0].length][100];
 for (int time = 0; time < data[0].length; time++){       // 144 time columns
  for (int row = 0; row  < data.length; row++) {          // 4942 participant rows
    if (int(data[row][time]) != -1) {
     temp[time][int(data[row][time])]+=1;
   }
  }
 }
 return temp;
}

int getColumn(String header[], String pattern) {
// find the column number that matches the pattern in the header row
 int conditionCol = -1;
 for (int col = 0; col < header.length; col++){
   if (header[col].equals(pattern)) {
     conditionCol = col;
   }
 }
 return conditionCol;
}

int[][] histogram(int data[][],int conditionCol, int conditionValue){
// count instances of tuc's for each time interval
// provided the condition in the demographic data is met

 int[][] temp = new int[data[0].length][100];

 for (int time = 0; time < data[0].length; time++){       // 144 time columns
  for (int row = 0; row  < data.length; row++) {          // 4942 participant rows
    if (int(data[row][time]) != -1) {
      if (demo[row][conditionCol] == conditionValue){
       temp[time][int(data[row][time])]+=1;
      }
   }
  }
 }
 return temp;
}


void setup() {
 size( 900, 600);
 smooth();
 demoHeader = readHeader(dataPath + "TUS2005_a.csv");         // demographic variables 1-72
 demo       = readFile(  dataPath + "TUS2005_a.csv");         // demographic variables 1-72
 pact = readFile(dataPath + "TUS2005_pact.csv");      // primary activity
 lact = readFile(dataPath + "TUS2005_lact.csv");      // location of activity
 tucName = read_tuc(dataPath + "tuc.txt");           // time use codes
 ///// pact_hist   = histogram(pact);                         // histogram of primary activities
 // get the column number by searching for the condition name in the header string
 int conditionCol = getColumn(demoHeader,"HHTypb");
 pact_hist = histogram(pact, conditionCol, conditionValue);                         // histogram of primary activities
}

void keyPressed() {
  if (key == 's') {
    if(stack_off){
      stack_off =false;
    }else{
      stack_off = true;
    }
  }
  if ((keyCode == LEFT) || (key == 'h')) {
    maxY = 0;
    conditionValue -= 1;
 int conditionCol = getColumn(demoHeader,"HHTypb");
    pact_hist = histogram(pact, conditionCol, conditionValue);                         // histogram of primary activities
  }
  if ((keyCode == RIGHT) || (key == ';')) {
    maxY = 0;
    conditionValue += 1;
 int conditionCol = getColumn(demoHeader,"HHTypb");
    pact_hist = histogram(pact, conditionCol, conditionValue);                         // histogram of primary activities
  }
  if ((keyCode == DOWN) || (key == 'j')) {
    selected_tuc += 1;
    if (selected_tuc > tuc_max) {
      selected_tuc = tuc_min;
    }
    // print(tucName[selected_tuc]);
    while (tucName[selected_tuc] == null) {
        selected_tuc += 1;
        if (selected_tuc > tuc_max) {
          selected_tuc = tuc_min;
        }
    }
  }
  if ((keyCode == UP) || (key == 'k')) {
    selected_tuc -= 1;
    if (selected_tuc < tuc_min) {
      selected_tuc = tuc_max;
    }
    while (tucName[selected_tuc] == null) {
        selected_tuc -= 1;
        if (selected_tuc < tuc_min) {
          selected_tuc = tuc_max;
        }
    }
  }
}

void drawTUCs() {
 int i_tuc = tuc_min;
 for(int tuc = tuc_min; tuc < tuc_max; tuc++) {
  if (tucName[tuc] != null)  {
   if (tuc == selected_tuc) {
    fill(255,0,0);
   } else {
    fill(80,80,80);
   }
   text(tucName[tuc],20,20+13*i_tuc);
   i_tuc++;
  }
 }
}

void drawGraph() {
 int[] stack = new int[144];
 for(int tuc = tuc_min-1; tuc < tuc_max; tuc++){           // runs to 30 - 41-98 is travel
 float x0 = 0.2*width;
 float y0 = 0.8*height;
  for(int time = 0; time < 144; time++){       // runs to 144
   float px = map(time,0,144,0.2*width,0.8*width);
   float py_floor = map(float(stack[time]),0,maxY,0.8*height,0.2*height);
   stack[time] += pact_hist[time][tuc];
   float py = map(float(stack[time]),0,maxY,0.8*height,0.2*height);
   if (tuc == selected_tuc) {
    stroke(255,0,0);
    line(px,py_floor,px,py);
   } else {
    stroke(80,80,80);
   }
   line(x0,y0,px,py);
   //point(px,py);
   x0 = px;
   y0 = py;
   // find the largest value to scale Y
   if (int(stack[ time ]) > maxY) {
     maxY = int(stack[ time ]);
   }
   if (stack_off) {
     stack[time] =0;
   }
  }
 }
}

void draw()
{
 background(180);
 drawGraph();
 drawTUCs();
 }
