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

  JSONObject json;
  //  JSONArray results;
  JSONArray results = new JSONArray();
  JSONArray responseData;
  JSONObject cursor;
  String resultCount;
  boolean finished;

  float num = numberOfImages/4;
  int numberofQueries = ceil(num);

  Scraper(String searchName) {
    //    println("passed the name " + searchName);
    // maybe we could add the location dynamically to the search query?

    scrapeGoogle(searchName);
  }

  void scrapeGoogle(String searchName) {
    searchName = searchName.replaceAll("\\s+", "+"); 

    //    println("searching google with the name " + searchName);

    // this function should load the JSON from Google once and store it in an JSONArray called results
    // then the showImages function can loop through that JSONArray and display images & text

    for (int j = 0; j < numberOfImages; j = j+4) {
      //print ("j = " + j);
      JSONArray newResults = new JSONArray();
      // could add +vancouver into search query for local results
      json = loadJSONObject("http://moves.haigarmen.com/gimages.php?name="+ searchName +"+vancouver&page="+j);
      JSONObject responseData = json.getJSONObject("responseData");
      newResults = responseData.getJSONArray("results");
      cursor = responseData.getJSONObject("cursor");
      resultCount = cursor.getString("resultCount");
      for (int k =0 ; k< newResults.size(); k++) {
        results.append(newResults.getJSONObject(k));
      }
    }
    //    println("resultsCount: "+resultCount);
    //    println(results);

    //    drawMode = int(random(1,8));
    //    drawMode = int(random(2, (int(resultCount)/3000)));
    drawMode = 1;
    println("drawMode is " + drawMode);
    render_countdown = true;
    timer = new Timer(5000);
    timer.start();
  }

  void showImages() {
    int oldX=0;
    //    println("JSON results size is: " + results.size());
    for (int i = 0; i < results.size(); i++) {
      JSONObject images = results.getJSONObject(i); 
      String title = images.getString("titleNoFormatting");
      String image = images.getString("url");
      try {
        String testImage = image.toLowerCase();
        if ( testImage.endsWith("jpg") || testImage.endsWith("gif") || testImage.endsWith("tga") || testImage.endsWith("png")) {
          photo = loadImage(image);
        }
      }
      catch (Exception e) {
        photo = null;
      }
      if ((photo != null) || (photo.width != -1)) {
        fill(203);
        textSize(14);
        text(title, width-100, 100 + (20*i));

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
      if (!poster_printed) {
        render_printing = true;
      }
    }
  }
}

