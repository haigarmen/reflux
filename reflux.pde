/* Reflux Art Installation
 a personal project that captures a photo and grabs images from the web of you
 and creates a printed poster for you to take home.
 
 possible names: re:self, re:spectacle
 */

//stuff to do:
// actual size sketch & fullscreen
// get video mirror fullscreen -- this is done but I don't have the capture mirrored yet
// create a countdown for image capture
// get name from textfield
// create the flow:
// 1. get your name 2.take a photo 3. compose poster 4. print screen 5. reset
// refine layout
// refine image filter (gridsize)
// need to escape web entities

// issues
// 1. textfield disappears in Present Mode (fixed)
// 2. copy image function doesn't work for PDF output - FIXED
//      a. resize images and see if that PDFs or 
//      b. convert images to vectors via ditherer class)
// 3. countdown doesn't show (fixed)
// 4. printing doesn't reset to Cam - FIXED
// 5. capture should go to printing (without break)
// stuff to fix II
// resultsCount not influencing drawMode yet FIXED (could be tweaked)
// printing not working after reset - should print after rendering poster not before FIXED

// press 0 to restart 
// Make it work in Portrait mode FIXED
// rotate textfield (maybe drop controlp5) FIXED
// fix layout of poster FIXED
// get feedback messages right- press P comes after fade to black
// fix the halftone dot density in Ditherer 2

import processing.pdf.*;
import java.util.Calendar;
import processing.video.*;
import controlP5.*;
import java.net.HttpURLConnection;    // required for HTML download
import java.net.URL;
import java.net.URLEncoder;
import java.io.InputStreamReader; 

boolean savePDF = false;
PImage capture_img;

int video_width;
int video_height;

boolean render_cam;
boolean render_capture;
boolean render_textfield;
boolean app_saving;
boolean render_dither;
boolean render_namefield;
boolean render_progress;
boolean render_poster;
boolean render_countdown;
boolean render_printing = false;
boolean render_scraper;
boolean isPrinted = false;
boolean timeUp = false;
boolean keyboardOn = true;

ControlP5 cp5;
TextField tField;
TextField nameField;
Ditherer img;

//int gridSize = 10;
int drawMode = 1;
int margin = 30;
boolean portrait = false;

String folder_path  = "output/";
String file_format  = ".jpg";

ProgressBar progBar;
Fader fader1;

// A variable for the frame we grab from the webcam
Capture cam;

Scraper scraping;
String searchName = "";


Timer timer;
int startTime = millis();

boolean sketchFullScreen() {
  return false;
}


void setup() {
  frame.setBackground(new java.awt.Color(0, 0, 0));
  size(1280, 960);
  //  size(1920, 1440);
  smooth();
  noStroke();
  video_width = 640;
  video_height = 480;
  render_cam = true;
  render_textfield = true;
  render_namefield = true;
  app_saving = false;
  cp5 = new ControlP5(this);

  //get a list of available camera modes and list them
  String[] cameras = Capture.list();
  if (cameras.length == 0) {
    //    println("There are no cameras available for capture.");
    exit();
  } 
  else {
    //    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      //      println(cameras[i]);
    }
    // The camera can be initialized directly using an element from the array returned by list():
    cam = new Capture(this, video_width, video_height, "FaceTime HD Camera");
    //      cam = new Capture(this, video_width, video_height, "Built-in iSight");
    //      cam = new Capture(this, video_width, video_height, "Microsoft® LifeCam Show(TM)");
    cam.start();
  }
  if (portrait) {
    tField = new TextField("Enter your full name and press ENTER", height/2, -200, 30, 255);
    tField.display();
  } 
  else {
    tField = new TextField("Enter your full name and press ENTER", width/2, int(height*.6), 30, 255);
    tField.display();
  }

  //  progBar = new ProgressBar(4000);

  fader1 = new Fader(startTime+2000);
  fader1.showFade = true;
  fader1.fadeDown = true;
}

void draw() {
  background(255);
  renderCam();
  renderCapture();
  renderPrinting();
  renderPoster();
  renderFade();
  if (portrait) {
    pushMatrix();
    rotate(1.57079633);
    renderTextField();
    renderNameField();
    renderCountdown();
    popMatrix();
  }
}

//wrap any of these in a beginRecord() and endRecord() to save as pdf.

