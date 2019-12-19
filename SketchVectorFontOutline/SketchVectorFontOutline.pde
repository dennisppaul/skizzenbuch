import de.hfkbremen.mesh.*; 

VectorFont mPathCreator;

void settings() {
  size(640, 480, P3D);
}

void setup() {
  mPathCreator = new VectorFont("DINMittelschrift-1Line", 60);
}

void draw() {
  ArrayList<PVector> mVertices = mPathCreator.outline("Gemeinsame Sachen");
  background(255);
  noFill();
  stroke(0);
  translate(50, height - 75);
  beginShape();
  for (int i = 0; i < mVertices.size(); i++) {
    PVector p = mVertices.get(i);
    float mOffsetX = ( 24.0 * mouseX ) / width;
    float mOffsetY = ( 24.0 * mouseY ) / height;
    float r = radians(i * 2 + frameCount * 3);
    p.x += sin(r) * mOffsetX;
    p.y += cos(r) * mOffsetY;
    float mRadius = 1.5;
    vertex(p.x, p.y, mRadius * 2, mRadius * 2);
  }
  endShape();
}
