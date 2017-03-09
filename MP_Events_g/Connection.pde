//class Connection
//{
//  int lastdraw;
//  Peer from;
//  Peer to;
//  boolean stream;
//  ArrayList kibbles = new ArrayList();
//  int deadkibbles;
//  int speed;
//  Bit theBit;
//
//  Connection(Peer f, Peer t, Bit b)
//  {
//    theBit = (Bit)b;
//    from = f;
//    to = t;
//    stream = true;
//    lastdraw = millis();
//    deadkibbles = 0;
//    speed = int(random(30,500));
//  }
//
//  int getIdxTo()
//  {
//    return to.index;
//  }
//
//  int getIdxFrom()
//  {
//    return from.index;
//  }
//
//
//  void manageKibbles()
//  {
//    if ( from.removing >= 1 || to.removing >= 1 || deadkibbles > 125 )
//    { 
//      stream = false;  
//    }
//    else
//    {
//      if (lastdraw < millis() - speed)
//      {   
//        newKibble();
//      }
//    }
//    drawKibbles();
//  }
//
//
//  void newKibble()
//  {
//    Kibble k = new Kibble();
//    k.starttime = millis();
//    k.endtime = k.starttime + 5000;
//    kibbles.add(k);
//    lastdraw = millis();
//  }
//
//  void drawKibbles()
//  {
//    for (int i = 0; i < kibbles.size(); i++)
//    {
//      Kibble k = (Kibble)kibbles.get(i);
//      if(millis() > k.endtime)
//      {
//        kibbles.remove(i);
//        deadkibbles++;
//      }
//      else
//      {
//        float diff = (millis() - k.starttime) / (k.endtime - k.starttime);
//
//        float xpos = from.cxpos * (1 - diff) + (to.cxpos) * diff;
//        float ypos = from.cypos * (1 - diff) + (to.cypos) * diff;
//
//        colorMode(HSB);
//        fill(theBit.bitHue, 255, 255);
//        stroke(theBit.bitHue, 255, 255);
//        strokeWeight(k.big);
//        ellipse(xpos, ypos, k.big, k.big);
//      }
//    }
//
//  }
//
//}


