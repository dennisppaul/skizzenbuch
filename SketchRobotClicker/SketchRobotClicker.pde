import java.awt.Robot;
import java.awt.event.InputEvent;

Robot mRobot = null;
int mStart_X = 80;
int mWidth = 720 - mStart_X;
int mStart_Y = 146;
int mHeight = 510-mStart_Y;
int i = 0;

void setup( ) {
  try {
    mRobot = new Robot();
  } 
  catch (Exception e) {
    e.printStackTrace();
  }
  mRobot.mouseMove(mStart_X, mStart_Y);
}

void draw() {
  if (mRobot != null) {
    while (true) {
      mRobot.mousePress(InputEvent.BUTTON1_MASK);
      i+=10;
      int x=i%mWidth;
      int y=4*(i/mWidth);
      y%=mHeight;
      mRobot.mouseMove(mStart_X + x, mStart_Y + y);
      try {
        Thread.sleep(10);
      } 
      catch (Exception e) {
        e.printStackTrace();
      }
    }
  }
}
