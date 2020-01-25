import processing.video.*;

Movie mMovie; 
int mInstanceCounter = 0;

void setup() {
  size(640, 480);
  textFont(createFont("Courier", 11));
}

void movieEvent(Movie m) {
  m.read();
}

void draw() {
  background(0);
  if (mMovie != null) {
    image(mMovie, 0, 0, width, height);
  }

  printMemoryUsage();

  final int INSTANCE_INTERVAL = 16;
  if (frameCount % INSTANCE_INTERVAL == INSTANCE_INTERVAL/2) {
    if (mMovie != null) {
      /* a few steps need to be executed to get rid of the instance */
      mMovie.stop();
      mMovie.dispose();
      mMovie = null;
      System.gc();
    }
  } else if (frameCount % INSTANCE_INTERVAL == 0) {
    mMovie = new Movie(this, "launch2.mp4");
    mMovie.loop();
    mInstanceCounter++;
    println(mInstanceCounter);
  }
}

void printMemoryUsage() {
  final int mMB = 1024*1024;
  Runtime mRuntime = Runtime.getRuntime();

  final float mX = 50;
  float mY = 50;
  float mLineHeight = 14;

  text("### Heap utilization statistics [MB]", mX, mY+=mLineHeight);
  mY+=mLineHeight;

  // used memory
  text("Used Memory    : " + (mRuntime.totalMemory() - mRuntime.freeMemory()) / mMB, mX, mY+=mLineHeight);
  // free memory
  text("Free Memory    : " + mRuntime.freeMemory() / mMB, mX, mY+=mLineHeight);
  // total available memory
  text("Total Memory   : " + mRuntime.totalMemory() / mMB, mX, mY+=mLineHeight);
  // Maximum available memory
  text("Max Memory     : " + mRuntime.maxMemory() / mMB, mX, mY+=mLineHeight);

  mY+=mLineHeight;
  text("Instanzen      : " + mInstanceCounter, mX, mY+=mLineHeight);
}
