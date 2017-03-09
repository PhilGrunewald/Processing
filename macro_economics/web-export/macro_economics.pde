float A,B,C,D,AA,BB,CC,DD;
float left,right;
float Q,P;
float dY;
int d = 2;
int timer = 0;
float Xpos,Ypos;
float ext;
  float t=0;
String event;
String note = " ";
String label1 = "MCB";
String label2 = " ";

boolean invisibleHand = false;
boolean trackMouse = true;
boolean move = false;
boolean drawBottom = false;
boolean drawFill = false;
boolean drawProducerCost = false;
boolean drawSocialCost = false;
boolean label1edit = false;
boolean label2edit = false;
boolean drawWelfareloss =false;

float[] vY = new float[5];
float[] pY = new float[4];
float[] p_newY = new float[4];
float buttonY = 0;

color RED = color(208,28,17);
color consumer = color(208,28,17);
color producer = color(255*0.5);
color external = color(255*0.25);
color consumerFill = color(208,28,17,128);
color producerFill = color(128,128,128,128);

//PShape s;

void setup() {
  size(640, 480);
  A= 60;
  AA=A;
  B= 0;
  BB=B;
  C= 0;
  CC=C;
  D= 50;
  DD=D;
  
  ext=10;
  left=0;
  right=90;
    
  vY[0]=0;
  vY[1]=0;
  vY[2]=0;
  vY[3]=0;
  
  
}


void drawLine(float lStart, float lEnd, float pStart, float pEnd, color colour) {
  strokeWeight(0.25);
  stroke(colour);
  
  line(left, lStart, right, lEnd);
  ellipse(left, pStart, d, d);
  ellipse(right, pEnd, d, d);
}


void drawBLine(float lStart, float lEnd, float pStart, float pEnd, color colour) {
  strokeWeight(0.25);
  stroke(colour);
  if (lStart>lEnd) {
  bezier(left, lStart, left, lStart-0.5*(lStart-lEnd), right, lEnd, right, lEnd); //1
  } else {
  bezier(left, lStart, left, lStart, right, lEnd-0.5*(lEnd-lStart), right, lEnd); //2
  
  }
  //line(left, lStart, right, lEnd);
  ellipse(left, pStart, d, d);
  ellipse(right, pEnd, d, d);
}

float intersectBLine(float A, float B, float C, float D) {
int steps = 10;
float t=0; // start left
float stepSize=0.5;
for (int i = 0; i <= steps; i++) {
  float x = bezierPoint(left, left, right, right, t); // t and x points are evenly spaced for both curves
  float y1 = bezierPoint(A, A-0.5*(A-B), B, B, t);
  float y2 = bezierPoint(C, C, D-0.5*(D-C), D, t);

  if (y1>y2) {
  t+=stepSize;
  } else {
  stepSize/=2;
  t-=stepSize;
  }  
  if (i==10){ellipse(x,y1,2,2);}
}
return t;
}

float tMouse(){
  Xpos=(mouseX-100)/4;
  float t=(Xpos-left)/(right-left);
return t;
}

void keyPressed()
{
  if (label1edit) {
    if (keyCode == BACKSPACE) {label1="";}
    else {label1 = label1 + key;}
  }
  else if (label2edit) {
    if (keyCode == BACKSPACE) {label2="";}
    else {label2 = label2 + key;}
  }
  else {
    if (keyCode == BACKSPACE) {note="";}
    else {note = note + key;}
  }
  
  if (key == ' ') {
        if (trackMouse) {trackMouse = false;}
        else {trackMouse = true;}
  }
}


