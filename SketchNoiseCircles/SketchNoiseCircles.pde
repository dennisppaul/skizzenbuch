float t;

void setup() {
  size(1024, 768, P3D);
}

void draw() {
  t += 0.01;

  background(50);
  translate(width/2, height/2);

  stroke(255, 63);
  noFill();
  final int mShapes = 300;
  final float mSpacing = 1.5;
  for (int i=0; i<mShapes; i++) {
    final float mRadius = 100 + mSpacing * i + sin(t * 2 + i / (float)mShapes) * 20;
    final float mOffset = i * 0.05;
    beginShape();
    for (float r=0; r<TWO_PI; r+=TWO_PI/180) {
      float x = sin(r) * mRadius * noise(r + t + mOffset);
      float y = cos(r) * mRadius * noise(r + t + mOffset * (i / (float)mShapes));
      vertex(x, y);
    }
    endShape(CLOSE);
  }
}
