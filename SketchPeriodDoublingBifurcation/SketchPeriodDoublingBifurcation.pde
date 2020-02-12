EventProducer mEventProducer;

ArrayList<PVector> mPoints = new ArrayList<PVector>();
float mCurrentX;
float mCurrentY;
float mStartValue = 0.0;
float mStepSize = 0.05;
float r = 1.0;

final float mPadding = 10;

void settings() {
  size(1024, 768, P3D);
}

void setup() {
  textFont(createFont("Roboto Mono", 11));
  mEventProducer = new EventProducer(this, "process_step");
  mCurrentY = mStartValue;
}

void draw() {
  mEventProducer.update(1.0 / frameRate);
  mEventProducer.interval(0.1);

  background(50);
  if (Float.isInfinite(mCurrentY)) {
    fill(255, 0, 0);
  } else {
    fill(255);
  }
  text("R: " + r + (Float.isInfinite(mCurrentY) ? " (INFINITE)" : ""), 20, 30);

  translate(mPadding, height/2);

  noFill();
  stroke(255);
  beginShape(POINTS);
  for (PVector p : mPoints) {
    vertex(p.x, p.y * 200);
  }
  endShape();
}

void process_step() {
  mCurrentX += mStepSize;
  mCurrentY = step(mCurrentY);
  mPoints.add(new PVector(mCurrentX, mCurrentY));
}

float step(float x) {
  /* watching https://www.youtube.com/watch?v=ovJcsL7vyrk */
  return r+x*x; // mandelbrot set
  //return r*x*(1.0-x); // logistic map
}

void reset() {
  mCurrentX = 0;
  mCurrentY = mStartValue;
  mPoints.clear();

  for (int i=0; i<(width-mPadding*2)*(1/mStepSize); i++) {
    process_step();
  }
}

void mouseMoved() {
  r = ((float)mouseX/(float)width - 0.5) * 10;
  println("r: " + r);
  reset();
}