void mousePressed()
{
  move=true;
  Xpos=(mouseX-100)/4;
  Ypos=(mouseY-400)/-4;
  // left handles for angle change (one moves)
  if ((Xpos > left-d) & (Xpos < left+d)) { // on left points
      if ((Ypos > AA-d) & (Ypos < AA+d))
        { event = "PointA";
        }
      else if ((Ypos > CC-d) & (Ypos < CC+d))
        { event = "PointC";
        }
  } 
  if ((Xpos > right-d) & (Xpos < right+d)) { // on right points
      if ((Ypos > BB-d) & (Ypos < BB+d))
        { event = "PointB";
        }
      else if ((Ypos > DD-d) & (Ypos < DD+d))
        { event = "PointD";
        }
      } 
      
  if ((Xpos > right+d) & (Xpos < right+d+20)) { // to the right of right points
      if ((Ypos > BB-d) & (Ypos < BB+d+5)) {
      if (label1edit)
            {label1edit=false;}
          else  {label1edit=true;}
      }
      else if ((Ypos > DD-d) & (Ypos < DD+d+5))
      if (label2edit)
            {label2edit=false;}
          else  {label2edit=true;}
      } 

  if (mouseY < 30) {
    if ((mouseX > 0) & (mouseX < 100)) { // Fill toggle button    
      if (drawProducerCost) 
            {drawProducerCost=false; label2=" ";}
      else  {drawProducerCost=true; label2="MPC";}
      }
    
    
    if ((mouseX > 100) & (mouseX < 200)) { // Fill toggle button    
      if (drawFill) 
            {drawFill=false;}
      else  {drawFill=true;}
      }
    if ((mouseX > 200) & (mouseX < 300)) { // Fill toggle button    
      if (invisibleHand) 
            {invisibleHand=false;}
      else  {invisibleHand=true;
              trackMouse=true;}
      }
    if ((mouseX > 300) & (mouseX < 400)) { // Fill toggle button    
      if (drawBottom) 
            {drawBottom=false; label1="MPC"; label2="MCB";}
      else  {drawBottom=true; label1="Abatement cost"; label2="Emission cost";}
      }
      
    if ((mouseX > 400) & (mouseX < 500)) { // Fill toggle button    
      if (drawWelfareloss) 
            {drawWelfareloss=false;}
      else  {drawWelfareloss=true;}
      }
      
    if ((mouseX > 500) & (mouseX < 600)) { // Fill toggle button    
      if (drawSocialCost) 
            {drawSocialCost=false;}
      else  {drawSocialCost=true;}
      }
    
  }

}


void mouseReleased()
{
  move=false;
  event = "Nothing";
}

void dragPoints()
{
  Xpos=(mouseX-100)/4;
  Ypos=(mouseY-400)/-4;
  // left handles for angle change (one moves)
  if (event=="PointA") { AA=Ypos; }
  if (event=="PointB") { BB=Ypos; AA=A+(BB-B); }
  if (event=="PointC") { CC=Ypos; DD=D+(CC-C);}
  if (event=="PointD") { DD=Ypos;}   
}



float update(float tempY, float restY, int ID) {
  //Spring(240, 260,  40, 0.98, 8.0, 0.1, springs, 0);
    float k = 0.1;
    float damp = 0.82;
    int mass = 5;
    float force,accel;
   
    force = -k * (tempY - restY);  // f=-ky 
    accel = force / mass;                 // Set the acceleration, f=ma == a=f/m 
    vY[ID] = damp * (vY[ID] + accel);         // Set the velocity 
    tempY = tempY + vY[ID];           // Updated position 

  return tempY;
}


