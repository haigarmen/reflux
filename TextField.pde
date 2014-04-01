class TextField {

ControlP5 cp5;
PFont greyscaleBasic;
PFont greyscaleBold;
String msg;
int xPos;
int yPos;
int fontSize;
int fontColor;


public TextField(String inMsg, int x, int y,int fSize,int clr) {
    greyscaleBasic = createFont("Greyscale Basic Regular.ttf", 80);
    greyscaleBold = createFont("Greyscale Basic Bold.ttf", 120);
    msg = inMsg;
    xPos = x;
    yPos = y;
    fontSize = fSize;
    fontColor = clr;
  }
  void setMsg(String inMsg) {
    msg = inMsg;
  }
  void setFontSize(int size) {
    fontSize = size;
  }
  void setFontColor(int clr) {
    fontColor = clr;
  }
  void display() {
    noStroke();
    fill(0, 200);
    rectMode(CENTER);
    rect(xPos, yPos, 600, 80);
    textFont(greyscaleBasic,fontSize);
    fill(fontColor);
    textAlign(CENTER);
    text(msg,xPos,yPos+10);
  }
}
