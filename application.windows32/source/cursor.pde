PImage cursor;
int cursorX=242, cursorY=70, cursorSizeX, cursorSizeY;

void cursorSetup(int resize){
  noCursor();
  cursor = loadImage("cursor.png");
  cursorSizeX = cursor.width/resize;
  cursorSizeY = cursor.height/cursor.width*cursorSizeX;
  cursorX /= cursor.width/cursorSizeX;
  cursorY /= cursor.height/cursorSizeY;
}

void cursorHand(){
  imageMode(CORNER);
  image(cursor, mouseX-cursorX, mouseY-cursorY, cursorSizeX, cursorSizeY);
}
