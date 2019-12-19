ColorClockCircle mHour;
ColorClockCircle mMinute;
ColorClockCircle mSecond;

void setup() {
  colorMode(HSB, 1.0, 1.0, 1.0);
  size(640, 480);
  noStroke();
  mHour = new ColorClockCircle(ColorClockCircle.TYPE_HOUR, 300);
  mMinute = new ColorClockCircle(ColorClockCircle.TYPE_MINUTE, 350);
  mSecond = new ColorClockCircle(ColorClockCircle.TYPE_SECOND, 400);
}

void draw() {
  background(0.0, 0.0, 0.2);
  mSecond.draw();
  mMinute.draw();
  mHour.draw();

  fill(0.0, 0.0, 0.2);
  ellipse(width / 2, height / 2, 250, 250);
}

class ColorClockCircle {
  final static int TYPE_HOUR = 0;
  final static int TYPE_MINUTE = 1;
  final static int TYPE_SECOND = 2;
  final static float TIME_BASE_HOUR = 24;
  final static float TIME_BASE_MIN_SEC = 60;
  final float mCircleDiameter;
  final int mType;

  float mTime = 0;

  ColorClockCircle(int pType, float pCircleDiameter) {
    mType = pType;
    mCircleDiameter = pCircleDiameter;
  }

  void draw() {
    switch(mType) {
    case TYPE_HOUR:
      mTime = hour();
      mTime /= TIME_BASE_HOUR;
      break;
    case TYPE_MINUTE:
      mTime = minute();
      mTime /= TIME_BASE_MIN_SEC;
      break;
    case TYPE_SECOND:
      mTime = second();
      mTime /= TIME_BASE_MIN_SEC;
      break;
    }
    fill(mTime, 1.0, 1.0);
    ellipse(width / 2, height / 2, mCircleDiameter, mCircleDiameter);
  }
}
