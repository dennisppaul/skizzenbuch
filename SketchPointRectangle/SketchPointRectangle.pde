Line mLine = new Line();
Rectangle mRect;

void settings() {
  size(1024, 768);
}

void setup() {
  mLine.p1.x = 50;
  mLine.p1.y = 50;
  mLine.p2.x = width - 50;
  mLine.p2.y = height - 50;

  float x = width * 0.3;
  float y = height * 0.3;
  float mWidth = width * 0.4;
  float mHeight = height * 0.4;
  mRect = new Rectangle(x, y, mWidth, mHeight);
}

void draw() {
  if (mousePressed) {
    mLine.p1.x = mouseX;
    mLine.p1.y = mouseY;
  } else {
    mLine.p2.x = mouseX;
    mLine.p2.y = mouseY;
  }
  ArrayList<PVector> mIntersectionPoints = Intersection.intersectionLineSegmentRectangle(mLine, mRect);

  /* draw */
  background(50);

  noStroke();
  fill(0, 127, 255);
  rect(mRect.position.x, mRect.position.y, mRect.dimension.x, mRect.dimension.y);

  strokeWeight(1);
  stroke(255, 127, 0);
  noFill();
  line(mLine.p1.x, mLine.p1.y, mLine.p2.x, mLine.p2.y);

  noStroke();
  fill(255, 127, 0);
  ellipse(mLine.p1.x, mLine.p1.y, 10, 10);
  ellipse(mLine.p2.x, mLine.p2.y, 10, 10);

  strokeWeight(3);
  stroke(255);
  noFill();
  for (PVector p : mIntersectionPoints) {
    ellipse(p.x, p.y, 20, 20);
  }

  if (mIntersectionPoints.size() == 2) {
    line(mIntersectionPoints.get(0).x, 
      mIntersectionPoints.get(0).y, 
      mIntersectionPoints.get(1).x, 
      mIntersectionPoints.get(1).y);
  }
}
