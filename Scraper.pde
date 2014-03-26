//  Title: Scraper
//  Description: A class that handles the web scraping with a JSON object

class Scraper {
  PImage photo, maskImage, photoCropped;
  int photoWidth, photoHeight;
  float ratio;
  int cropSize = 100;
  int imagePadding = 5;
  int numberOfImages = 20;
  JSONObject json;
//  JSONArray results;
  JSONArray results = new JSONArray();
  JSONArray responseData;
  float num = numberOfImages/4;
  int numberofQueries = ceil(num);

  Scraper(String searchName) {
    println("passed the name " + searchName);
    // maybe we could add the location dynamically to the search query?

    scrapeGoogle(searchName);
  }

  void scrapeGoogle(String searchName) {
    searchName = searchName.replaceAll("\\s+", "+"); 
    
    println("searching google with the name " + searchName);

    // this function should load the JSON from Goolge once and store it in an JSONArray called results
    // then the showImages function can loop through that JSONArray and display images & text

    for (int j = 0; j < numberOfImages; j = j+4) {
      //print ("j = " + j);
      JSONArray newResults = new JSONArray();

      json = loadJSONObject("http://moves.haigarmen.com/gimages.php?name="+ searchName +"+vancouver&page="+j);
      JSONObject responseData = json.getJSONObject("responseData");
      newResults = responseData.getJSONArray("results");

      for (int k =0 ; k< newResults.size(); k++) {
        results.append(newResults.getJSONObject(k));
      }
    }
    println(results);

  }

  void showImages() {
//println("JSON results size is: " + results.size());
      for (int i = 0; i < results.size(); i++) {
        JSONObject images = results.getJSONObject(i); 
        String title = images.getString("titleNoFormatting");
        String image = images.getString("unescapedUrl");
        try {
          photo = loadImage(image);
        }
        catch (Exception e) {
          photo = null;
        }

        if (photo != null) { 
          photoWidth = photo.width;
          photoHeight = photo.height;
          ratio = float(photoWidth) / float(photoHeight);

          if (photoWidth > photoHeight) {
            copy(photo, (photoWidth-photoHeight)/2, 0, photoHeight, photoHeight, ((cropSize+imagePadding) * i)+imagePadding, (i * int(float(cropSize+imagePadding)/4)), cropSize, cropSize);
          } 
          else {
            copy(photo, 0, (photoHeight-photoWidth)/2, photoWidth, photoWidth, ((cropSize+imagePadding) * i)+imagePadding, (i * int(float(cropSize+imagePadding)/4)), cropSize, cropSize);
          }
          fill(203);

          text(title, 500, 100 + (20  * (i+i) ));
//          println(title + ", " + image + "i="+i + ", j=" +j);
        }
      }
  }
}

