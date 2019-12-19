import mathematik.Vector3f;
import mathematik.Vector4f;

import behavior.Behavior;
import processing.core.PApplet;
import processing.core.PFont;
import util.Frustum;
import util.Grid;


String filename = "flowPathData";

float WORLDBOX_X = 200.0f;

float WORLDBOX_Y = 200.0f;

float WORLDBOX_Z = 900.0f;

float CAMERAPOSITION_Y;

float GRIDCELLSIZE = 5.0f;

Frustum frustum;

Grid grid;

int[][][] flowpath;

int current;

int[] myGridPosition;

static final int FLOWPATH_XZ = 0;

static final int FLOWPATH_YZ = 1;

int currentFlowpath = FLOWPATH_XZ;

boolean ThreeDMode = false;

boolean pixel = false;

boolean useFrustum = true;

PFont myFont;

VehicleController vehicleController;

SimpleViewer simpleViewer;

public void setup() {

  size(400, 600, P3D);
  background(255);
  rectMode(CENTER);

  if (useFrustum) {
    CAMERAPOSITION_Y = -900.0f;
  } else {
    CAMERAPOSITION_Y = 900.0f;
  }
  // setup frustum
  frustum = new Frustum(WORLDBOX_X, WORLDBOX_Z, CAMERAPOSITION_Y);

  // setup grid
  grid = new Grid(new Vector3f(WORLDBOX_X, WORLDBOX_Y, WORLDBOX_Z), 
    new Vector3f(0.0f, -WORLDBOX_Y / 2.0f, WORLDBOX_Z / -2.0f), GRIDCELLSIZE, null);

  // setup flowpath
  flowpath = new int[3][ (int) (WORLDBOX_Z / GRIDCELLSIZE)][2];
  current = 0;

  // font
  myFont = loadFont("HelveticaNeue-CondensedBlack-14.vlw");
  textFont(myFont);
  textMode(SCREEN);

  // simpleViewer
  simpleViewer = new SimpleViewer();
  // VehicleController
  vehicleController = new VehicleController(1000);
  // load flowpaths
  for (int myCurrent = 0; myCurrent < flowpath.length; myCurrent++) {
    flowpath[myCurrent] = readFlowPath(filename + "_" + myCurrent);
  }
}


int counter = 1;

public void draw() {
  counter++;
  background(255);
  frameRate(60);
  //
  drawOSD(5, 15, 
    "FLOATING.NUMBERS\n\n" +
    "'C' TO CLEAR\n" +
    "'S' TO SMOOTH\n" +
    "'R' TO READ\n" +
    "'W' TO WRITE\n" +
    "'1' + '2' TO TOGGLE PLANES\n" +
    "'3' TO TOGGLE VIEW MODE\n" +
    "'Q' TO RESET VIEW\n" +
    "ARROW KEYS FOR NAVIGATION");

  float scaler = 0.66f;
  scale(0.66f);
  translate(200, 0, 0);
  // get current position
  myGridPosition = grid.position2Grid(new Vector3f(mouseX / scaler - 200 - WORLDBOX_X / 2, 
    0.0f, 
    mouseY / scaler - WORLDBOX_Z / 2));
  // 3D or 2D mode
  if (ThreeDMode) {
    // simpleViewer
    simpleViewer.cycle();
    // vehicles
    vehicleController.setGoToPointByGrid();
    vehicleController.cycle();
  } else {
    // draw table borders
    drawTableBorder();
    // draw cursor
  }
  drawGridPosition(myGridPosition);
  if (mousePressed) {
    setFlowPathElement(myGridPosition);
  }
  // draw current flowpath
  drawFlowPath();
}