void keyPressed() {
  switch(key) {
  case 's':
    if (render_capture) {
      saveImage("output/" + timestamp()+".jpg");
    }
    break;
  case 'p':
    if (render_capture) {
      println("P pressed");
      tField.setMsg("Creating Poster for "+ searchName);
      render_capture = false;
      render_poster = true;
      //      saveHiResPDF(4, "output/" + timestamp()+".pdf");
    }
    break;
  case 'v':
    restartCam();
    tField.setMsg("Press the 'c' key to capture image.");
    break;
  case '1':
    drawMode = 1;
    break;
  case '2':
    drawMode = 2;
    break;
  case '3':
    drawMode = 3;
    break;
  case '4':
    drawMode = 4;
    break;
  case '5':
    drawMode = 5;
    break;
  case '6':
    drawMode = 6;
    break;
  case '7':
    drawMode = 7;
    break;
  case '8':
    drawMode = 8;
    break;
  }

  if (key == CODED) {
    if (keyCode == UP) {
      img.gridSize++;
      println("gridSize is " + img.gridSize);
    }
    if (keyCode == DOWN) {
      if (img.gridSize > 2) {
        img.gridSize--;
        println("gridSize is " + img.gridSize);
      }
    }
    if (keyCode == ESC) {
      key = 0; 
      println("Trapped! Muhaha!");
    }
  }
  if (keyCode == BACKSPACE) {
    if (searchName.length() > 0 ) {
      searchName = searchName.substring( 0, searchName.length()- 1 );
    }
  } 
  else if (keyCode == DELETE) {
    searchName = "" ;
  } 
  else if (keyCode != SHIFT && keyCode != CONTROL && keyCode != ALT) {
    if (keyboardOn) {
      searchName = searchName + key;
    }
  }
  if (keyCode == ENTER) {
    keyboardOn = false;
    //    println("enter key pressed");
    if (searchName.equals("") || searchName.equals(" ")) {
      searchName = "random people";
    } 
    scraping = new Scraper(searchName);
  }
}

void captureCam() {
  if (render_capture) {
    return;
  }
  println("capture image");
  capture_img = cam.get();
  pushMatrix();
  //  scale(-2, 2);
  scale(-3, 3);
  translate(-capture_img.width, 0);
  image(capture_img, 0, 0);
  popMatrix();
  render_cam = false;
  cam.stop();
  img = new Ditherer(capture_img, drawMode);
  render_capture = true;
}

void saveImage(String filename) {
  if (app_saving) {
    return;
  }
  println("save image");

  tField.setMsg("Saving poster JPG");
  //  save_msg_timer.start();
  app_saving = true;

  println(filename);

  capture_img.save(filename);
  restartCam();
}

void restartCam() {
  if (render_cam) {
    return;
  }
  println("restart cam");
  render_textfield = true;
  render_namefield = true;
  app_saving = false;
  render_poster = false;
  render_capture = false;
  render_dither = false;
  isPrinted = false;
  cam.start();
  render_cam = true;
}

void renderCapture() {
  if (render_capture) {
    //  println("rendering captured image");
    pushMatrix();
    //    scale(-2, 2);
    scale(-3, 3);
    translate(-capture_img.width, 0);
    image(capture_img, 0, 0);
    popMatrix();
    //    image(capture_img, 0, 0);
  }
}

void renderFilteredImage(int drawMode) {
  if (render_dither) {
    //    println("drawing filtered Image");
    img.filterImage(drawMode);
  }
};

void renderTextField() {
  if (render_textfield) {
    //    println("rendering textfield");
    if (portrait) {
      tField = new TextField("Enter your full name and press ENTER", height/2, -200, 28, 255);
      tField.display();
      nameField = new TextField(searchName, height/2, -int(height*.12), 56, 255);
      nameField.display();
    } 
    else {
      tField = new TextField("Enter your full name and press ENTER", width/2, int(height*.6), 30, 255);
      tField.display();

      nameField = new TextField(searchName, width/2, int(height*.675), 60, 255);
      nameField.display();
    }
  }
}

void renderNameField() {
  if (render_namefield) {
    //    println("rendering name textfield");
    //    nameField = new TextField(searchName, width/2, int(height/2), 30, 255);
    //    nameField.display();
  }
  render_namefield = false;
}

void renderScraper() {
  if (render_scraper) {
    scraping.showImages();
  }
}

