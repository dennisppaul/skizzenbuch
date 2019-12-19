import gab.opencv.*;
import processing.video.*;
import java.awt.*;

Capture video;
OpenCV opencv;
ArrayList<Contour> contours;

void setup() {
  size(640, 480);
  video = new Capture(this, 640/2, 480/2);
  opencv = new OpenCV(this, 640/2, 480/2);

  video.start();
}

void draw() {
  opencv.loadImage(video);

  image(video, 0, 0, width, height );

  noFill();
  stroke(0, 255, 0);

  opencv.gray();
  float mThreshold = mouseX/(float)width * 255;
  opencv.threshold((int)mThreshold);
  opencv.blur(3);
  image(opencv.getOutput(), 0, 0, width/4, height/4);

  contours = opencv.findContours();

  for (Contour contour : contours) {
    stroke(0, 255, 0);
    pushMatrix();
    scale(2);
    strokeWeight(0.5);
    contour.draw();

    stroke(255, 0, 0);
    beginShape();
    for (PVector point : contour.getPolygonApproximation().getPoints()) {
      vertex(point.x, point.y);
    }
    endShape();

    stroke(0, 0, 255);
    Rectangle mBB = contour.getBoundingBox();
    rect(mBB.x, mBB.y, mBB.width, mBB.height);
    popMatrix();
  }
}

void captureEvent(Capture c) {
  c.read();
}
