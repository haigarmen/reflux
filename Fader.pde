class Fader {
  int alphavalue = 255;
  int starttime;
  int delaytime = 9255;
  int curtime;

  float count_up;
  float count_down;
  float calc_alpha;

  boolean showFade;
  boolean fadeUp;
  boolean fadeDown;
  boolean posterNow;
  boolean printNow;
  
  Fader(int startTime) {
    starttime = startTime;
  }
  void draw() {
    if (showFade) {
    println("fade alpha is " + alphavalue);
      fill(0, alphavalue);
      rectMode(CORNER);
      rect(0, 0, width, height);
    }
  }
  void fadeUp() {
    count_up = (millis() - starttime); // timer count since (mousePressed())  
    count_down = delaytime - count_up; // countdown since started (mousePressed())

//    println("fade up");
    calc_alpha = 255 / (delaytime / count_down); // fade-out, calculate alpha value vs. duration
    alphavalue = floor(calc_alpha); // floor rounds DOWN and returns the closest integer value

    if ((alphavalue == 255) || (alphavalue > 255)) { 
      count_down = 0; 
      count_up = delaytime;
    }   //some precision is lost from float to int, so i reset these
    if (alphavalue == 0 || (alphavalue < 0)) {
      println("alphavalue reached 0, resetting now");
      count_down = 0; 
      count_up = delaytime;
      showFade = false;
      fadeDown = true;
    } //for visual readout purposes only. ignoreable.
  }

  void fadeDown() {
    count_up = (millis() - starttime); // timer count since (mousePressed())  
    count_down = delaytime - count_up; // countdown since started (mousePressed())

//    println("fade down");
    calc_alpha = 255 / (delaytime / count_up); // fade-in, calculate alpha value vs. duration
    alphavalue = ceil(calc_alpha); // ceil rounds UP and returns the closest integer value

    if ((alphavalue == 0) || (alphavalue < 0)) { 
      count_down = 0; 
      count_up = delaytime;
    }   //some precision is lost from float to int, so i reset these

    if ((alphavalue == 255) || (alphavalue > 255)) {
      println("alphavalue reached 255, staying black");
      posterNow = true;
      count_down = 0; 
      count_up = delaytime;
      showFade = true;
      fadeDown = true;
      if (render_countdown) {
          render_poster = true;
      }
    } //for visual readout purposes only. ignoreable.
  }
}

