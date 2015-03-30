//onAxis 1 - y, 2 - x

//boolean sketchFullScreen() {
//  return true;
//}

int onAxis(int x, int y){
  if(abs(y-height/2)<=radiusx)
    return 2;
  if(abs(x-width/2)<=radiusy)
    return 1;
  return 0;
}

void drawGraph(){
  if(!doText)
  {
  background(211, 211, 211);
  stroke(0, 0, 0);
  strokeWeight(3);
  line(0,0, width,0); line(width,0,width,height); line(width,height,0,height); line(0,height,0,0);
  line(0, height/2, width, height/2);
  line(width/2, 0, width/2, height);
  stroke(200, 0, 0);
  strokeWeight(10);
  point(width/2, height/2);
  textSize(9.5);
  for(i=rx;width/2+i<=width;i+=rx){
    point(width/2+i, height/2);
    text(i/rx, width/2+i+5, height/2+15);
    point(width/2-i, height/2);
    text((-1)*i/rx, width/2-i-2, height/2+15);
  }
  for(i=ry;height/2+i<=height;i+=ry){
    point(width/2, height/2+i);
    text(i/ry, width/2+8, height/2-i+10);
    point(width/2, height/2-i);
    text((-1)*i/ry, width/2+4, height/2+i+10);
  }
  for(j=0;j<pointsAux;j++)
    drawPoint(width/2+rx*pointsx[j], height/2-ry*pointsy[j]);
  if(yellowAxis!=0){
    stroke(220,220,0);
    if(yellowAxis==1)
      point(width/2,height/2-ry*yellow);
    else
      point(width/2+rx*yellow,height/2);
  }
  textSize(16);
  text("Press 'i' for instructions", 5, 15);
  if(doDrawL)
    text("Line ON", 731, 32);
  else
    text("Line OFF", 731, 32);
  if(doDrawP)
    text("Parabola ON", 698, 15);
  else
    text("Parabola OFF", 698, 15);
  }  //!doText
  else{
    background(211, 211, 211);
    textSize(27);
    text("= = FUNCTION DRAW APPLICATION = =", 125, 30);
    text("'a'/'d' to zoom horizontal axis", 10, 130); 
    text("'s'/'w' to zoom vertical axis", 10, 175);
    text("'q' to toggle line function visibility", 10, 245);
    text("'e' to toggle parabola function visibility", 10, 290);
    text("Need 2 points for the line and 3 for the parabola", 10, 335);
    text("Works for the first 2 or 3 points made", 10, 380);
    text("Click on 1 dot of each axis to make a (x,y) point\nYou can cancel a selected point clicking on it (yellow) again\nYou can cancel a function point (blue) by clicking on it", 10, 450);
    text("'spacebar' to delete all the points", 10, 605);
    text("press 'i' to return", 10, 685);
  }
}

void drawPoint(int x, int y){
  strokeWeight(0.7);
  
  stroke(50, 50, 50); //black lines
  r=abs(r);                                                //From x axis
  if(y<height/2)
    r*=-1;
  for(i=height/2;abs(height/2-(i+r))<abs(height/2-y);i += 2*r)
    line(x, i, x, i+r);
  if(abs(height/2-i)<abs(height/2-y))
    line(x, i, x, y);
  r=abs(r);                                                 //From y axis
  if(x<width/2)
    r*=-1;
  for(i=width/2;abs((i+r)-width/2)<abs(x-width/2);i += 2*r)
    line(i, y, i+r, y);
  if(abs(i-width/2)<abs(x-width/2))
    line(i, y, x, y);
    
  stroke(0, 200, 0); //green dots
  strokeWeight(10);
  point(x, height/2);
  point(width/2, y);
  stroke(0, 0, 200); //blue dot
  point(x, y); 
}

void drawPar(float x1, float x2, float x3, float y1, float y2, float y3){
  float a, b, c;
  a = ((y1-y2)*(x1-x3) - (y1-y3)*(x1-x2)) / ((x1*x1-x2*x2)*(x1-x3) - (x1*x1-x3*x3)*(x1-x2));
  b = (y1 - y2 - a*(x1*x1-x2*x2))/(x1-x2);
  c = y1 - a*x1*x1 - b*x1;
  stroke(255,140,0);
  strokeWeight(2);
  for(i=0;i<=width;i++){
    x1=((float)(i) - width/2)/(float)rx;
    y1=x1*x1*a + x1*b + c;
    //point(width/2+x1*rx, height/2-y1*ry);
    if(i>0)
      line(width/2+x2*rx, height/2-y2*ry, width/2+x1*rx, height/2-y1*ry);
    x2=x1;
    y2=y1;
  }
}

void drawLine(float x1, float x2, float y1, float y2){
  float a, b;
  a = (y1-y2)/(x1-x2);
  b = y1 - a*x1;
  stroke(255,140,0);
  strokeWeight(2);
  //for(i=0;i<=width;i++){
    //x1=((float)(i) - width/2)/(float)rx;
    //y1 = x1*a + b;
    //point(width/2+x1*rx, height/2-y1*ry);
  //}
  line( 0, height/2 - ((-width/2/(float)rx)*a+b)*(float)ry, width, height/2 - ((width/2/(float)rx)*a+b)*(float)ry); 
}

void drawExp(float x1, float x2, float y1, float y2){
  float a, b, c, alfa, beta, b1, b2;
  /*alfa = x1-x3;
  beta = x2-x3;
   b1 = nthRoot( int(x1-x2), (y1-y3)*(x2-x3)/(y2-y3) );
  if((x1-x2)%2==0)
    b2 = -b1;
  else
    b2 = b1;
  */
  a = (y1-y2)/( exp(x1)-exp(x2));
  b = (exp(x1)*y2-y1*exp(x2))/( exp(x1)-exp(x2));
  stroke(255,140,0);
  strokeWeight(2);
  for(i=0;i<=width;i++){
    x1=((float)(i) - width/2)/(float)rx;
    y1=a*exp(x1) + b;
    //point(width/2+x1*rx, height/2-y1*ry);
    if(i>0)
      line(width/2+x2*rx, height/2-y2*ry, width/2+x1*rx, height/2-y1*ry);
    x2=x1;
    y2=y1;
  }
}

float nthRoot(int n, float A) {
  float x0 = 1;
  boolean accurate = false;
  while (!accurate) {
    float x1 = (1 / (float)n) * ((n - 1) * x0 + A / pow(x0, n - 1));
    accurate = accurate(x0, x1);
    x0 = x1;
  }
  return x0;
}
boolean accurate(float x0, float x1) {
  return Math.abs(x1-x0) < 0.000001;
}
