String oKeyboardCoordinatesStr;
final PMatrix3D mTransformationMatrix = new PMatrix3D();
PVector[] mKeyCoordinates;
PVector[] mSelectionPoints = {new PVector(), new PVector()};
int mPointID;
boolean mStateSetLine = true;
int mFirstKeyID;
int mSecondKeyID;

float mRobotKeyCounter = 0;
float mRobotKeyInterval = 2;
int mRobotKeyPressedID = 0;

void setup() {
  size(1024, 768, P3D);
  textFont(createFont("Courier", 11));

  /* parse key coords data */
  oKeyboardCoordinatesStr = loadStrings("keyboardCoordinates.txt")[0]; /* read first line */
  mKeyCoordinates = parseVectorData(oKeyboardCoordinatesStr);

  /* choose reference keys IDs */
  mFirstKeyID = 0;
  mSecondKeyID = 5;
}

void draw() {
  background(255);

  fill(0);
  text("POINT 0: " + mSelectionPoints[0].toString(), 20, 20);
  text("POINT 1: " + mSelectionPoints[1].toString(), 20, 34);

  /* flip y axis */
  scale(1, -1, 1);
  translate(0, -height);
  translate(width / 2, height / 2);

  /* draw robot */
  fill(0);
  text("[-]", 0, 0);

  /* draw selected line */
  stroke(0);
  line(mSelectionPoints[0].x, mSelectionPoints[0].y, mSelectionPoints[1].x, mSelectionPoints[1].y);
  noStroke();
  final float d = 20;
  if (mStateSetLine) {
    fill(255, 0, 0);
  } else {
    fill(0);
  }
  ellipse(mSelectionPoints[0].x, mSelectionPoints[0].y, d, d);
  if (mStateSetLine) {
    fill(0, 255, 0);
  } else {
    fill(0);
  }
  ellipse(mSelectionPoints[1].x, mSelectionPoints[1].y, d, d);

  /* draw keys in global space from local coords */
  computeTransformationMatrix(mSelectionPoints[0], mSelectionPoints[1]);
  noFill();
  for (int i = 0; i < mKeyCoordinates.length; i++) {
    if (i == mFirstKeyID) {
      stroke(255, 0, 0);
    } else if (i == mSecondKeyID) {
      stroke(0, 255, 0);
    } else {
      stroke(0);
    }
    final float r = 25;
    pushMatrix();
    /* transform local key coord to global space */
    PVector p = transformKeyCoordsToRobotCoords(mKeyCoordinates[i]);
    translate(p.x, p.y, p.z);
    ellipse(0, 0, r, r);
    popMatrix();
  }

  /* robot presses keys */
  if (mRobotKeyCounter > mRobotKeyInterval) {
    mRobotKeyCounter = 0;
    mRobotKeyPressedID = (int)random(mKeyCoordinates.length);
  } else {
    mRobotKeyCounter += 1.0 / frameRate;
  }
  fill(0, 127, 255);
  noStroke();
  PVector k = transformKeyCoordsToRobotCoords(mKeyCoordinates[mRobotKeyPressedID]);
  pushMatrix();
  translate(k.x, k.y, k.z);
  ellipse(0, 0, 20, 20);
  popMatrix();
}

void mousePressed() {
  if (mStateSetLine) {
    mPointID++;
    mPointID %= mSelectionPoints.length;
    if (mPointID == 0) {
      mStateSetLine = false;
    }
  }
}

void mouseMoved() {
  if (mStateSetLine) {
    mSelectionPoints[mPointID].set(mouseX - width / 2, (height - mouseY) - height / 2);
  }
}

void keyPressed() {
  if (key == ' ') {
    mStateSetLine = !mStateSetLine;
    if (mStateSetLine) {
      mPointID = 0;
    }
  }
}

PVector[] parseVectorData(String pData) {
  String[] mData = split(pData, ',');
  PVector[] mKeyCoordinates = new PVector[mData.length / 3];
  for (int i = 0; i < mData.length; i += 3) {
    mKeyCoordinates[i / 3] = new PVector();
    mKeyCoordinates[i / 3].x = parseFloat(mData[i + 0]);
    mKeyCoordinates[i / 3].y = parseFloat(mData[i + 1]);
    mKeyCoordinates[i / 3].z = parseFloat(mData[i + 2]);
  }
  return mKeyCoordinates;
}

PVector transformKeyCoordsToRobotCoords(PVector mKeyCoordinate) {
  PVector p = new PVector();
  mTransformationMatrix.mult(mKeyCoordinate, p);
  return p;
}

void computeTransformationMatrix(PVector p0, PVector p1) {
  /* compute angle offset from first and second key coord */
  float mAngleOffset = -getAngle(mKeyCoordinates[mFirstKeyID], mKeyCoordinates[mSecondKeyID]);
  /* compute rotation anlge */
  float mAngle = getAngle(p0, p1);
  /* reset and populate transformation matrix */
  mTransformationMatrix.reset();
  mTransformationMatrix.translate(p0.x, p0.y, p0.z);
  mTransformationMatrix.rotateZ(mAngle + mAngleOffset);
  mTransformationMatrix.translate(-mKeyCoordinates[mFirstKeyID].x, -mKeyCoordinates[mFirstKeyID].y, -mKeyCoordinates[mFirstKeyID].z);
}

float getAngle(PVector a, PVector b) {
  /* compute the angle of vector between a + b ( 2D version ) */
  PVector mDiff = PVector.sub(a, b);
  return atan2(mDiff.y, mDiff.x);
}