void drawSurplus(float t) {
// producer suplus
 Q= bezierPoint(left, left, right, right, t);
 P= bezierPoint(A, A-0.5*(A-B), B, B, t);
 float integral1 = 0;
 float integral2 = 0;
 
  fill(producerFill);
  noStroke();
  beginShape();
  for (float x_t=0; x_t<=t; x_t+=0.01){
  vertex(bezierPoint(left, left, right, right, x_t), bezierPoint(C, C, D-0.5*(D-C), D, x_t));
  integral1+=P-bezierPoint(C, C, D-0.5*(D-C), D, x_t);
  }
  vertex(Q, P);
  vertex(left, P);
  vertex(left, C);
  endShape();
  
  beginShape();
  vertex(right+20, 0);
  vertex(right+20, integral1/20);
  vertex(right+40, integral1/20);
  vertex(right+40, 0);
  endShape();
  scale(1,-1);
  textAlign(CENTER);
  fill(0);
  text("Producer",right+30,0-integral1/20+3);
  text("surplus",right+30,0-integral1/20+6);
  textAlign(LEFT);
  scale(1,-1);
  
    // consumer suplus
  fill(consumerFill);
  noStroke();
  beginShape();
  for (float x_t=0; x_t<=t; x_t+=0.01){
  vertex(bezierPoint(left, left, right, right, x_t), bezierPoint(A, A-0.5*(A-B), B, B, x_t));
  integral2+=bezierPoint(A, A-0.5*(A-B), B, B, x_t)-P;
  }
  vertex(Q, P);
  vertex(left, P);
  vertex(left, A);
  endShape();
  
  
  beginShape();
  vertex(right+20, integral1/20);
  vertex(right+20, integral1/20+integral2/20);
  vertex(right+40, integral1/20+integral2/20);
  vertex(right+40, integral1/20);
  endShape();
  
  scale(1,-1);
  textAlign(CENTER);
  fill(0);
  text("Consumer",right+30,0-integral1/20-integral2/20+3);
  text("surplus",right+30,0-integral1/20-integral2/20+6);
  textAlign(LEFT);
  scale(1,-1);
}

