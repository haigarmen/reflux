class TextField{

PFont greyscaleBasic;
String msg;
int xPos;
int yPos;
int fontSize;
int fontColor;

public TextField(String inMsg, int x, int y,int fSize,int clr)
  {
    greyscaleBasic = loadFont("GreyscaleBasic.vlw");
    msg = inMsg;
    xPos = x;
    yPos = y;
    fontSize = fSize;
    fontColor = clr;
  }
  void setMsg(String inMsg)
  {
    msg = inMsg;
  }
  void setFontSize(int size)
  {
    fontSize = size;
  }
  void setFontColor(int clr)
  {
    fontColor = clr;
  }
  void display()
  {
    noStroke();
    fill(0, 80);
    rectMode(CENTER);
    rect(xPos, yPos, (width*.8), 40);
    textFont(greyscaleBasic,fontSize);
    fill(fontColor);
    textAlign(CENTER);
    text(msg,xPos,yPos);
  } 
}
