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
// 2. copy image function doesn't work for PDF output
//      a. resize images and see if that PDFs or b. convert images to vectors via ditherer class)

// 3. countdown doesn't show (fixed)
// 4. printing doesn't reset to Cam - Solved - not quite
// 5. capture should go to printing (without break)
// 6. fix the halftone dot density in Ditherer


import processing.pdf.*;
import java.util.Calendar;
import processing.video.*;
import controlP5.*;

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
boolean render_scraper;
boolean render_progress;
boolean render_poster;
boolean render_countdown;
boolean render_printing;
//boolean render_fadeblack;
//boolean render_fadefromblack;


boolean timeUp = false;
ControlP5 cp5;

TextField tField;

Ditherer img;
//int gridSize = 10;
int drawMode = 1;

String folder_path  = "output/";
String file_format  = ".jpg";

ProgressBar progBar;
Fader fader1;

// A variable for the frame we grab from the webcam
Capture cam;

Scraper scraping;
String searchName = "haig armen";


Timer timer;
int startTime = millis();

boolean sketchFullScreen() {
  return true;
}


void setup() {
  frame.setBackground(new java.awt.Color(0, 0, 0));
  //  size(1280, 960);
//  size(1024, 768);
  size(1920, 1440);
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
//    cam = new Capture(this, video_width, video_height, "FaceTime HD Camera");
      cam = new Capture(this, video_width, video_height, "Built-in iSight");
    cam.start();
  }
  tField = new TextField("Enter your full name and press ENTER", width/2, int(height*.8), 30, 255);

  //  PFont.list();
  //  progBar = new ProgressBar(4000);

  fader1 = new Fader(startTime+2000);
  fader1.showFade = true;
  fader1.fadeDown = true;
}

void draw() {
  background(255);
  renderCam();
  renderCapture();
  renderPoster();
  renderPrinting();
  renderFade();
  renderTextField();
  renderNameField();
  renderCountdown();
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
      render_poster = true;
      render_printing = true;
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
  tField.setMsg("Press 's' key to save, Press 'v' key to return to video.");
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
    tField.display();
  }
}

void renderNameField() {
  if (render_namefield) {
    //    println("rendering name textfield");
    cp5.addTextfield(">>")
      .setPosition(340, height*.65)
        .setSize(600, 100)
          .setFont(tField.greyscaleBasic)
            .setFocus(true)
              .setColor(color(203))
                ;
    textFont(tField.greyscaleBasic);
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
    rect(width*.65, height*.85, 100, 130);
    textSize(120);
    fill(255);
    text(countDown, width*.65, height*.85);
    // then show progress bar while
    // downloading images, displaying filtering image, scrap images and text   
    // save PDF, show "your poster is printing, it will take a few mins"
    if (timer.isFinished()) {
      //      println("timer finished");
      // when timer finished capture cam image
      captureCam();
      render_capture = true;
      render_countdown = false;
      tField.setMsg("Scraping the web for the name " + searchName);
      // fade down to black first
      startTime = millis();
      fader1 = new Fader(startTime);      
      fader1.showFade = true;
      fader1.fadeUp = true;
    }
  }
}

void renderPrinting() {
  if (render_printing) {
    // display a message that poster is now printing
    tField.setMsg("Printing poster now, please wait");  
    render_textfield = true;
    // save a PDF
    if (fader1.posterNow) {
      saveImage("output/" + timestamp()+".jpg");
      saveHiResPDF(1, "output/" + timestamp()+".pdf");
    }
    // wait for 5 seconds

    //
    render_capture = false;
    render_dither = false;
    render_countdown = false;
    render_printing = false;
    render_poster = false;
    render_cam = false;
    fader1.posterNow = false;

    restartCam();
    tField.setMsg("Press the 'c' key to capture image.");
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
  PGraphics pdf = createGraphics(width*scaleFactor, height*scaleFactor, PDF, file);
  beginRecord(pdf);
  pdf.scale(scaleFactor);
  renderPoster();
  endRecord();
}

void renderPoster() {
  color a = 0xCC17a1e2; // blue
  color b = 0xCC000000; // black
  color c = 0xAAc50600; // red

  if (fader1.posterNow) {
    println("rendering poster now");
    render_capture = false;
    render_dither = true;
    render_scraper = true;
    blendMode(BLEND);
    renderFilteredImage(drawMode);
    rectMode(CORNER);
    noStroke();
    fill(a);
    //  blendMode(SUBTRACT);
    rect(0, 440, width, 160);
    fill(b);
    rect(0, 600, width, 16);
    fill(c);
    rect(0, 616, width, 80);
    fill(255);
    textFont(tField.greyscaleBasic, 120);
    textAlign(RIGHT);
    text((searchName.toUpperCase()), width-20, 570);
    /// smaller type
    text("Search Result Count: ", width-20, 470);
    // larger type
    text((scraping.resultCount), width-20, 500);
    blendMode(BLEND);
    renderScraper();
    startPrinting();
      // show a scraping web progress bar
      // then check that scraper.showImages.finished is true
      // then fade up with rendered poster
      //      render_poster=true;
      // then save PDF and show msg about poster being printed 
      // then fade to black and reset

    
  }
}   

void startPrinting() {
    if (scraping.finished) {
      println("printing time");
      render_printing = true;

      // fade down to black first
      startTime = millis();
      fader1 = new Fader(startTime);      
      fader1.showFade = true;
      fader1.fadeUp = true;
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

