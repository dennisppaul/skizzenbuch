PVector p1 = new PVector(0, 0);
PVector p2 = new PVector(300, 300);

void settings() {
  size(640, 480, P3D);
}

void setup() {
}

void draw() {
  background(0);
  noStroke();
  p2.set(mouseX, mouseY);
  laser_line(p1, p2);
//  laser_line(p1, p2, 2, (sin(radians(frameCount*2))+1)*10 + 5, color(255, 0, 0), color(255, 0, 0, 127), color(255, 0, 0, 0));
}

void laser_line(PVector v1, PVector v2) {
  laser_line(v1, v2, 2, 10, color(255, 0, 0), color(255, 0, 0, 127), color(255, 0, 0, 0));
} 

void laser_line(PVector v1, PVector v2, 
  float pLineWidth, float pFadeScale, 
  int pColorCore, int pColorFadeInner, int pColorFadeOuter) {
  PVector d = PVector.sub(v2, v1);
  PVector c = new PVector(-d.y, d.x);
  c.normalize();
  c.mult(pLineWidth / 2);
  float mFade = pFadeScale;
  beginShape(QUADS);
  /* core */
  fill(pColorCore);
  vertex(v1.x + c.x, v1.y + c.y);
  fill(pColorCore);
  vertex(v2.x + c.x, v2.y + c.y);
  fill(pColorCore);
  vertex(v2.x - c.x, v2.y - c.y);
  fill(pColorCore);
  vertex(v1.x - c.x, v1.y - c.y);
  /* top */
  fill(pColorFadeOuter);
  vertex(v1.x + c.x * mFade, v1.y + c.y * mFade);
  fill(pColorFadeOuter);
  vertex(v2.x + c.x * mFade, v2.y + c.y * mFade);
  fill(pColorFadeInner);
  vertex(v2.x + c.x, v2.y + c.y);
  fill(pColorFadeInner);
  vertex(v1.x + c.x, v1.y + c.y);
  /* bottom */
  fill(pColorFadeOuter);
  vertex(v1.x - c.x * mFade, v1.y - c.y * mFade);
  fill(pColorFadeOuter);
  vertex(v2.x - c.x * mFade, v2.y - c.y * mFade);
  fill(pColorFadeInner);
  vertex(v2.x - c.x, v2.y - c.y);
  fill(pColorFadeInner);
  vertex(v1.x - c.x, v1.y - c.y);
  endShape();
}