void renderCountdown() {
  if (render_countdown) {
    // show countdown
    int countDown = ((timer.totalTime/1000) - int(timer.passedTime/1000));
    tField.setMsg("Photo will be taken in");
    fill(0);
    rectMode(CENTER);
    rect(width/2, height/7, 100, 130);
    textSize(120);
    fill(255);
    text(countDown, width/2, height/7);
    // then show progress bar while
    // downloading images, displaying filtering image, scrap images and text   
    // save PDF, show "your poster is printing, it will take a few mins"
    if (timer.isFinished()) {
      //      println("timer finished");
      // when timer finished capture cam image
      captureCam();
      render_capture = true;
      // this might be why we can't go to render_poster automatically and need to pre
      render_countdown = false;
      //      tField.setMsg("Scraping the web: " + searchName + ", press P for poster");
      tField.setMsg("Scraping the web: " + searchName);

      // fade down to black first
      startTime = millis();
      fader1 = new Fader(startTime);      
      fader1.showFade = true;
      fader1.fadeUp = true;
      // after fadeDown trigger
    }
  }
}

void renderPrinting() {
  if (render_printing) {
    println("print file saved");
    // display a message that poster is now printing
    tField.setMsg("Printing poster now, please wait");  
    render_textfield = true;
    // save a PDF
    //      saveImage("output/" + timestamp()+".jpg");
    saveHiResPDF(1, "output/" + timestamp()+".pdf");
    render_printing = false;
    isPrinted = true;
  }
}

// fix this fade to black function, it's not really working.

void renderFade() {
  if (fader1.showFade) {
    if (fader1.fadeDown) {
      fader1.fadeUp();
      fader1.draw();
    }
    if (fader1.fadeUp) {
      fader1.fadeDown();
      fader1.draw();
    }
  }
}

void renderCam() {
  if (cam.available()) {
    cam.read();
  }
  if (render_cam) {
    pushMatrix();
    scale(-3, 3);
    translate(-cam.width, 0);
    image(cam, 0, 0);
    popMatrix();
  }
}

// timestamp
String timestamp() {
  Calendar now = Calendar.getInstance();
  return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", now);
}

void saveHiResPDF(int scaleFactor, String file) {
  //  PGraphics pdf = createGraphics(width*scaleFactor, height*scaleFactor, PDF, file);
  PDF pdf = new PDF(this, width*scaleFactor, height*scaleFactor, sketchPath(file));
  beginRecord(pdf);
  pdf.scale(scaleFactor);
  pdf.overPrint(true);
  renderPoster();
  endRecord();
  tField.setMsg("Poster printed");
}

void renderPoster() {
  color a = 0xAA17a1e2; // blue
  color b = 0xCC000000; // black
  color c = 0xAAc50600; // red

  if (render_poster) {
    tField.setMsg("You're poster is ready");
    render_capture = false;
    render_dither = true;
    render_scraper = true;
    //    poster_printed=true;
    if (portrait) {
      pushMatrix();
      rotate(PI);
      translate(-width,-height);
      blendMode(BLEND);
      renderFilteredImage(drawMode);
      rectMode(CORNER);
      noStroke();
      rotate(-PI/2);
      translate(-height,0);
      renderScraper();
//      translate(height/5,0);
      fill(a);
      //  blendMode(SUBTRACT);
      //    blendMode(SCREEN);
      rect(0, 850, height, 150);
      fill(b);
      rect(0, 1000, height, 12);
      fill(c);
      rect(0, 1012, height, 80);
      fill(255);
      textFont(tField.greyscaleBasic, 64);
      textAlign(RIGHT);
      text((searchName.toUpperCase()), height-margin, 990);
      /// smaller type
      // larger type
      textFont(tField.greyscaleBold, 30);
      text("> IMAGE SEARCH RESULT COUNT: "+ (scraping.resultCount), height-margin, 1050);
      textFont(tField.greyscaleBasic, 30);
      text(("> CAPTURED ON: " + timestamp()), height-margin, 1080);
      blendMode(BLEND);
      popMatrix();
    }

    fader1.showFade = false;

    if (!isPrinted) {
      println("finished printing");
      render_printing = true;
    } 
    else {
      render_printing = false;
      //    renderPrinting();
    }
    // show a scraping web progress bar
    // then check that scraper.showImages.finished is true
    // then fade up with rendered poster
    //      render_poster=true;
    // then save PDF and show msg about poster being printed 
    // then fade to black and reset
  }
}   


void controlEvent(ControlEvent theEvent) {
  if (theEvent.isAssignableFrom(Textfield.class)) {
    println("controlEvent: accessing a string from controller '"
      +theEvent.getName()+"': "
      +theEvent.getStringValue()
      );
  }
  searchName = theEvent.getStringValue();
  if (searchName.equals("") || searchName.equals(" ")) {
    searchName = "random people";
  } 
  searchName = searchName.replaceAll("\\s+", "+");
  scraping = new Scraper(searchName);

  cp5.remove(">>");
}

