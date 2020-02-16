int mScaleX, mScaleY; 
int[][][] mWorld;
float mRatioX;
float mRatioY;

PImage[] mImages = new PImage[128];
int mImageCounter = 0;

void setup() { 
  size(1024, 768, P3D);
  hint(DISABLE_DEPTH_TEST);
  ((PGraphicsOpenGL)g).textureSampling(3); // TEXTURE SAMPLING LINEAR

  mScaleX = 1024 / 4;
  mScaleY = 768 / 4;
  mWorld = new int[mScaleX][mScaleY][2];
  mRatioX = width / mScaleX;
  mRatioY = height / mScaleY;
} 

void draw() { 
  /* populate field */
  if (mousePressed) {
    populate_field(mouseX, mouseY);
  }
  update_cycle();
  birth_death_cycle();

  background(50); 
  translate(width/2, height/2);
  rotateX(sin(frameCount/160.0) * 0.25 + 0.25);
  rotateY(sin(frameCount/233.0) * 0.5);

  pushMatrix();
  scale(mRatioX, mRatioY);
  PImage mImage = createImage(mScaleX, mScaleY, ARGB);
  for (int x = 0; x < mScaleX; x++) { 
    for (int y = 0; y < mScaleY; y++) {
      mImage.set(x, y, mWorld[x][y][0] == 1 ? color(255, 127, 0, 15) : color(255, 127, 0, 0));
    }
  }
  mImages[mImageCounter] = mImage;
  mImageCounter++;
  mImageCounter%=mImages.length;
  for (int i = mImages.length - 1; i >= 0; i--) { 
    int j = ( i + mImageCounter) % mImages.length;
    if (mImages[j] != null) {
      image(mImages[j], mImages[j].width/-2, mImages[j].height/-2);
      translate(0, 0, -2.0);
    }
  }
  popMatrix();

  noFill();
  stroke(0, 127, 255);
  pushMatrix();
  translate(width/-2, height/-2);
  draw_field();
  popMatrix();
} 

void update_cycle() {
  for (int x = 0; x < mScaleX; x++) { 
    for (int y = 0; y < mScaleY; y++) { 
      if ((mWorld[x][y][1] == 1) || (mWorld[x][y][1] == 0 && mWorld[x][y][0] == 1)) { 
        mWorld[x][y][0] = 1;
      } 
      if (mWorld[x][y][1] == -1) { 
        mWorld[x][y][0] = 0;
      } 
      mWorld[x][y][1] = 0;
    }
  }
}

void birth_death_cycle() {
  for (int x = 0; x < mScaleX; x++) { 
    for (int y = 0; y < mScaleY; y++) { 
      int mCount = neighbors(x, y); 
      if (mCount == 3 && mWorld[x][y][0] == 0) { 
        mWorld[x][y][1] = 1;
      } 
      if ((mCount < 2 || mCount > 3) && mWorld[x][y][0] == 1) { 
        mWorld[x][y][1] = -1;
      }
    }
  }
}

void populate_field(float pMouseX, float pMouseY) {
  for (int x=-4; x < 4; x++) {
    for (int y=-4; y < 4; y++) {
      int mX = (int(pMouseX / mRatioX + x) + mScaleX ) % mScaleX;
      int mY = (int(pMouseY / mRatioY + y) + mScaleY ) % mScaleY;
      mWorld[mX][mY][1] = 1;
    }
  }
}

void draw_field() {
  for (int x = 0; x < mScaleX; x++) { 
    for (int y = 0; y < mScaleY; y++) { 
      if ((mWorld[x][y][1] == 1) || (mWorld[x][y][1] == 0 && mWorld[x][y][0] == 1)) { 
        rect(x * mRatioX, y * mRatioY, mRatioX, mRatioY);
      }
    }
  }
}

/* Count the number of adjacent cells 'on' */
int neighbors(int x, int y) { 
  return mWorld[(x + 1) % mScaleX][y][0] + 
    mWorld[x][(y + 1) % mScaleY][0] + 
    mWorld[(x + mScaleX - 1) % mScaleX][y][0] + 
    mWorld[x][(y + mScaleY - 1) % mScaleY][0] + 
    mWorld[(x + 1) % mScaleX][(y + 1) % mScaleY][0] + 
    mWorld[(x + mScaleX - 1) % mScaleX][(y + 1) % mScaleY][0] + 
    mWorld[(x + mScaleX - 1) % mScaleX][(y + mScaleY - 1) % mScaleY][0] + 
    mWorld[(x + 1) % mScaleX][(y + mScaleY - 1) % mScaleY][0];
} 

void keyPressed() {
  if (key==' ') {
    for (int x = 0; x < mScaleX; x++) { 
      for (int y = 0; y < mScaleY; y++) { 
        mWorld[x][y][0] = 0;
        mWorld[x][y][1] = 0;
      }
    }
  }
}
