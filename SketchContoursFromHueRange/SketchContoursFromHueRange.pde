import gab.opencv.*;
import processing.video.*;

Capture video;
OpenCV opencv;
PImage mImage;

import org.opencv.core.Scalar;


void settings() {
    size(1024, 768, P2D);
}

void setup() {
    video = new Capture(this, 1024, 768);
    opencv = new OpenCV(this, video.width, video.height);
    video.start();
    mImage = loadImage("test-image.png");
}

void draw() {
    background(50);
    //opencv.loadImage(video);
    opencv.loadImage(mImage);
    opencv.useColor();

    PImage src = opencv.getSnapshot();
    opencv.useColor(HSB);
    image(src, 0, 0);
    image(video, 0, 0, 1024/16, 768/16);

    int mHue = 10 + (int)(160 * mouseX/(float)width);
    ArrayList<Contour> mContours = findContours(src, mHue - 10, mHue + 10);
    //drawContours(mContours);
}

void mouseMoved() {
    color mColor = get(mouseX, mouseY);
    println(hue(mColor) + " - " + saturation(mColor) + " - " + brightness(mColor));
}

void captureEvent(Capture c) {
    c.read();
}

ArrayList<Contour> findContours(PImage src, int pHueMin, int pHueMax) {
    opencv.loadImage(src);
    opencv.useColor(HSB);
    opencv.setGray(opencv.getH().clone());

    //org.opencv.core.Core.inRange(opencv.getGray(), new Scalar(pHueMin, 255, 255), new Scalar(pHueMax, 255, 255), opencv.getGray());
    //org.opencv.core.Core.inRange(opencv.getColor(), new Scalar(pHueMin, 0, 0), new Scalar(pHueMax, 255, 255), opencv.getColor());
    opencv.inRange(pHueMin, pHueMax); // @TODO(roll your own! also need saturation + brightness range )

    //opencv.dilate();
    //opencv.erode();
    //opencv.blur(2);

    PImage mOut = opencv.getSnapshot();
    image(mOut, 1024/16, 0, 1024/16, 768/16);

    return opencv.findContours(true, true);
}

void drawContours(ArrayList<Contour> contours) {

    for (int i=0; i<contours.size(); i++) {

        Contour contour = contours.get(i);
        java.awt.Rectangle r = contour.getBoundingBox();

        if (r.width < 20 || r.height < 20) {
            continue;
        }

        stroke(255, 0, 0);
        noFill();
        rect(r.x, r.y, r.width, r.height);
    }
}