public void keyPressed() {

  // simpleViewer
  simpleViewer.handleInput();

  switch (key) {
  case ' ':
    current++;
    current %= flowpath.length;
    println("current flow path #" + current);
    break;

  case 'C':
    clearFlowPath();
    break;

  case 'S':
    smoothFlowPath();
    break;

  case 'R':
    flowpath[current] = readFlowPath(filename + "_" + current);
    break;

  case 'W':
    writeFlowPath(filename + "_" + current);
    break;

  case '1':
    currentFlowpath = FLOWPATH_XZ;
    break;

  case '2':
    currentFlowpath = FLOWPATH_YZ;
    break;

  case '3':
    ThreeDMode = !ThreeDMode;
    break;

  case '4':
    useFrustum = !useFrustum;
    break;

  case '+':
    vehicleController.changeValue(0.1f);
    break;

  case '-':
    vehicleController.changeValue( -0.1f);
    break;
  }
}


void drawOSD(int x, int y, String myText) {
  fill(color(0, 0, 0, 150));
  text(myText, x, y);
}


void drawGridPosition(int[] myGridPosition) {
  Vector3f p = new Vector3f();
  p.x = myGridPosition[0] * GRIDCELLSIZE;
  p.z = myGridPosition[2] * GRIDCELLSIZE;
  pushMatrix();
  noFill();
  stroke(color(255, 0, 0, 100));
  if (ThreeDMode) {
    translate(0, -WORLDBOX_Y, -WORLDBOX_Z / 2);
    line(p.x, p.y, p.z, p.x + GRIDCELLSIZE, p.y, p.z + GRIDCELLSIZE);
    line(p.x + GRIDCELLSIZE, p.y, p.z, p.x, p.y, p.z + GRIDCELLSIZE);
  } else {
    translate(WORLDBOX_X / 2, 0);
    line(p.x, p.z, p.x + GRIDCELLSIZE, p.z + GRIDCELLSIZE);
    line(p.x + GRIDCELLSIZE, p.z, p.x, p.z + GRIDCELLSIZE);
  }
  popMatrix();
}


void drawTableBorder() {
  if (!ThreeDMode) {
    noFill();
    stroke(color(0, 0, 0, 20));
    for (int i = 0; i < 7; i++) {
      line(0, i * WORLDBOX_Z / 6, WORLDBOX_X, i * WORLDBOX_Z / 6);
    }
    line(0, 0, 0, WORLDBOX_Z);
    line(WORLDBOX_X, 0, WORLDBOX_X, WORLDBOX_Z);
  }
}


void drawFlowPath() {
  // prepare for drawing
  if (ThreeDMode) {
    noFill();
  } else {
    if (currentFlowpath == FLOWPATH_XZ) {
      fill(color(0, 0, 0, 70));
      text("XZ: " + current, 5, height - 20);
      noFill();
    } else {
      fill(color(0, 0, 0, 70));
      text("YZ: " + current, 5, height - 20);
      noFill();
    }
  }
  // draw flow path
  pushMatrix();
  if (!ThreeDMode) {
    translate(WORLDBOX_X / 2, WORLDBOX_Z / 2);
  }
  for (int myCurrent = 0; myCurrent < flowpath.length; myCurrent++) {
    // select color UGLY
    int myAlpha = 100;
    if (myCurrent == current) {
      myAlpha = 200;
    }
    if (myCurrent == 0) {
      stroke(color(255, 0, 0, myAlpha));
    }
    if (myCurrent == 1) {
      stroke(color(0, 255, 0, myAlpha));
    }
    if (myCurrent == 2) {
      stroke(color(0, 0, 255, myAlpha));
    }
    for (int i = 1; i < flowpath[myCurrent].length; i++) {
      Vector3f p1;
      Vector3f p2;
      if (ThreeDMode) {
        // get position from grid
        p1 = grid.grid2Position(flowpath[myCurrent][i][FLOWPATH_XZ], flowpath[myCurrent][i][FLOWPATH_YZ], i);
        p2 = grid.grid2Position(flowpath[myCurrent][i - 1][FLOWPATH_XZ], 
          flowpath[myCurrent][i - 1][FLOWPATH_YZ], i - 1);
        // apply frustum
        if (useFrustum) {
          p1.x = frustum.frustum2PositionX(p1.y, p1.x);
          p1.z = frustum.frustum2PositionZ(p1.y, p1.z);
          p2.x = frustum.frustum2PositionX(p2.y, p2.x);
          p2.z = frustum.frustum2PositionZ(p2.y, p2.z);
        }
        line(p1.x, p1.y, p1.z, p2.x, p2.y, p2.z);
      } else {
        p1 = grid.grid2Position(flowpath[myCurrent][i][currentFlowpath], 0, i);
        p2 = grid.grid2Position(flowpath[myCurrent][i - 1][currentFlowpath], 0, i - 1);
        line(p1.x, p1.z, p2.x, p2.z);
      }
    }
  }
  popMatrix();
}


