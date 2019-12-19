void settings() {
  size(640, 480);
}

void setup() {
}

void draw() {
  background(255);
  stroke(0);
  noFill();

  float mRadius = 100;
  PVector mCenter = new PVector(width/2, height/2);
  for (float r=0; r < TWO_PI; r+=TWO_PI/100) {
    float x = sin(r) * mRadius + mCenter.x;
    float y = cos(r) * mRadius + mCenter.y;
    point(x, y);
  }
}