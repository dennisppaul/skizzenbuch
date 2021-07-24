float mDirection;
float mSpeed;
String mPlaceName = "";

void setup() {
    size(1024, 768);
    loadData("Bremen");
    textFont(createFont("Helvetica-Bold", 96));
    textAlign(CENTER);
}

void draw() {
    background(50);
    fill(255);
    text(mPlaceName, width/2, height/2);

    translate(width/2, height/2);
    rotate(radians(mDirection));
    float mScaledWidth = 1 + mSpeed * 0.5;
    scale(mScaledWidth);
    strokeWeight(10/mScaledWidth);
    stroke(0,127,255);
    drawArrow(1/mScaledWidth);
    strokeWeight(4/mScaledWidth);
    stroke(0,91,255);
    drawArrow(1/mScaledWidth);
}

void keyPressed() {
    switch(key) {
    case '1':
        loadData("Bremen");
        break;
    case '2':
        loadData("Peking");
        break;
    case '3':
        loadData("New York");
        break;
    case '4':
        loadData("Berlin");
        break;
    }
}

void drawArrow(float pScale) {
    final float mTip = 10 * pScale;
    final float mLength = 50;
    line(0, 0, 0, mLength);
    line(0, mLength, mTip, mLength-mTip);
    line(0, mLength, -mTip, mLength-mTip);
}

void loadData(String pLocation) {
    JSONObject json = loadJSONObject("http://api.openweathermap.org/data/2.5/weather?q="+pLocation+"&appid=acfe397231ca8b0826c0a2eddb73744f");
    println(json);

    mPlaceName = json.getString("name");

    JSONObject mWind = json.getJSONObject("wind");
    mDirection = mWind.getFloat("deg");
    mSpeed = mWind.getFloat("speed");

    //JSONArray mWeather = json.getJSONArray("weather");
    //println(mWeather);
}

//{
//  "visibility": 10000,
//  "timezone": 7200,
//  "main": {
//    "temp": 289.45,
//    "temp_min": 287.65,
//    "humidity": 73,
//    "pressure": 1020,
//    "feels_like": 289.04,
//    "temp_max": 290.04
//  },
//  "clouds": {"all": 0},
//  "sys": {
//    "country": "DE",
//    "sunrise": 1626924402,
//    "sunset": 1626982523,
//    "id": 1281,
//    "type": 1
//  },
//  "dt": 1626983632,
//  "coord": {
//    "lon": 8.8078,
//    "lat": 53.0752
//  },
//  "weather": [{
//    "icon": "01n",
//    "description": "clear sky",
//    "main": "Clear",
//    "id": 800
//  }],
//  "name": "Bremen",
//  "cod": 200,
//  "id": 2944388,
//  "base": "stations",
//  "wind": {
//    "deg": 350,
//    "speed": 4.12
//  }
//}
