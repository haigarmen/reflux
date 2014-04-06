//  Title: Scraper
//  Description: A class that handles the web scraping with a JSON object

class Scraper {
  String source = null;
  PImage photo, maskImage, photoCropped;
  int photoWidth, photoHeight;
  int cropSize = 60;
  int imagePadding = 0;
  int numberOfImages = 20;
  int imagesPerRow = 10;
  int numberOfRows = numberOfImages/imagesPerRow;
  int topMargin = 700;
  boolean isFinished;
  JSONObject json;
  //  JSONArray results;
  JSONArray results = new JSONArray();
  JSONArray responseData;
  JSONObject cursor;
  String resultCount;
  int noImagesFound;
  float num = numberOfImages/4;
  int numberofQueries = ceil(num);

  Scraper(String searchName) {
    //    println("passed the name " + searchName);
    // maybe we could add the location dynamically to the search query?
    searchName = searchName.replaceAll("\\s+", "+");
    scrapeGoogle(searchName);
  }
  void scrapeGoogle(String searchName) {
    searchName = searchName.replaceAll("\\s+", "+"); 
    // this function should load the JSON from Google once and store it in an JSONArray called results
    for (int j = 0; j < numberOfImages; j = j+4) {
      //print ("j = " + j);
      JSONArray newResults = new JSONArray();
      // could add +vancouver into search query for local results
      json = loadJSONObject("http://moves.haigarmen.com/gimages.php?name="+ searchName +"+vancouver&page="+j);
      JSONObject responseData = json.getJSONObject("responseData");
      newResults = responseData.getJSONArray("results");
      cursor = responseData.getJSONObject("cursor");
      resultCount = cursor.getString("resultCount");
      resultCount = trim(resultCount);
      resultCount = resultCount.replaceAll(",", "");
      noImagesFound = Integer.valueOf(resultCount).intValue();
      for (int k =0 ; k< newResults.size(); k++) {
        results.append(newResults.getJSONObject(k));
      }
    }
    //    println("resultsCount: "+resultCount);
    //    println(results);

    //    drawMode = int(random(1,8));
      drawMode = ceil(noImagesFound/2500);
      drawMode = int(random(drawMode));
      if (drawMode > 8 || drawMode < 1) {
        drawMode = 4;
      }
//    drawMode = 1;
    println("noImagesFound is " + noImagesFound);
    println("drawMode is " + drawMode);
    render_countdown = true;
    timer = new Timer(5000);
    timer.start();
  }

// then the showImages function can loop through that JSONArray and display images & text
  void showImages() {
    int oldX=0;
    //    println("JSON results size is: " + results.size());
    for (int i = 0; i < results.size(); i++) {
      JSONObject images = results.getJSONObject(i); 
      String title = images.getString("titleNoFormatting");
      String image = images.getString("unescapedUrl");
      try {
        String testImage = image.toLowerCase();
        if ( testImage.endsWith("jpg") || testImage.endsWith("gif") || testImage.endsWith("tga") || testImage.endsWith("png")) {
          photo = loadImage(image);
          // photo = requestImage(image); //this might be worth a try
        }
      }
      catch (Exception e) {
        photo = null;
      }
      if ((photo != null)) {
        textAlign(RIGHT);
        fill(203);
        textSize(14);
        text(title, width-60, 150 + (20*i));

        photoWidth = photo.width;
        photoHeight = photo.height;
        float ratio = float(photoWidth) / float(photoHeight);
        int cropWidth = int(cropSize * ratio);

        int newX = cropWidth + oldX+imagePadding;
        int newY = topMargin+(numberOfRows * int(float(cropSize+imagePadding)/4));
        if (photoWidth > photoHeight) {
          //          copy(photo, (photoWidth-photoHeight)/2, 0, photoHeight, photoHeight, newX, newY, cropSize, cropSize);
          image(photo, newX, newY, cropWidth, cropSize);
          oldX = newX;
        } 
        else if ((photoHeight > photoWidth) || (photoHeight == photoWidth)) {
          //          copy(photo, 0, (photoHeight-photoWidth)/2, photoWidth, photoWidth, newX, newY, cropSize, cropSize);
          image(photo, newX, newY, cropWidth, cropSize);
          oldX = newX;
        } 
        else {
          println("Garbage image");
        }
        //        println(title + ", " + image + ", i="+i + ", j=" +numberOfRows);
      }
      //    println("finished is set to true");
      isFinished = true;
    }
  }
}