void setFlowPathElement(int[] myGridPosition) {
  if (myGridPosition[2] > flowpath[current].length - 1) {
    println("### ERROR out of bound y = " + myGridPosition[2]);
  } else {
    if (myGridPosition[2] > 0 && myGridPosition[2] < flowpath[0].length) {
      flowpath[current][myGridPosition[2]][currentFlowpath] = myGridPosition[0];
    }
  }
}


void smoothFlowPath() {
  for (int y = 1; y < flowpath[current].length - 1; y++) {

    // average flowpath data
    int a = flowpath[current][y - 1][currentFlowpath];
    int b = flowpath[current][y][currentFlowpath];
    int c = flowpath[current][y + 1][currentFlowpath];

    // take average if sum is bigger than 0
    if (a + b + c != 0) {
      flowpath[current][y][currentFlowpath] = (a + b + c) / 3;
    }
  }
}


void clearFlowPath() {
  for (int y = 0; y < flowpath[current].length; y++) {
    flowpath[current][y][currentFlowpath] = 0;
  }
}


void writeFlowPath(String filename) {
  int[] ff = new int[flowpath[current].length * flowpath[current][0].length];
  // write data to byte array
  int c = 0;
  for (int y = 0; y < flowpath[current].length; y++) {
    for (int i = 0; i < flowpath[current][0].length; i++) {
      ff[c++] = flowpath[current][y][i];
    }
  }
  saveInt16bit("data/" + filename, ff);
}


int[][] readFlowPath(String filename) {
  int[][] myFlowpath = new int[ (int) (WORLDBOX_Z / GRIDCELLSIZE)][2];
  int[] ff = loadInts16bit(filename, true);
  int c = 0;
  for (int y = 0; y < myFlowpath.length; y++) {
    for (int i = 0; i < myFlowpath[0].length; i++) {
      myFlowpath[y][i] = ff[c++];
    }
  }
  return myFlowpath;
}


class SimpleViewer {

  int moveZ = 0;

  int moveY = 0;

  int moveX = 0;

  float rotX = 0;

  float rotY = 0;

  float rotZ = 0;

  int baseColor = 0;

  int speed = 20;

  boolean toggleShift = false;

  void cycle() {

    noFill();
    stroke(color(baseColor, baseColor, baseColor, 20));
    translate(WORLDBOX_X / 2 + moveX, 
      WORLDBOX_Z / 2 + moveY, 
      -WORLDBOX_Y / 2 + moveZ);
    if (useFrustum) {
      rotateX(radians(rotX) + PI * 0.5f);
    } else {
      rotateX(radians(rotX) + PI * 1.5f);
    }
    rotateY(radians(rotY));
    box(WORLDBOX_X, WORLDBOX_Y, WORLDBOX_Z);
    translate(0, WORLDBOX_Y / 2, 0);
  }


  void handleInput() {
    if (keyCode == SHIFT) {
      toggleShift = !toggleShift;
      println("shift: " + toggleShift);
    }

    if (toggleShift) {
      switch (key) {
      case 'w':
        moveY += speed;
        break;

      case 's':
        moveY -= speed;
        break;
      }
      switch (keyCode) {
      case UP:
        moveZ += speed;
        break;

      case DOWN:
        moveZ -= speed;
        break;

      case LEFT:
        moveX += speed;
        break;

      case RIGHT:
        moveX -= speed;
        break;
      }
    } else {
      switch (keyCode) {
      case UP:
        rotX -= speed;
        break;

      case DOWN:
        rotX += speed;
        break;

      case LEFT:
        rotY += speed;
        break;

      case RIGHT:
        rotY -= speed;
        break;
      }
    }

    if (key == ' ') {
      println("moveX + moveY + moveZ :" + moveX + ", " + moveY + ", " + moveZ);
      println("rotX + rotY + rotZ    :" + rotX + ", " + rotY + ", " + rotZ);
    }
    if (key == 'q') {
      moveX = 0;
      moveY = 0;
      moveZ = 0;
      rotX = 0;
      rotY = 0;
      rotZ = 0;
    }
  }
}


