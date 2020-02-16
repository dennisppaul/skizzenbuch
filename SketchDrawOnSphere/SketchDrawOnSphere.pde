/**
 *
 * converting spherical coordinate system to 3D euclidean space
 *
 * x = r × sin(theta) × cos(phi)
 * y = r × sin(theta) × sin(phi)
 * z = r × cos(theta)
 *
 */

ArrayList<PVector> mLines = new ArrayList();
private float mRadius = 150;
private float mTheta = 0;
private float mPhi = 0;

void settings() {
  size(1024, 768, P3D);
}

void setup() {
  hint(DISABLE_DEPTH_TEST);
  noFill();
}

void draw() {

  for (int i=0; i<30; i++) {
    spawn_line();
  }

  background(50);

  translate(width / 2, height / 2);

  stroke(0, 127, 255);
  strokeWeight(8);
  ellipse(0, 0, mRadius*2 + 16, mRadius*2 + 16);
  strokeWeight(1);

  rotateX(frameCount * 0.001f);
  rotateY(frameCount * 0.0003f);

  stroke(255, 7);
  beginShape(LINE_STRIP);
  for (PVector v : mLines) {
    vertex(v.x, v.y, v.z);
  }
  endShape();
}

void spawn_line() {
  final float mOffset = 0.1f;
  mTheta += random(-mOffset, mOffset);
  mPhi += random(-mOffset, mOffset);
  PVector p = convertSphericalTo3D(mRadius, mTheta, mPhi);
  mLines.add(p);
}

PVector convertSphericalTo3D(float pRadius, float pTheta, float pPhi) {
  PVector p = new PVector();
  p.x = pRadius * sin(pTheta) * cos(pPhi);
  p.y = pRadius * sin(pTheta) * sin(pPhi);
  p.z = pRadius * cos(pTheta);
  return p;
}
