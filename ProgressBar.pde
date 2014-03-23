// ProgressBar Class

class ProgressBar {
int startTime; int counter; int maxTime;
boolean done;

ProgressBar(int startingTime) {
//    startTime= millis();
  startTime = startingTime;
    counter = 0;
   maxTime=int(random(2000,8001));
  done=false;

  }
  
 void display() {
    if (counter-startTime < maxTime) {
      counter=millis();
    } else {
    done=true;
    }
    fill (255,50);
    noStroke();
    rect(20,100,map(counter-startTime,0,maxTime,0,200), 19 );
    text(counter- startTime+" " + int(maxTime) +  " " + int ( map(counter-startTime,0,maxTime,0,200)), 20,160);
    noFill();
    stroke(0);
    rect(20,100,200,19);
 }
 void mousePressed () { if (done) { counter = 0; startTime= millis();
 
 maxTime=int(random(2000,8001)); done=false; } }

} 
 
 
 

