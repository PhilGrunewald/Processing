class Graph {
  float gwidth, gheight;    // width and height of bar
  ArrayList Xvalues;// = new ArrayList();
  ArrayList Yvalues;// = new ArrayList();
  int Xorigin, Yorigin;
 // float[] Xvalues;
  
  Graph () {
    gwidth = 0.8*width;
    gheight = 0.8*height;
    Xorigin = 40;
    Yorigin = height-50;
    Xvalues = new ArrayList();
    Yvalues = new ArrayList();
  }


  void update(float _Xval, float _Yval) {
    Xvalues.add(_Xval);
    Yvalues.add(_Yval);
  }
  
  void mark(int _X, int _Y) {
      stroke(0,20,210);
      line(Xorigin+10*_X,_Y,width-100,_Y);
      ellipse(Xorigin+10*_X,_Y,8,8);  
  }
  
  void display() {
    stroke(0);
    line(Xorigin+10,Yorigin,width-150,Yorigin); // xaxis
    line(Xorigin+10,Yorigin,Xorigin+10,50); // xaxis
    
    fill(255);
    for (int i = 0; i < Xvalues.size(); i = i+1) {
      if (i>1){
      line(Xorigin+10*(Float)Xvalues.get(i),(Float)Yvalues.get(i),Xorigin+10*(Float)Xvalues.get(i-1),(Float)Yvalues.get(i-1));
      }
      if (i==Xvalues.size()-1) {
           stroke(255,20,10);
           line(Xorigin+10*(Float)Xvalues.get(i),(Float)Yvalues.get(i),width-50,(Float)Yvalues.get(i));
      }
      ellipse(Xorigin+10*(Float)Xvalues.get(i),(Float)Yvalues.get(i),8,8);
    }
  }
}
