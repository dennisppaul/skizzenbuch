final int mIntervalNum = 5;
final float mInterval = TWO_PI / mIntervalNum;

float mRadius = 200;
float mDotDiameter = 50;
float mAnglePrev = 0;
int mLastTriggeredInterval = 0;

void setup() {
  size(1024, 768);
  noStroke();
  fill(255);
}

void draw() {
  /* increase and wrap angle */
  float mAngle = frameCount * 0.03;
  mAngle %= TWO_PI;

  /* see if border was crossed */
  int mIntervalID_A = (int)(mAngle/(mInterval));
  int mIntervalID_B = (int)(mAnglePrev/(mInterval));
  if ( mIntervalID_A != mIntervalID_B ) {
    mLastTriggeredInterval = mIntervalID_A;
    println("EVENT " + mIntervalID_A + " != " + mIntervalID_B);
    if (mIntervalID_A < mIntervalID_B) {
      println("FLIP");
    }
  }
  mAnglePrev = mAngle;

  /* draw circles */
  background(50);
  translate(width / 2, height / 2);
  rotate(PI);
  rotate(mAngle);
  for (int i=0; i < mIntervalNum; i++) {
    float r = TWO_PI * (float) i / mIntervalNum;
    float x = sin(r) * mRadius;
    float y = cos(r) * mRadius;
    if (i == mLastTriggeredInterval) {
      circle(x, y, mDotDiameter * 2);
    } else {
      circle(x, y, mDotDiameter);
    }
  }
}
