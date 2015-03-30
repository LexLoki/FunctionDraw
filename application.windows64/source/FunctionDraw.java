import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class FunctionDraw extends PApplet {

int tamx=800, tamy=760, i, r=7, r0=20, px, py, axis, p, lastp, paxis, j, yellow, yellowAxis=0, trac=7, tMargin=40;
float aux;
int  rx=r0, ry=r0;
int radiusx=rx/2-1, radiusy=ry/2-1;
int P1x, P1y, P2x, P2y;
int[] pointsx= new int[80];
int[] pointsy = new int[80];
//int[] lock = new int[10];
int pointsAux=0;
boolean doPoint=false, doDrawP=false, doDrawL=false, doText=false;

public void setup(){
  fill(0, 102, 200);
  cursorSetup(7);
  size(tamx,tamy);
}
  

public void draw(){
 drawGraph();
 
 if(!doText){
   if(doDrawP&&pointsAux>=3)
     for(j=0;pointsAux-j>=3;j+=3)
       drawPar((float)pointsx[j], (float)pointsx[j+1], (float)pointsx[j+2], (float)pointsy[j], (float)pointsy[j+1], (float)pointsy[j+2]);
   else if(doDrawL&&pointsAux>=2)
     for(j=0;pointsAux-j>=2;j+=2)
       drawLine((float)pointsx[j], (float)pointsx[j+1], (float)pointsy[j], (float)pointsy[j+1]);
 }
 
 cursorHand();
}

public void mousePressed(){
  
  if(!doText){
  
  stroke(0,200,0);
  axis=onAxis(mouseX, mouseY); // 1 - y; 2 - x  paxis
  if(axis!=0){
    if(axis==1){
      px = height/2 - ((height/2-mouseY)/ry)*ry;
      if(mouseY>height/2){
        py=px;
        px=py+ry;
      }
      else
        py=px-ry;
      py = (px-mouseY<mouseY-py) ? px : py;
      px = width/2;
    }
    else{
      px = width/2 + ((mouseX-width/2)/rx)*rx;
      if(mouseX<width/2){
        py=px;
        px=py-rx;
      }
      else
        py=px+rx;
      px = (py-mouseX<mouseX-px) ? py : px;
      py = height/2;
    }
    if(!doPoint){
      stroke(220, 220, 0); //yellow dot
      point(px, py);
      P1x = (px-width/2)/rx;
      P1y = (height/2-py)/ry;
      yellowAxis = axis;
      yellow = P1x+P1y;
        
      paxis = axis;
      doPoint = !doPoint;
    }
    else{
      if(axis!=paxis||(px==width/2&&py==height/2)||(P1x==0&&P1y==0)){ //draw the point (x,y)
      
        P1x=P1x*rx+width/2;
        P1y=P1y*ry*(-1)+height/2;
      
        if(P1x==width/2&&P1y!=height/2){
          P2y = P1y;
          P2x = px;
        }
        else{
          P2x = P1x;
          P2y = py;
        }
        
        drawPoint(P2x, P2y);
        yellowAxis=0;
        pointsx[pointsAux]=(P2x-width/2)/rx;
        pointsy[pointsAux]=(height/2-P2y)/ry;
        pointsAux++;
        
        doPoint = !doPoint;
      }
      else if(px==P1x*rx+width/2&&py==P1y*ry*(-1)+height/2){ //cancel yellow dot selection
        stroke(200, 0, 0);
        point(px, py);
        yellowAxis=0;
        doPoint = !doPoint;
      }
      
    }
  }
  else{
    for(i=0;i<pointsAux;i++)
      if(dist(mouseX, mouseY, width/2+pointsx[i]*rx, height/2-pointsy[i]*ry)<=7){
        for(j=i+1;j<pointsAux;i++,j++){
          pointsx[i]=pointsx[j];
          pointsy[i]=pointsy[j];
        }
        pointsAux--;
      }
  }
  } //doText close
}

public void keyPressed(){
  switch(key){
    case 119: ry++; break;
    case 115: ry--; break;
    case 97: rx--; break;
    case 100: rx++; break;
    case 113:
      doDrawL = !doDrawL;
      if(doDrawL)
        doDrawP = false;
      break;
    case 101:
      doDrawP = !doDrawP;
      if(doDrawP)
        doDrawL = false;
      break;
    case 32:
      pointsAux=0;
      yellowAxis=0;
      doPoint=false;
      break;
    case 105:
      doText=!doText;
      break;
  }
  if(key==119||key==115||key==97||key==100){
    radiusx=rx/2-1;
    radiusy=ry/2-1;
  }
}
//onAxis 1 - y, 2 - x

public int onAxis(int x, int y){
  if(abs(y-height/2)<=radiusx)
    return 2;
  if(abs(x-width/2)<=radiusy)
    return 1;
  return 0;
}

public void drawGraph(){
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
  textSize(9.5f);
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

public void drawPoint(int x, int y){
  strokeWeight(0.7f);
  
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

public void drawPar(float x1, float x2, float x3, float y1, float y2, float y3){
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

public void drawLine(float x1, float x2, float y1, float y2){
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
PImage cursor;
int cursorX=242, cursorY=70, cursorSizeX, cursorSizeY;

public void cursorSetup(int resize){
  noCursor();
  cursor = loadImage("cursor.png");
  cursorSizeX = cursor.width/resize;
  cursorSizeY = cursor.height/cursor.width*cursorSizeX;
  cursorX /= cursor.width/cursorSizeX;
  cursorY /= cursor.height/cursorSizeY;
}

public void cursorHand(){
  imageMode(CORNER);
  image(cursor, mouseX-cursorX, mouseY-cursorY, cursorSizeX, cursorSizeY);
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "FunctionDraw" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