class FloatVehicle {

  String name;

  // states

  static final int FLOATING = 0;

  static final int GOING_UP = 1;

  static final int DRIFTING = 2;

  static final int DISPLAYING = 3;

  static final int GOING_DOWN = 4;

  int state = FLOATING;

  // behavior

  Behavior behavior = new Behavior();

  Vector3f velocity = behavior.velocity;

  Vector3f position = behavior.position;

  Vector4f rotation = behavior.rotation.rotation;

  Vector3f direction_wandering = new Vector3f();

  Vector3f direction_flowpath = new Vector3f();

  Vector3f direction_current = new Vector3f();

  Vector3f steering_direction = new Vector3f();

  // behavior relevance

  float wanderingRelevance = 0.5f;

  float flowpathRelevance = 0.5f;

  float currentRelevance = 0.0f;

  // physic

  Vector3f steering_force = new Vector3f();

  Vector3f acceleration = new Vector3f();

  float max_force = 0.3f;

  float max_speed = (float) Math.random() * 0.2f + 0.2f;


  float mass;

  FloatVehicle(float mass, String name) {
    this.mass = mass;
    this.name = name;
    behavior.goToPoint.pointPosition = new Vector3f(20.0f, 0.0f, 40.0f);
  }


  void cycle() {

    // select state
    switch (state) {
    case FloatVehicle.FLOATING:
      break;
    case FloatVehicle.GOING_UP:
      break;
    case FloatVehicle.DRIFTING:
      break;
    case FloatVehicle.DISPLAYING:
      break;
    case FloatVehicle.GOING_DOWN:
      break;
    }

    // wandering
    direction_wandering.set(behavior.wander.get());

    // flowpath
    direction_flowpath.set(behavior.goToPoint.get());

    // current
    direction_current = new Vector3f(0.0f, 0.0f, -1.0f);

    // add vectors with relevance
    direction_wandering.scale(wanderingRelevance);
    direction_flowpath.scale(flowpathRelevance);
    direction_current.scale(currentRelevance);
    steering_direction.add(direction_wandering, direction_flowpath);
    steering_direction.add(direction_current);

    // physic
    steering_force.set(steering_direction);
    if (steering_force.length() > max_force) {
      steering_force.normalize();
      steering_force.scale(max_force);
    }
    acceleration.scale(1.0f / mass, steering_force);
    velocity.add(acceleration);
    if (velocity.length() > max_speed) {
      velocity.normalize();
      velocity.scale(max_speed);
    }

    position.add(velocity);

    // rotation
    behavior.rotation.calculateRotation();
  }


  Vector4f getRotation() {
    return rotation;
  }


  Vector3f getPosition() {
    return position;
  }


  void setPosition(float x, float y, float z) {
    position.x = x;
    position.y = y;
    position.z = z;
  }


  String getName() {
    return name;
  }
}


class VehicleController {

  FloatVehicle[] vehicle;

  VehicleController(int numberOfVehicles) {
    vehicle = new FloatVehicle[numberOfVehicles];
    for (int i = 0; i < vehicle.length; i++) {
      vehicle[i] = new FloatVehicle(0.1f, "2");
      vehicle[i].setPosition(random(40), -200, random( -WORLDBOX_Z / 2, WORLDBOX_Z / 2));
    }
  }


  void cycle() {
    setGoToPointByGrid();
    for (int i = 0; i < vehicle.length; i++) {
      vehicle[i].cycle();
      this.draw(vehicle[i]);
    }
  }


