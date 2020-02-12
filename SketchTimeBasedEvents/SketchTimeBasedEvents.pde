float mEventCounter = 0.0;
float mEventInterval = 1.0;
color mBoxFillColor = color(255);
color mBoxStrokeColor = color(255);

void settings() {
  size(1024, 768);
}

void setup() {
  strokeWeight(15.0);
  strokeJoin(MITER);
}

void draw() {
  background(50);

  float mIntervalDuration = mEventCounter / mEventInterval;
  noStroke();
  fill(mBoxFillColor);
  rect(width/4, height/4, width/2 * mIntervalDuration, height/2);

  noFill();
  stroke(255);
  rect(width/4, height/4, width/2, height/2);

  mEventCounter += 1.0 / frameRate;
  if (mEventCounter > mEventInterval) {
    while (mEventCounter > mEventInterval) {
      mEventCounter -= mEventInterval;
    }
    change_box_fill_color();
  }
}

void change_box_fill_color() {
  int r = round(random(0, 2)) * 127;
  int g = (r + 127) % 255;
  int b = (g + 127) % 255;
  mBoxFillColor = color(r, g, b);
}

void mousePressed() {
  mEventInterval = 1.0 + 2.0 * (float)mouseX/(float)width;
  mEventCounter = 0.0;
}