void fillWelfareloss(float t1, float t2) {
 float Q1= bezierPoint(left, left, right, right, t1);
 float P1= bezierPoint(A, A-0.5*(A-B), B, B, t1);
 float Q2= bezierPoint(left, left, right, right, t2);
 float P2= bezierPoint(A, A-0.5*(A-B), B, B, t2);
 float E = C+ext;
 float F = D+ext;
  fill(#F7DE82);
  noStroke();
  beginShape();
  vertex(Q2, P2);
  for (float x_t=t2; x_t<=t1; x_t+=0.01){
  vertex(bezierPoint(left, left, right, right, x_t), bezierPoint(A, A-0.5*(A-B), B, B, x_t));
  }
  vertex(Q1, P1);
  vertex(Q1, P1+ext);
  
  for (float x_t=t1; x_t>=t2; x_t-=0.01){
  vertex(bezierPoint(left, left, right, right, x_t), bezierPoint(E, E, F-0.5*(F-E), F, x_t));
  }  
  vertex(Q2, P2);
  endShape();
  fill(128);
  noFill();
}

void fillBottom(float t) {

// area under graphs
 Q= bezierPoint(left, left, right, right, t);
 P= bezierPoint(A, A-0.5*(A-B), B, B, t);
 float integral1 = 0;
 float integral2 = 0;
 
  fill(producerFill);
  noStroke();
  beginShape();
  for (float x_t=0; x_t<=t; x_t+=0.01){
  vertex(bezierPoint(left, left, right, right, x_t), bezierPoint(C, C, D-0.5*(D-C), D, x_t));
  integral1+=bezierPoint(C, C, D-0.5*(D-C), D, x_t);
  }
  vertex(Q, P);
  vertex(Q, 0);
  vertex(left, 0);
  vertex(left, C);
  endShape();
  
  beginShape();
  vertex(right+20, 0);
  vertex(right+20, integral1/10);
  vertex(right+40, integral1/10);
  vertex(right+40, 0);
  endShape();
  
  scale(1,-1);
  textAlign(CENTER);
  fill(0);
  text("Social",right+30,0-integral1/10+3);
  text("cost",right+30,0-integral1/10+6);
  textAlign(LEFT);
  scale(1,-1);
  
  
  //abatement
  fill(consumerFill);
  noStroke();
  beginShape();
  vertex(Q, P);
  for (float x_t=t; x_t<=1; x_t+=0.01){
  vertex(bezierPoint(left, left, right, right, x_t), bezierPoint(A, A-0.5*(A-B), B, B, x_t));
  integral2+=bezierPoint(A, A-0.5*(A-B), B, B, x_t);  
  }
  vertex(right, B);
  vertex(right, 0);
  vertex(Q, 0);
  //vertex(Q, P);
  endShape();
  
  
  beginShape();
  vertex(right+20, integral1/10);
  vertex(right+20, integral1/10+integral2/10);
  vertex(right+40, integral1/10+integral2/10);
  vertex(right+40, integral1/10);
  endShape();
  
  scale(1,-1);
  textAlign(CENTER);
  fill(0);
  text("Abatement",right+30,0-integral1/10-integral2/10+3);
  text("cost",right+30,0-integral1/10-integral2/10+6);
  textAlign(LEFT);
  scale(1,-1);
  
}

void drawLabels() {
  scale(1,-1);
  textSize(6);
  fill(consumer);
  text(label1,right+d,-B);
  
  fill(producer);
  text(label2,right+d,-D);
  
  scale(1,-1);
  noFill();
}

void drawIntersection(float t, String label) {
 Q= bezierPoint(left, left, right, right, t);
 P= bezierPoint(A, A-0.5*(A-B), B, B, t);
  fill(producer);
  stroke(producer);
  line(Q,P,Q,-1);
  scale(1,-1);
  textSize(4);
  text(label,Q,5);
  scale(1,-1);
  noFill();
 
}

void drawButtons(int targetPos) {
  textAlign(CENTER);
  buttonY=update(buttonY,targetPos,4); //ID=4 for the fifth speed element
  float textY=buttonY-2;
  rect(0,0,100,buttonY);
  if (drawProducerCost) {text("MPC",50,textY);}
          else {text("No MPC",50,textY);}
  rect(100,0,100,buttonY);
  if (drawFill) {text("Fill",150,textY);}
          else {text("No Fill",150,textY);}
  rect(200,0,100,buttonY);
  if (invisibleHand) {text("Invisible Hand",250,textY);}
          else {text("Manual",250,textY);}
  rect(300,0,100,buttonY);
  if (drawBottom) {text("Cost",350,textY);}
          else {text("Surplus",350,textY);}
  rect(400,0,100,buttonY);
  if (drawWelfareloss) {text("Deadweight",450,textY);}
          else {text("No Deadweight",450,textY);}
  rect(500,0,100,buttonY);
  if (drawSocialCost) {text("Social cost",550,textY);}
          else {text("No social cost",550,textY);}  
  
  textAlign(LEFT);

}


void draw() {
  background(255);
  strokeWeight(0.25);
  stroke(255);
  //fill(240);
  textSize(14);

  if (mouseY<30) {drawButtons(20);}
    else {drawButtons(0);}
  translate(100,400);
  scale(4,-4);

  noFill();
  
  //coordinate system
  strokeWeight(0.15);
  stroke(0.15);
  line(0,0,0, 80);
  line(0,0,100,0);
  
  
  pushMatrix();
  textSize(4);
  scale(1,-1);
  text("Quantity",50,16);
  rotate(-PI/2);
  text("Cost/Benefit",25,-6);
  popMatrix();
  
  
  if (move==true){
     dragPoints();
   } else {
    A=update(A,AA,0);
    B=update(B,BB,1);
    C=update(C,CC,2);
    D=update(D,DD,3);
   }
    
 // }
  
  
  drawLabels();
  
  //drawBLine(C+ext,D+ext,CC+ext,DD+ext,external);

  if (invisibleHand) {
  t = intersectBLine(A,B,C,D);}
  else {if (trackMouse) {t = tMouse();}}
  
  drawIntersection(t,"Q");
  if (drawFill) {
    if (drawBottom) {fillBottom(t);}
    else {drawSurplus(t);}
  } 
  
  noFill();
  
  if (drawSocialCost) {
    float t2 =  intersectBLine(A,B,C+ext,D+ext);
    drawIntersection(t2,"Q*");
    if (drawWelfareloss) {fillWelfareloss(t,t2);}
    drawBLine(C+ext,D+ext,CC,DD,external);
   }
    
  drawBLine(A,B,AA,BB,consumer);

  if (drawProducerCost) {drawBLine(C,D,CC,DD,producer);}
  
  scale(1,-1);
  Xpos=(mouseX-100)/4;
  Ypos=(mouseY-400-10)/4;
  text(note,Xpos,Ypos);
  
  //drawIntersection(A,B,C+ext,D+ext,external);
  
  
}

