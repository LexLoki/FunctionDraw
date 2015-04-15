int tamx=800, tamy=760, i, r=7, r0=20, px, py, axis, p, lastp, paxis, j, yellow, yellowAxis=0, trac=7, tMargin=40;
float aux;
int  rx=r0, ry=r0;
int radiusx=rx/2-1, radiusy=ry/2-1;
int P1x, P1y, P2x, P2y;
int[] pointsx= new int[80];
int[] pointsy = new int[80];
//int[] lock = new int[10];
int pointsAux=0;
boolean doPoint=false, doDrawP=false, doDrawL=false, doText=false, doDrawC=false;

void setup(){
  fill(0, 102, 200);
  cursorSetup(7);
  //size(displayWidth, displayHeight);
  //size(tamx,tamy);
  size(1000,760);
}
  

void draw(){
 drawGraph();
 
 if(!doText){
   if(doDrawP&&pointsAux>=3)
     for(j=0;pointsAux-j>=3;j+=3)
       drawPar((float)pointsx[j], (float)pointsx[j+1], (float)pointsx[j+2], (float)pointsy[j], (float)pointsy[j+1], (float)pointsy[j+2]);
   else if(doDrawL&&pointsAux>=2)
     for(j=0;pointsAux-j>=2;j+=2)
       drawLine((float)pointsx[j], (float)pointsx[j+1], (float)pointsy[j], (float)pointsy[j+1]);
   else if(doDrawC&&pointsAux>=2)
     for(j=0;pointsAux-j>=2;j++)
       drawConnectPoints((float)pointsx[j], (float)pointsx[j+1], (float)pointsy[j], (float)pointsy[j+1]);
 }
 
 cursorHand();
}

void mousePressed(){
  
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

void keyPressed(){
  switch(key){
    case 119: ry++; break;
    case 115: ry--; break;
    case 97: rx--; break;
    case 100: rx++; break;
    case 113:
      doDrawL = !doDrawL;
      if(doDrawL){
        doDrawP = false;
        doDrawC = false;
      }
      break;
    case 101:
      doDrawP = !doDrawP;
      if(doDrawP){
        doDrawL = false;
        doDrawC = false;
      }
      break;
    case 99:
      doDrawC = !doDrawC;
      if(doDrawC){
        doDrawL = false;
        doDrawP = false; 
      }
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
