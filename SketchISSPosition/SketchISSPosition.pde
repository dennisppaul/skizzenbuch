void setup() {
}

void draw() {
}

void keyPressed() {
  println(calculateDistance());
}

float calculateDistance() {
  /* ISS location */
  JSONObject json = loadJSONObject("http://api.open-notify.org/iss-now.json");
  float mISSLat = json.getJSONObject("iss_position").getFloat("latitude");
  float mISSLon = json.getJSONObject("iss_position").getFloat("longitude");

  /* my location (https://www.iplocation.net) */
  float mMyLat = 53.0984;
  float mMyLon = 8.7645;

  float mRadiusEarthKM = 6371;
  float mDistanceISStoEarthKM = 100;

  PVector mPositionISS = polar_to_cartesian(mISSLat, mISSLon, mRadiusEarthKM + mDistanceISStoEarthKM);
  PVector mPositionMe = polar_to_cartesian(mMyLat, mMyLon, mRadiusEarthKM);
  float mDistanceISS_Me = PVector.dist(mPositionISS, mPositionMe);

  return mDistanceISS_Me;
}

PVector polar_to_cartesian(float lat, float lon, float R) {
  // from https://stackoverflow.com/questions/1185408/converting-from-longitude-latitude-to-cartesian-coordinates
  PVector p = new PVector();
  p.x = R * cos(lat) * cos(lon);
  p.y = R * cos(lat) * sin(lon);
  p.z = R * sin(lat);
  return p;
}
