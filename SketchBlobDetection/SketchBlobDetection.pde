import processing.video.*;
import blobDetection.*;

Capture cam;
BlobDetection theBlobDetection;
PImage img;
boolean newFrame=false;

void setup() {
  size(640, 480);
  cam = new Capture(this, width, height, 15);
  cam.start();

  img = new PImage(640/2, 480/2); 
  theBlobDetection = new BlobDetection(img.width, img.height);
  theBlobDetection.setPosDiscrimination(true);
  theBlobDetection.setThreshold(0.2f); // will detect bright areas whose luminosity > 0.2f;
}

void captureEvent(Capture cam) {
  cam.read();
  newFrame = true;
}

void draw() {
  if (newFrame) {
    newFrame=false;
    image(cam, 0, 0, width, height);
    img.copy(cam, 0, 0, cam.width, cam.height, 0, 0, img.width, img.height);
    fastblur(img, 2);

    /* red channel */
    PImage mRedImg = new PImage(width, height); 
    mRedImg.copy(cam, 0, 0, cam.width, cam.height, 0, 0, mRedImg.width, mRedImg.height);
    for (int i=0; i < mRedImg.pixels.length; i++) {
      color mColor =  mRedImg.pixels[i];
      float mRed = red(mColor);
      mRedImg.pixels[i] = color(mRed);
    }
    mRedImg.updatePixels();
    image(mRedImg, width/5 + 10, 0, width/5, height/5);

    /* hue */
    PImage mHueImg = new PImage(width, height); 
    mHueImg.copy(cam, 0, 0, cam.width, cam.height, 0, 0, mRedImg.width, mRedImg.height);
    for (int i=0; i < mHueImg.pixels.length; i++) {
      color mColor =  mHueImg.pixels[i];
      float mHue = hue(mColor);
      mHueImg.pixels[i] = color(mHue);
    }
    mHueImg.updatePixels();
    image(mHueImg, 2 * (width/5 + 10), 0, width/5, height/5);

    /* threshold */
    img.filter(THRESHOLD, (float)mouseX/(float)width);
    image(img, 0, 0, width/5, height/5);

    theBlobDetection.computeBlobs(img.pixels);
    drawBlobsAndEdges(true, true);
  }
}

void drawBlobsAndEdges(boolean drawBlobs, boolean drawEdges) {
  noFill();
  Blob b;
  EdgeVertex eA, eB;
  for (int n=0; n<theBlobDetection.getBlobNb(); n++) {
    b=theBlobDetection.getBlob(n);
    if (b!=null) {
      // Edges
      if (drawEdges) {
        strokeWeight(3);
        stroke(0, 255, 0);
        for (int m=0; m<b.getEdgeNb(); m++)
        {
          eA = b.getEdgeVertexA(m);
          eB = b.getEdgeVertexB(m);
          if (eA !=null && eB !=null)
            line(eA.x * width, eA.y * height, eB.x * width, eB.y * height);
        }
      }
      // Blobs
      if (drawBlobs) {
        strokeWeight(1);
        stroke(255, 0, 0);
        rect( b.xMin * width, b.yMin * height, b.w * width, b.h * height);
      }
    }
  }
}
