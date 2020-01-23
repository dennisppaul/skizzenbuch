import shiffman.box2d.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.joints.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.collision.shapes.Shape;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.contacts.*;

Box2DProcessing box2d;
ArrayList<Ball> mSpheres;

PVector mStartingPoint = new PVector();
Boundary[][] mBoundaryArray;
final float BOUNDARY_PIXEL_SCALE = 32;
int BOUNDARY_WIDTH;
int BOUNDARY_HEIGHT;
boolean mLoadBall = false;
final float BALL_RADIUS = 16;
int mDeathCounter = 0;

float mMoneyCounter = 0;
final float mBallLostMoneyCost = 5;
final float mBuildBoundaryCost = 10;
final float mRefundBoundaryCostModifier = 0.25;

Paddle mPaddleLeft;
Paddle mPaddleRight;

void setup() {
  size(1024, 768, P3D);
  textFont(createFont("HelveticaNeue-Bold", BOUNDARY_PIXEL_SCALE * 2));

  box2d = new Box2DProcessing(this);
  box2d.createWorld();
  box2d.setGravity(0, -10);

//balls need to age

  final int mDistance = 10;
  final int mPaddleX = 10;
  mPaddleLeft = new Paddle(
    BOUNDARY_PIXEL_SCALE * mPaddleX + BOUNDARY_PIXEL_SCALE * 0.5, 
    BOUNDARY_PIXEL_SCALE * 20 + BOUNDARY_PIXEL_SCALE * 0.5, 
    0, PI/4);
  mPaddleRight = new Paddle(
    BOUNDARY_PIXEL_SCALE * (mPaddleX + mDistance) + BOUNDARY_PIXEL_SCALE * 0.5, 
    BOUNDARY_PIXEL_SCALE * 20 + BOUNDARY_PIXEL_SCALE * 0.5, 
    PI-PI/4, PI);

  mSpheres = new ArrayList<Ball>();
  BOUNDARY_WIDTH = (int)(width/BOUNDARY_PIXEL_SCALE);
  BOUNDARY_HEIGHT = (int)(height/BOUNDARY_PIXEL_SCALE);
  mBoundaryArray = new Boundary[BOUNDARY_WIDTH][BOUNDARY_HEIGHT];

  for (int x=0; x<BOUNDARY_WIDTH; x++) {
    createPixelBoundary(x, 0);
    //createPixelBoundary(x, BOUNDARY_HEIGHT-1);
  }
  for (int y=0; y<BOUNDARY_HEIGHT; y++) {
    createPixelBoundary(0, y);
    createPixelBoundary(BOUNDARY_WIDTH-1, y);
  }
}

void draw() {
  background(50);

  final float mDelta = 1.0 / frameRate;
  mMoneyCounter += mDelta * mSpheres.size();
  noStroke();
  fill(255, 127, 0);
  text("P//" + nf(mMoneyCounter, 3, 2), BOUNDARY_PIXEL_SCALE * 2, BOUNDARY_PIXEL_SCALE * 3);

  noStroke();
  fill(255, 127, 0);
  text("B//" + nf(mDeathCounter, 3), BOUNDARY_PIXEL_SCALE * 2, BOUNDARY_PIXEL_SCALE * 5);

  box2d.step();

  if (keyPressed) {
    mPaddleLeft.turn_left();
    mPaddleRight.turn_right();
  } else {
    mPaddleLeft.turn_right();
    mPaddleRight.turn_left();
  }

  for (int x=0; x<mBoundaryArray.length; x++) {
    for (int y=0; y<mBoundaryArray[x].length; y++) {
      Boundary wall = mBoundaryArray[x][y];
      if (wall != null) {
        wall.display();
      }
    }
  }

  if (!mLoadBall) {
    float px = floor((float)mouseX / BOUNDARY_PIXEL_SCALE) * BOUNDARY_PIXEL_SCALE + BOUNDARY_PIXEL_SCALE*0.5;
    float py = floor((float)mouseY / BOUNDARY_PIXEL_SCALE) * BOUNDARY_PIXEL_SCALE + BOUNDARY_PIXEL_SCALE*0.5;
    rectMode(CENTER);
    stroke(255, 0, 0);
    noFill();
    rect(px, py, BOUNDARY_PIXEL_SCALE + 2, BOUNDARY_PIXEL_SCALE + 2);
  } else {
    stroke(255, 0, 0);
    noFill();
    ellipse(mStartingPoint.x, mStartingPoint.y, BALL_RADIUS*2, BALL_RADIUS*2);
    ellipse(mouseX, mouseY, BALL_RADIUS, BALL_RADIUS);
    line(mStartingPoint.x, mStartingPoint.y, mouseX, mouseY);
  }

  for (Ball b : mSpheres) {
    b.display();
  }

  for (int i = mSpheres.size()-1; i >= 0; i--) {
    Ball b = mSpheres.get(i);
    if (b.done()) {
      mSpheres.remove(i);
      mDeathCounter++;
      mMoneyCounter -= mBallLostMoneyCost;
      if (mMoneyCounter < 0.0) { 
        mMoneyCounter = 0.0;
      }
    }
  }

  mPaddleLeft.display();
  mPaddleRight.display();
}

void mousePressed() {
  if (mouseButton == RIGHT) {
    mStartingPoint.set(mouseX, mouseY);
    mLoadBall = true;
  } else if (mouseButton == LEFT) {
    int px = (int)((float)mouseX / BOUNDARY_PIXEL_SCALE);
    int py = (int)((float)mouseY / BOUNDARY_PIXEL_SCALE);
    if (mBoundaryArray[px][py] != null) {
      mBoundaryArray[px][py].killBody();
      mBoundaryArray[px][py] = null;
      mMoneyCounter += mBuildBoundaryCost * mRefundBoundaryCostModifier;
    } else {
      if (mMoneyCounter >= mBuildBoundaryCost) { 
        createPixelBoundary(px, py);
        mMoneyCounter -= mBuildBoundaryCost;
      }
    }
  }
}

void createPixelBoundary(int px, int py) {
  mBoundaryArray[px][py] = new Boundary(px * BOUNDARY_PIXEL_SCALE + BOUNDARY_PIXEL_SCALE*0.5, 
    py * BOUNDARY_PIXEL_SCALE + BOUNDARY_PIXEL_SCALE*0.5, 
    BOUNDARY_PIXEL_SCALE, BOUNDARY_PIXEL_SCALE);
}

void mouseReleased() {
  if (mLoadBall) {
    mLoadBall = false;
    Ball p = new Ball(mStartingPoint.x, mStartingPoint.y, BALL_RADIUS, 
      PVector.sub(new PVector().set(mouseX, mouseY), 
      mStartingPoint));
    mSpheres.add(p);
  }
}
