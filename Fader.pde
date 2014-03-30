class Fader {
  int alphavalue;
  int starttime;
  int delaytime = 9255;
  int curtime;

  float count_up;
  float count_down;
  float calc_alpha;

  boolean showFade;

  boolean fadeUp;
  boolean fadeDown;


  Fader() {
    starttime = millis();
  }
  void draw() {
    if (showFade) {
    fill(0, alphavalue);
    rectMode(CORNER);
    rect(0, 0, width, height);
    }
  }
  void fadeUp() {
    count_up = (millis() - starttime); // timer count since (mousePressed())  
    count_down = delaytime - count_up; // countdown since started (mousePressed())

    println("fade up");
    calc_alpha = 255 / (delaytime / count_up); // fade-in, calculate alpha value vs. duration
    alphavalue = ceil(calc_alpha); // ceil rounds UP and returns the closest integer value

    if (alphavalue == 0) { 
      count_down = 0; 
      count_up = delaytime;
    }   //some precision is lost from float to int, so i reset these
    if (alphavalue == 255) {
      println("alphavalue reached 255, resetting now");
      count_down = 0; 
      count_up = delaytime;
      fadeUp = true;
      showFade = false;
    } //for visual readout purposes only. ignoreable.
  }

  void fadeDown() {
    count_up = (millis() - starttime); // timer count since (mousePressed())  
    count_down = delaytime - count_up; // countdown since started (mousePressed())

    println("fade down");
    calc_alpha = 255 / (delaytime / count_down); // fade-out, calculate alpha value vs. duration
    alphavalue = floor(calc_alpha); // floor rounds DOWN and returns the closest integer value

    if (alphavalue == 0) { 
      count_down = 0; 
      count_up = delaytime;
      fadeDown = true;
      showFade = false;
    }   //some precision is lost from float to int, so i reset these
  }
}

