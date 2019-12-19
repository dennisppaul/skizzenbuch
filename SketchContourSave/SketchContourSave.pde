import gab.opencv.*;
import processing.video.*;

float mTimerInterval = 1.5;
float mTimerCounter = 0;

Capture video;
OpenCV opencv;

PImage mImageP1;
PImage mImageP2;
PImage mImageP3;

ArrayList<Contour> contours;

void setup() {
  size(1280, 480);

  // initialize Capture object
  video = new Capture(this, 640, 480);

  // Start the capturing process
  video.start();
  opencv = new OpenCV(this, 640, 480);
}

void draw() {
  /* timer event */
  float mDeltaTime = 1.0 / frameRate;
  mTimerCounter += mDeltaTime;
  if (mTimerCounter > mTimerInterval) {
    mTimerCounter = 0;
    captureEvent();
  }

  /* drawing */
  background(255);
  if ( mImageP1 != null) {
    image(mImageP1, 0, 0, width/3, height);
  }
  if ( mImageP2 != null) {
    image(mImageP2, width/3, 0, width/3, height);
  }
  if ( mImageP3 != null) {
    image(mImageP3, 2*width/3, 0, width/3, height);
  }

  if ( contours != null) {
    noFill();
    pushMatrix();
    translate(2*width/3, 0);
    scale((float(width)/3.0)/float(video.width), 1.0);
    for (Contour contour : contours) {
      stroke(255, 0, 0);
      contour.draw();
      stroke(0, 255, 0);
      beginShape();
      for (PVector point : contour.getPolygonApproximation().getPoints()) {
        vertex(point.x, point.y);
      }
      endShape();
    }
    popMatrix();
  }

  /* debug draw video */
  image(video, 0, 0, 160, 120);
}

void captureEvent() {
  // p1 -- get latest video image
  mImageP1 = video.copy();

  // p2 -- process p1 ( find contours )
  opencv.loadImage(video);
  opencv.gray();
  opencv.threshold(70);
  mImageP2 = opencv.getOutput();

  // p3 -- process p2 ( bw )
  //  mImageP3 = video.copy();
  contours = opencv.findContours();
}

void captureEvent(Capture c) {
  c.read();
}
