
float mRadius = 150;
float mRotation = 0;
ArrayList<PVector> mPoints = new ArrayList<PVector>();

void settings() {
  size(1024, 768, P3D);
}

void setup() {
  hint(DISABLE_DEPTH_TEST);
  noFill();
}

void draw() {
  background(50);
  translate(width/2, height/2);

  stroke(255, 127, 0);
  strokeWeight(8);
  ellipse(0, 0, mRadius*2 + 16, mRadius*2 + 16);
  strokeWeight(1);

  mRotation += 1.0f / frameRate;
  rotateX(sin(mRotation * 0.5) * PI);
  rotateZ(cos(mRotation * 0.33) * PI);

  for (int i=0; i < 10; i++) {
    float x = random(-mRadius, mRadius);
    float y = random(-mRadius, mRadius);
    float z = random(-mRadius, mRadius);
    if (inSphere(x, y, z, mRadius)) {
      PVector p = new PVector();
      p.set(x, y, z);
      mPoints.add(p);
    }
  }

  stroke(255, 7);
  if (mPoints.size() > 1) {
    for (int i = 0; i < mPoints.size() - 1; i++) {
      PVector p1 = mPoints.get(i);
      PVector p2 = mPoints.get(i+1);
      line(p1.x, p1.y, p1.z, p2.x, p2.y, p2.z);
    }
  }

  //for (int i = 0; i < mPoints.size(); i++) {
  //  PVector p1 = mPoints.get(i);
  //  point(p1.x, p1.y, p1.z);
  //}
}

boolean inSphere(float x, float y, float z, float r) {
  return (x * x + y * y + z * z) - r * r < 0;
}
