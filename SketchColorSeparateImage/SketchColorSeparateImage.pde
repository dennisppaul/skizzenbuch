
import processing.video.*;
import java.awt.Color;

Capture mVideo;
PImage mImageRed;
PImage mImageBlue;

void settings() {
  size(1024, 768, P3D);
}

void setup() {
  colorMode(RGB, 255);
  mImageRed = new PImage(320, 240);
  mImageBlue = new PImage(320, 240);
  mVideo = new Capture(this, 320, 240);
  mVideo.start();
}

void draw() {
  background(50);
  image(mVideo, 0, 0, 0, 0); /* WTF is this necessay?!? */
  image(mImageRed, 0, 0, width, height);

  if (mVideo.available()) { 
    mVideo.read();
    mVideo.loadPixels();
      for (int i = 0; i < mVideo.pixels.length; i++) {
        final float h = hue(mVideo.pixels[i]);
        if (h > 0 && h < 40) {
          mImageRed.pixels[i] = color(255, 127, 0);
        } else if (h > 40 && h < 140) {
          mImageRed.pixels[i] = color(255);
        } else if (h > 140 && h < 210) {
          mImageRed.pixels[i] = color(0, 127, 255);
        } else {
          mImageRed.pixels[i] = color(50, 0);
        }
      }
    mImageRed.updatePixels();
  }
}
