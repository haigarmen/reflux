<!-- AIzaSyC6MWX7knQ08LRTFQGPuFQzcJzSv21Hfe8 -->

<?php
$name = $_GET["name"];
$page = $_GET["page"];
$name = str_replace(' ', '%20', $name);

$url = "https://ajax.googleapis.com/ajax/services/search/images?" .
       "v=1.0&q=". $name.
"&userip=INSERT-USER-IP"."&start=".$page;

// sendRequest
// note how referer is set manually
$ch = curl_init();
curl_setopt($ch, CURLOPT_URL, $url);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
curl_setopt($ch, CURLOPT_REFERER, "http://moves.haigarmen.com");
$body = curl_exec($ch);
curl_close($ch);

$json = json_decode($body);
// now, process the JSON string

/*
    echo('<ul ID="resultList">');
    foreach($json->responseData->results as $value)
    {


echo('<div id="picture">');
echo('<a href="' . $value->unescapedUrl. '">');
echo('<img src="' . $value->unescapedUrl. '"></a>');
// echo ('<br/><div class="check"><input type="checkbox"  id="check22" value="' . $value->MediaUrl . '">Check</div>');
echo ('</div>');
$count++;
}
echo("</div>");
*/

// now have some fun with the results...
echo $body;
//echo json_encode($json);

?>