  void changeValue(float value) {
    for (int i = 0; i < vehicle.length; i++) {
      vehicle[i].wanderingRelevance += value;
      vehicle[i].flowpathRelevance -= value;
    }
    println("wander: " + vehicle[0].wanderingRelevance + " / flowpath: " + vehicle[0].flowpathRelevance);
  }


  void setGoToPointByGrid() {
    for (int i = 0; i < vehicle.length; i++) {
      // select flowpath to follow
      int[][] myFlowpath = flowpath[i % flowpath.length];
      //
      int[] myGridPosition;
      if (useFrustum) {
        Vector3f myPosition = new Vector3f();
        myPosition.set(vehicle[i].position);
        myPosition.x = frustum.position2FrustumX(myPosition.y, myPosition.x);
        myPosition.z = frustum.position2FrustumZ(myPosition.y, myPosition.z);
        myGridPosition = grid.position2Grid(myPosition);
      } else {
        myGridPosition = grid.position2Grid(vehicle[i].position);
      }
      // offset so vehicles never arrive
      int z = myGridPosition[2] - 1;
      if (z == 0) {
        vehicle[i].position.z = WORLDBOX_Z / 2;
      }
      if (z < myFlowpath.length - 1 && z >= 0) {
        // get position from grid
        Vector3f p = grid.grid2Position(myFlowpath[z][FLOWPATH_XZ], myFlowpath[z][FLOWPATH_YZ], z);
        if (useFrustum) {
          // apply frustum
          p.x = frustum.frustum2PositionX(p.y, p.x);
          p.z = frustum.frustum2PositionZ(p.y, p.z);
        }
        vehicle[i].behavior.goToPoint.pointPosition = p;
      }
    }
  }


  void draw(FloatVehicle me) {
    Vector3f position = me.position;
    noFill();
    stroke(0);
    point(position.x, position.y, position.z);
  }
}


/* load */

public int[] loadInts16bit(String filename, boolean signed) {
  return convertByteArrayToIntArray(loadBytes(filename), 2, signed);
}


private int[] convertByteArrayToIntArray(byte[] myByteArray, int bytesPerInt, boolean signed) {
  int[] myIntArray = new int[myByteArray.length / bytesPerInt];
  for (int i = 0; i < myIntArray.length; i++) {
    int myInt = 0;
    for (int j = 0; j < bytesPerInt; j++) {
      myInt += toUnsignedInt(myByteArray[i * bytesPerInt + j]) << (j * 8);
    }
    myIntArray[i] = myInt;
  }
  if (signed) {
    return unsignedIntArray2signedIntArray(myIntArray, bytesPerInt);
  } else {
    return myIntArray;
  }
}


private int toUnsignedInt(byte value) {
  return value & 0xff;
}


private int[] unsignedIntArray2signedIntArray(int[] myIntArray, int numberOfBytes) {
  for (int i = 0; i < myIntArray.length; i++) {
    if (myIntArray[i] >= 2 << (numberOfBytes * 8 - 2)) {
      myIntArray[i] -= 2 << (numberOfBytes * 8 - 1);
    }
  }
  return myIntArray;
}


/* save */

public void saveInt16bit(String filename, int[] intData) {
  saveBytes(filename, convertIntArrayToByteArray(intData, 2));
}


private byte[] convertIntArrayToByteArray(int[] myIntArray, int bytesPerInt) {
  byte[] myByteArray = new byte[myIntArray.length * bytesPerInt];
  for (int i = 0; i < myIntArray.length; i++) {
    byte[] myBytes = convertIntToByteArray(myIntArray[i], bytesPerInt);
    for (int j = 0; j < bytesPerInt; j++) {
      myByteArray[i * bytesPerInt + (bytesPerInt - j - 1)] = myBytes[j];
    }
  }
  return myByteArray;
}


private byte[] convertIntToByteArray(int value, int numberOfBytes) {
  byte b[] = new byte[numberOfBytes];
  int i, shift;
  for (i = 0, shift = (b.length - 1) * 8; i < b.length; i++, shift -= 8) {
    b[i] = (byte) (0xFF & (value >> shift));
  }
  return b;
}
