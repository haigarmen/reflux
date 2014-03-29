class Timer { 
  int savedTime; // When Timer started
  int totalTime; // How long Timer should last
  int countDown; // time left
  int passedTime;
  
  Timer(int _TotalTime) {
    totalTime = _TotalTime;
    countDown = int((totalTime - passedTime)/1000);
  }
  
  // Starting the timer
  void start() {
    // When the timer starts it stores the current time in milliseconds.
    savedTime = millis(); 
    println("timer start at" + savedTime);
  }
 
  
  // The function isFinished() returns true if 5,000 ms have passed. 
  // The work of the timer is farmed out to this method.
  boolean isFinished() { 
    // Check how much time has passed
    passedTime = millis()- savedTime;
    if (passedTime > totalTime) {
      return true;
    } else {
      return false;
    }
   }
   
 }
