JSONArray values;

void setup() {
  // https://api.thedynamicarchive.net/sites/default/files/styles/medium/public/component/9/images/arrow.png?itok=DVhx76Yp
  for (int j = 0; j < 10; j++) {
    values = loadJSONArray("https://api.thedynamicarchive.net/REST/component/" + j + "?_format=json");
    for (int i = 0; i < values.size(); i++) {
      JSONObject a = values.getJSONObject(i); 
      println(a);
    }
  }
}
