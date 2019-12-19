var TYPE_HOUR = 0;
var TYPE_MINUTE = 1;
var TYPE_SECOND = 2;
var TIME_BASE_HOUR = 24.0;
var TIME_BASE_MIN_SEC = 60.0;

function setup() {
    createCanvas(640, 480);
  colorMode(HSB, 1.0, 1.0, 1.0);
  noStroke();
}

function draw() {
  background(0.0, 0.0, 0.2);
  drawClockCircle(TYPE_SECOND, 400);
  drawClockCircle(TYPE_MINUTE, 350);
  drawClockCircle(TYPE_HOUR, 300);

  fill(0.0, 0.0, 0.2);
  ellipse(width / 2, height / 2, 250, 250);
}

function drawClockCircle(mType, mCircleDiameter) {
  var mTime = 0.0;
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
