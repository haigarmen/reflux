//  Title: Scraper
//  Description: A class that handles the web scraping with a JSON object

class Scraper {
  PImage photo, maskImage, photoCropped;
  int photoWidth, photoHeight;
  float ratio;
  int cropSize = 100;
  int imagePadding = 5;
  int numberOfImages = 20;
  int numberOfRows = numberOfImages/10;

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
    render_countdown = true;
    timer = new Timer(5000);
    timer.start();
  }

  void showImages() {
    println("JSON results size is: " + results.size());
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
      if ((photo != null) || (photo.width <= -1) ) { 
        photoWidth = photo.width;
        photoHeight = photo.height;
        ratio = float(photoWidth) / float(photoHeight);

        int newX = ((cropSize+imagePadding) * i)+imagePadding;
        int newY = (numberOfRows * int(float(cropSize+imagePadding)/4));
        if (photoWidth > photoHeight) {
          
//          copy(photo, (photoWidth-photoHeight)/2, 0, photoHeight, photoHeight, newX, newY, cropSize, cropSize);
          image(photo, newX, newY, cropSize, cropSize);
        } 
        else if ((photoHeight > photoWidth) || (photoHeight == photoWidth)) {
//          copy(photo, 0, (photoHeight-photoWidth)/2, photoWidth, photoWidth, newX, newY, cropSize, cropSize);
          image(photo, newX, newY, cropSize, cropSize);
        } 
        else {
          println("Garbage image");
        }
        fill(203);
        textSize(14);
        text(title, 500, 100 + (20  * (i+i) ));
        println(title + ", " + image + ", i="+i + ", j=" +numberOfRows);
      }
//    println("finished is set to true");
    if (!poster_printed) {
    render_printing = true;
    }
    }
  }
}

