import processing.pdf.*;
import java.util.Calendar;
import processing.video.*;

boolean savePDF = false;
PImage capture_img;

int video_width;
int video_height;

boolean render_cam;
boolean render_capture;
boolean render_textfield;
boolean app_saving;
boolean render_showimage;
boolean render_dither;
boolean render_halftone;
boolean render_halftoneSq;
boolean render_maze;
boolean render_digits;
 
  // not sure if we need this array of filter types to reference the filter functions
 String [] filterList = { 
  "showImage", "halftone", "halftoneSq", "maze", "digits", "charactersLower", "charactersUpper"
};

TextField tField;

Ditherer img;
int gridSize = 10;
int drawMode = 0;

String folder_path  = "output/";
String file_format  = ".jpg";
int TIMER_DURATION = 1500;

// A variable for the frame we grab from the webcam
Capture cam;

void setup() {
  size(640, 500);
  smooth();

  video_width = 640;
  video_height = 480;
  render_cam = true;
  render_textfield = true;
  app_saving = false;


  //get a list of available camera modes and list them
  String[] cameras = Capture.list();

  if (cameras.length == 0) {
    //    println("There are no cameras available for capture.");
    exit();
  } 
  else {
    //    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println(cameras[i]);
    }
    // The camera can be initialized directly using an 
    // element from the array returned by list():
    cam = new Capture(this, video_width, video_height, "FaceTime HD Camera"); 
    cam.start();

    capture_img = new PImage(video_width, video_height);
  }
  tField = new TextField("Press the c key to capture image.", width/2, 496, 18, 255);

  background(255);
  PFont.list();
}

void draw() {
  background(255);
  renderCam();
  renderCapture();
  // render different ditherers
  renderFilteredImage(drawMode);  
  renderTextField();

  }

//wrap any of these in a beginRecord() and endRecord() to save as pdf.

void keyPressed() {
  switch(key) {
  case 'c':
    captureCam();
    render_capture = false;
    render_dither = true;
    render_showimage = true;
    drawMode = 1;
    img = new Ditherer(capture_img,1);
    break;
  case 's':
    if (render_dither) {
      saveImage("output/" + timestamp()+".jpg");
    }
    break;
  case 'p':
    if (render_dither) {
      saveHiResPDF(1, "output/" + timestamp()+".pdf");
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
      gridSize++;
      println("gridSize is " + gridSize);
    }
    if (keyCode == DOWN) {
      if (gridSize > 2) {
        gridSize--;
        println("gridSize is " + gridSize);
      }
    }
  }
}



void captureCam() {
  if (render_capture) {
    return;
  }
  println("capture image");
  capture_img = cam.get();
  render_cam = false;
  cam.stop();
  render_capture = true;
  tField.setMsg("Press 's' key to save, Press 'v' key to return to video.");
}

void saveImage(String filename) {
  if (app_saving) {
    return;
  }
  println("save image");

  tField.setMsg("SAVING...");
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
  render_capture = false;
  render_dither = false;

  cam.start();
  render_cam = true;
}

void renderCapture() {
  if (render_capture) {
    image(capture_img, 0, 0);
  }
}


void renderFilteredImage(int drawMode) {
  if (render_dither) {
    img.filterImage(drawMode);
    println("drawing filteredImage again");
  }
};

void renderTextField() {
  if (render_textfield) {
    tField.display();
  }
}
void renderCam() {
  if (cam.available()) {
    cam.read();
  }
  if (render_cam) {
    image(cam, 0, 0);
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
  renderFilteredImage(drawMode);
  endRecord();
}

