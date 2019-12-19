import processing.video.*;

boolean DEBUG_DRAW_IMAGE = false;
boolean USE_CAMERA = true;
boolean DRAW_FIELD = true;
boolean USE_GREYSCALE = true;

Capture mCamera;
PImage mStillImage;
PImage mProcessedImage = null;
final int IMAGE_SCALE = 16;
final float BOX_SIZE = 16;
final float BOX_HEIGHT_SCALE = 10.0;
float mThreshold = 0.5f;

void settings() {
  size(1024, 768, P3D);
}

void setup() {
  if (USE_CAMERA) {
    mCamera = new Capture(this);
    mCamera.start();
    image(mCamera, 0, 0, 0, 0); // @HACK without this function the pixels in `mCamera` will not be update in the loop
  } else {
    mStillImage = loadImage("src-image.png");
  }
}

void draw() {
  background(50);

  if (USE_CAMERA) {
    if (mCamera.available()) {
      mCamera.read();
      mCamera.loadPixels();
      mProcessedImage = mCamera.copy();
      mProcessedImage.resize(mProcessedImage.width / IMAGE_SCALE, mProcessedImage.height / IMAGE_SCALE);
    }
  } else {
    mProcessedImage = mStillImage.copy();
    mProcessedImage.resize(mProcessedImage.width / IMAGE_SCALE, mProcessedImage.height / IMAGE_SCALE);
  }

  if (mProcessedImage != null) {
    if (USE_GREYSCALE) {
      mProcessedImage.filter(GRAY);
    } else {
      mProcessedImage.filter(THRESHOLD, mThreshold);
    }

    beginView();
    if (DRAW_FIELD) {
      drawField(mProcessedImage);
    } else {
      drawMesh(mProcessedImage);
    }
    endView();

    if (DEBUG_DRAW_IMAGE) {
      hint(DISABLE_DEPTH_TEST);
      if (USE_CAMERA) {
        image(mCamera, 0, 0, width/2, height/2);
      } else {
        image(mStillImage, 0, 0, width/2, height/2);
      }
      image(mProcessedImage, width/2, 0, width/2, height/2);
      hint(ENABLE_DEPTH_TEST);
    }
  }
}

void beginView() {
  pushMatrix();
  translate(width/2, height/2);
  camera(mouseX - width / 2, mouseY - height / 2, height, 
    0.0, 0.0, 0.0, 
    0.0, 1.0, 0.0);
  directionalLight(126, 126, 126, 0, 0, -1);
  ambientLight(102, 102, 102);
}

void drawField(PImage pBWImage) {
  fill(255);
  stroke(127);
  for (int x=0; x<pBWImage.width; x++) {
    for (int y=0; y<pBWImage.height; y++) {
      float mHeight = brightness(pBWImage.get(x, y)) / 255.0 * BOX_SIZE * BOX_HEIGHT_SCALE + 1.0;
      pushMatrix();
      translate((x-pBWImage.width/2) * IMAGE_SCALE, (y-pBWImage.height/2) * IMAGE_SCALE);
      box(BOX_SIZE, BOX_SIZE, mHeight);
      popMatrix();
    }
  }
}

void drawMesh(PImage pBWImage) {
  fill(255);
  stroke(127);
  PVector[] mVertices = new PVector[4];
  beginShape(TRIANGLES);
  for (int y=0; y<pBWImage.height - 1; y++) {
    for (int x=0; x<pBWImage.width - 1; x++) {
      mVertices[0] = getVertex(pBWImage, x, y);
      mVertices[1] = getVertex(pBWImage, x + 1, y);
      mVertices[2] = getVertex(pBWImage, x + 1, y + 1);
      mVertices[3] = getVertex(pBWImage, x, y + 1);
      vertex(mVertices[0]);
      vertex(mVertices[1]);
      vertex(mVertices[2]);
      vertex(mVertices[0]);
      vertex(mVertices[2]);
      vertex(mVertices[3]);
    }
  }
  endShape();
}

void vertex(PVector v) {
  vertex(v.x, v.y, v.z);
}

PVector getVertex(PImage pBWImage, int x, int y) {
  return new PVector().set(getX( pBWImage, x), getY( pBWImage, y), getZ( pBWImage, x, y));
}

float getX(PImage pBWImage, int x) {
  return (x-pBWImage.width/2) * IMAGE_SCALE;
}

float getZ(PImage pBWImage, int x, int y) {
  return (255.0 - brightness(pBWImage.get(x, y))) / 255.0 * BOX_SIZE * BOX_HEIGHT_SCALE + 1.0;
}

float getY(PImage pBWImage, int y) {
  return (y-pBWImage.height/2) * IMAGE_SCALE;
}

void endView() {
  noLights();
  popMatrix();
}

void keyPressed() {
  switch(key) {
  case '+':
    mThreshold += 0.025f;
    if (mThreshold > 1.0f) {
      mThreshold = 0.0f;
    }
    break;
  case '-':
    mThreshold -= 0.025f;
    if (mThreshold < 0.0f) {
      mThreshold = 1.0f;
    }
    break;
  case ' ':
    DEBUG_DRAW_IMAGE = !DEBUG_DRAW_IMAGE;
    break;
  case '1':
    DRAW_FIELD = !DRAW_FIELD;
    break;
  case '2':
    USE_GREYSCALE = !USE_GREYSCALE;
    break;
  }
}
