class BarGraph {
  float bwidth;    // width and height of bar
  int Ybase,Xpos,Scale;
  ArrayList Yvalues;
  
 // float[] Xvalues;
  
  BarGraph (int _Xpos, int _Ybase) {
    bwidth = 30;
    Scale  = 50;
    Ybase =_Ybase;
    Xpos  =_Xpos;
  }

 void display(int sp, int barID) {
   int stackHeight = Ybase;
   
   String[] theseLoads = split(demand_data[sp], ',');
    
   for (int i = 0; i < theseLoads.length; i = i+1) {
        fill(10*1,255-20*i,0);
        rect(Xpos,stackHeight,bwidth,-int(theseLoads[i])/Scale);
        stackHeight=stackHeight-int(theseLoads[i])/Scale;
        }
   
   if (barID==1) {grph_demand.update(sp,stackHeight);}
   else {grph_demand.mark(sp,stackHeight);}
   
   String time = floor(sp/2) + ":" + str(3*(sp % 2)) + "0";
   text(time,Xpos,Ybase);
  }
}
