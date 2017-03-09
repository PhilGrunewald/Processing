
HScrollbar hs_date, hs2_date;  // Two scrollbars
Graph grph_demand;
BarGraph right_bar;
BarGraph left_bar;

String[] demand_data;


void setup() {
  size(600, 600);
  background(255);
  //stroke(0);
  demand_data = loadStrings("2010_12_20_42HH_load.csv");

  hs_date = new HScrollbar(10, height-16, width/3, 16, 16);
  hs2_date = new HScrollbar(width/2+10, height-16, width/3, 16, 16);
  grph_demand = new Graph();
  left_bar = new BarGraph(width-100,height-50);
  right_bar = new BarGraph(width-50,height-50);
}

void draw() {
    int sp_1 = round(48 * hs_date.getPos());
    int sp_2 = round(48 * hs2_date.getPos());
 
   int bar_base = height-50;   
   
   background(255);
    
   //if (sp_1+sp_2 > 0) {grph_demand.update(sp_2,bar_base);}
  
  grph_demand.display();
  
  right_bar.display(sp_2,1);
  left_bar.display(sp_1,2);
  
  hs_date.update();
  hs_date.display();
  
  hs2_date.update();
  hs2_date.display();
  
}
