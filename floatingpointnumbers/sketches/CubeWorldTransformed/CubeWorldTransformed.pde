/*
 * manage vehicles in a 3 dimensional world.
 */

import java.util.Vector;

import mathematik.Vector3f;
import mathematik.Vector3i;
import mathematik.Vector4f;

import behavior.Behavior;
import processing.core.PApplet;
import processing.core.PFont;


Vector3f myGridSize;

Vector3f myGridOffset;

Vector[][][] gWorldBox;

int gCellSize = 30;

VehicleController vehicleController;

SimpleViewer simpleViewer;

FrustumLine frustumLine;

int counter;

Grid myGrid;

public void settings() {
  size(400, 600, P3D);
}

public void setup() {
  background(255);
  rectMode(CENTER);
  frameRate(60);

  /* font */
  PFont myFont = loadFont("HelveticaNeue-CondensedBlack-14.vlw");
  textFont(myFont);

  /* grid */
  myGridSize = new Vector3f(360.0f, 400.0f, 600.0f);
  myGridOffset = new Vector3f(0.0f, -200.0f, 0.0f);

  myGrid = new Grid(new Vector3f(), new Vector3f(), 0, 0.0f, null);
  int[] arraySize = myGrid.getRequiredArraySize(myGridSize, gCellSize);
  gWorldBox = new Vector[arraySize[0]][arraySize[1]][arraySize[2]];
  myGrid.initArray(gWorldBox);
  myGrid = new Grid(myGridSize, myGridOffset, gCellSize, 520.0f, gWorldBox);

  /* simple viewer */
  simpleViewer = new SimpleViewer();

  /* VehicleController */
  vehicleController = new VehicleController(200);

  /* frustum line */
  frustumLine = new FrustumLine();
}


public void draw() {
  background(255);
  counter++;

  /* OSD */
  drawOSD(5, 15, 
    "FLOATING.NUMBERS\n\n" +
    "'CLICK' TO DRAW A LINE\n" +
    "'+' AND '-' FOR VIEW CORRECTION\n" +
    "'Q' TO RESET VIEW\n" +
    "ARROW KEYS FOR NAVIGATION");

  /* simple viewer */
  simpleViewer.cycle();

  /* grid */
  myGrid.drawPosition(new Vector3f(mouseX - myGrid.worldBox.x / 2, 
    0.0f, 
    myGrid.worldBox.z / 2 - mouseY));
  myGrid.draw();

  /* vehicles */
  vehicleController.cycle();
  /* frustum line */
  if (mousePressed) {
    int x = mouseX - (int) myGrid.worldBox.x / 2;
    int z = (int) myGrid.worldBox.z / 2 - mouseY;
    frustumLine.set(x, z);
    frustumLine.draw();
    try {
      vehicleController.killVehiclesUnderRay(myGrid.grid2Array(myGrid.position2Grid(x)), 
        myGrid.grid2Array(myGrid.position2Grid(z)));
    } 
    catch (Exception ex) {
    }
  }
}


public void keyPressed() {

  /* simple viewer */
  simpleViewer.handleInput();

  switch (key) {
  case '+':
    myGrid.cameraHeight += 10;
    println(myGrid.cameraHeight);
    break;

  case '-':
    myGrid.cameraHeight -= 10;
    println(myGrid.cameraHeight);
    break;
  }
}


void drawOSD(int x, int y, String myText) {
  fill(color(0, 0, 0, 150));
  text(myText, x, y);
}


class FrustumLine {

  float x = 0.0f;

  float z = 0.0f;

  void set(float x, float z) {
    this.x = x;
    this.z = z;
  }


  void draw() {
    noFill();
    stroke(0, 255, 0, 200);
    for (int i = 0; i < 20; i++) {
      float y = -i * (600.0f / 20.0f);
      point(myGrid.frustum2PositionX(y, x), y, myGrid.frustum2PositionZ(y, z));
    }
  }
}


class SimpleViewer {

  int moveZ = 0;

  int moveY = 0;

  int moveX = 0;

  float rotX = 0;

  float rotY = 0;

  float rotZ = 0;

  int baseColor = 0;

  int speed = 10;

  boolean toggleShift = false;

  void cycle() {
    noFill();
    stroke(color(baseColor, baseColor, baseColor, 75));

    translate(200 + moveX, 300 + moveY, -300 + moveZ);
    rotateX(radians(rotX) + PI / 2);
    rotateY(radians(rotY));

    box(400, 600, 600);
    translate(0, 300, 0);
    stroke(255, 0, 0);
    point(0, 0, 0);
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

  int arrayPosition;

  /* states */

  static final int FLOATING = 0;

  static final int GOING_UP = 1;

  static final int DRIFTING = 2;

  static final int DISPLAYING = 3;

  static final int GOING_DOWN = 4;

  int state = FLOATING;

  /* behavior */

  Behavior behavior = new Behavior();

  Vector3f velocity = behavior.velocity;

  Vector3f position = behavior.position;

  Vector4f rotation = behavior.rotation.rotation;

  Vector3f direction_wandering = new Vector3f();

  Vector3f direction_stayHome = new Vector3f();

  Vector3f direction_current = new Vector3f();

  Vector3f steering_direction = new Vector3f();

  /* behavior relevance */

  float wanderingRelevance = 0.6f;

  float stayHomeRelevance = 0.1f;

  float currentRelevance = 0.3f;

  /* physic */

  Vector3f steering_force = new Vector3f();

  Vector3f acceleration = new Vector3f();

  float max_force = 0.1f;

  float max_speed = 3.0f;

  float mass;

  Grid grid;

  FloatVehicle(float mass, 
    String name, 
    int arrayPosition) {
    this.mass = mass;
    this.name = name;
    this.arrayPosition = arrayPosition;
    /* setup behaviors */
    behavior.goToPoint.pointPosition = new Vector3f(20.0f, 0.0f, 40.0f);
    /* setup grid */
    grid = new Grid(new Vector3f(myGridSize), 
      new Vector3f(myGridOffset), 
      gCellSize, 
      520.0f, 
      gWorldBox);
  }


  FloatVehicle destroy() {
    grid.removeVehicleObjectFromBox(this);
    return null;
  }


  void cycle() {

    /* select state */
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

    /* get directions */
    direction_wandering.set(behavior.wander.get());
    direction_stayHome.set(behavior.goToPoint.get());
    direction_current = new Vector3f(0.0f, 0.0f, 1.0f);

    /* add vectors with relevance */
    direction_wandering.scale(wanderingRelevance);
    direction_stayHome.scale(stayHomeRelevance);
    direction_current.scale(currentRelevance);
    steering_direction.add(direction_wandering, direction_stayHome);
    steering_direction.add(direction_current);

    /* physic */
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

    /* reset object */
    float border = grid.frustum2PositionZ(position.y, myGridSize.z / 2);
    if (position.z > border) {
      position.z = -border;
    }
    if (position.z < -border) {
      position.z = border;
    }
    /* rotation */
    behavior.rotation.calculateRotation();

    /* write to grid */
    grid.writeVehicleObjectToArray(grid.position2FrustumX(position.y, position.x), 
      position.y, 
      grid.position2FrustumZ(position.y, position.z), 
      this);
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

  FloatVehicle[] _myVehicle;

  VehicleController(int numberOfVehicles) {
    _myVehicle = new FloatVehicle[numberOfVehicles];
    for (int i = 0; i < _myVehicle.length; i++) {
      _myVehicle[i] = new FloatVehicle(0.1f, "v" + i, i);
      _myVehicle[i].setPosition(random(40), 
        random( -400), 
        random(myGridSize.z / -2, myGridSize.z / 2));
    }
  }


  /* cycle and draw objects */
  void cycle() {
    for (int i = 0; i < _myVehicle.length; i++) {
      if (_myVehicle[i] != null) {
        _myVehicle[i].cycle();
        this.draw(_myVehicle[i]);
      }
    }
  }


  void randomlyKillVehicle() {
    int victim;
    do {
      victim = (int) random(_myVehicle.length - 1);
    } while (_myVehicle[victim] == null);
    _myVehicle[victim] = _myVehicle[victim].destroy();
  }


  void killVehiclesUnderRay(int x, int z) {
    Vector myVector;
    /* remove from list */
    for (int y = 0; y < gWorldBox[0].length; y++) {
      myVector = gWorldBox[x][y][z];
      for (int i = 0; i < myVector.size(); i++) {
        FloatVehicle victim = (FloatVehicle) myVector.get(i);
        _myVehicle[victim.arrayPosition] = null;
      }
      gWorldBox[x][y][z] = new Vector();
    }
  }


  void changeValue(float value) {
    for (int i = 0; i < _myVehicle.length; i++) {
      _myVehicle[i].max_speed += value;
    }
    print(_myVehicle[0].max_speed + " / ");
  }


  void draw(FloatVehicle me) {
    Vector3f position = me.position;
    stroke(0, 0, 0);
    noFill();
    point(position.x, position.y, position.z);
  }
}


class Grid {

  Vector3f worldBox = new Vector3f();

  /* grid */

  Vector3f translateOrigin = new Vector3f();

  float gridCellSize;

  int worldBoxArraySizeX;

  int worldBoxArraySizeY;

  int worldBoxArraySizeZ;

  Vector[][][] worldBoxArray;

  Vector3i myOldPosition;

  boolean storedInArray;

  float cameraHeight;

  Grid(Vector3f worldBox, 
    Vector3f translateOrigin, 
    float gridCellSize, 
    float cameraHeight, 
    Vector[][][] pWorldBoxArray) {
    this.worldBox.set(worldBox);
    this.translateOrigin.set(translateOrigin);
    this.gridCellSize = gridCellSize;
    this.cameraHeight = cameraHeight;
    setPrivateVariables();
    if (pWorldBoxArray != null) {
      setWorldArray(pWorldBoxArray);
    }
  }


  void setWorldArray(Vector[][][] pWorldBoxArray) {
    // setup the object to store old object position
    myOldPosition = new Vector3i();
    storedInArray = false;
    // set pointer to array
    worldBoxArray = pWorldBoxArray;
    // check if array is compatible with pointer
    if (worldBoxArray.length != worldBoxArraySizeX
      || worldBoxArray[0].length != worldBoxArraySizeY
      || worldBoxArray[0][0].length != worldBoxArraySizeZ) {
      println("### ERROR problem with dimensions of assigned array");
      println("###       required " +
        worldBoxArraySizeX + " " +
        worldBoxArraySizeY + " " +
        worldBoxArraySizeZ);
      println("###       got " + worldBoxArray.length +
        " " + worldBoxArray[0].length +
        " " + worldBoxArray[0][0].length);
    }
  }


  void setPrivateVariables() {
    storedInArray = false;
    worldBoxArraySizeX = (int) (worldBox.x / gridCellSize);
    worldBoxArraySizeY = (int) (worldBox.y / gridCellSize);
    worldBoxArraySizeZ = (int) (worldBox.z / gridCellSize);
  }


  void reset() {
    worldBox.set(myGridSize);
    translateOrigin.set(myGridOffset);
    gridCellSize = gridCellSize;
    cameraHeight = 520.0f;
    setPrivateVariables();
  }


  int[] getRequiredArraySize(Vector3f worldBox, float gridCellSize) {
    return new int[] {
      (int) (worldBox.x / gridCellSize), 
      (int) (worldBox.y / gridCellSize), 
      (int) (worldBox.z / gridCellSize)};
  }


  void initArray(Vector[][][] worldBoxArray) {
    for (int x = 0; x < worldBoxArray.length; x++) {
      for (int y = 0; y < worldBoxArray[0].length; y++) {
        for (int z = 0; z < worldBoxArray[0][0].length; z++) {
          worldBoxArray[x][y][z] = new Vector();
        }
      }
    }
  }


  /* convert a grid value to an array value */
  int grid2Array(int g) {
    if (g >= 0) {
      /* even value are postiv postions */
      g *= 2;
    } else {
      /* odd values are negativ positions */
      g *= -2;
      g -= 1;
    }
    return (int) g;
  }


  /* convert an array value to a grid value */
  int array2Grid(int a) {
    if (Math.ceil( (double) a / 2) != (double) a / 2) {
      a += 1;
      a /= -2;
    } else {
      a /= 2;
    }
    return (int) a;
  }


  /* convert a grid value to a postion */
  float grid2Position(int g) {
    return (float) g * gridCellSize;
  }


  /* convert a postion to a grid value */
  int position2Grid(float position) {
    return (int) floor(position / gridCellSize);
  }


  /* convert a postion vector to an array of grid values */
  int[] position2Grid(Vector3f position) {
    return new int[] {
      (int) floor(position.x / gridCellSize), 
      (int) floor(position.y / gridCellSize), 
      (int) floor(position.z / gridCellSize)};
  }


  /* convert a postion to an array value */
  int postion2Array(float position) {
    return grid2Array(position2Grid(position));
  }


  /* convert a postion vector to an array value */
  int[] position2Array(Vector3f v) {
    return new int[] {
      (int) (postion2Array(v.x - translateOrigin.x)), 
      (int) (postion2Array(v.y - translateOrigin.y)), 
      (int) (postion2Array(v.z - translateOrigin.z))
    };
  }


  /* convert an array value to a postion */
  float array2Postion(int a) {
    return grid2Position(array2Grid(a));
  }


  /* convert three array values to a postion */
  Vector3f array2Position(int x, int y, int z) {
    return new Vector3f(array2Postion(x) + translateOrigin.x, 
      array2Postion(y) + translateOrigin.y, 
      array2Postion(z) + translateOrigin.z);
  }


  /* write to the array and manage the objects occurence in the array */
  boolean writeVehicleObjectToArray(float x, float y, float z, Object vehicleObject) {
    int[] a = position2Array(new Vector3f(x, y, z));
    int xA = a[0];
    int yA = a[1];
    int zA = a[2];
    /* is value out of bound? */
    boolean outOfBound = true;
    if (xA > worldBoxArraySizeX - 1) {
      xA = worldBoxArraySizeX - 1;
    } else if (yA > worldBoxArraySizeY - 1) {
      yA = worldBoxArraySizeY - 1;
    } else if (zA > worldBoxArraySizeZ - 1) {
      zA = worldBoxArraySizeZ - 1;
    } else if (xA < 0) {
      xA = 0;
    } else if (yA < 0) {
      yA = 0;
    } else if (zA < 0) {
      zA = 0;
    } else {
      outOfBound = false;
    }
    if (outOfBound) {
      // if we left the world box we need to be removed
      if (storedInArray && !removeVehicleObjectFromBox(vehicleObject)) {
        println("### WARNING couldn t remove VehicleObject from Array *oob");
      }
    } else {
      Vector myVector;
      // did we leave current cube
      if (myOldPosition.x != xA || myOldPosition.y != yA || myOldPosition.z != zA) {
        // remove object from old cube and check if it worked
        if (storedInArray && !removeVehicleObjectFromBox(vehicleObject)) {
          println("### WARNING couldn t remove VehicleObject from Array");
        }
        // and write object to new cube
        myVector = worldBoxArray[xA][yA][zA];
        myVector.add(vehicleObject);
        // remember that we stored something in the array
        storedInArray = true;
        // store current position to check the leaving of a cube
        myOldPosition.set(xA, yA, zA);
      }
    }
    return outOfBound;
  }


  /* removes the object from the array by look through the wjole thing */
  boolean removeVehicleObjectFromArray(Object vehicleObject) {
    // going through the whole array to delete object is VERY COSTLY!
    Vector myVector = worldBoxArray[myOldPosition.x][myOldPosition.y][myOldPosition.z];
    if (myVector.remove(vehicleObject)) {
      storedInArray = false;
      return true;
    } else {
      return false;
    }
  }


  /* removes the object from the array looking in the current box */
  boolean removeVehicleObjectFromBox(Object vehicleObject) {
    Vector myVector = worldBoxArray[myOldPosition.x][myOldPosition.y][myOldPosition.z];
    // remove object from old cube
    if (myVector.remove(vehicleObject)) {
      storedInArray = false;
      return true;
    } else {
      return false;
    }
  }


  /* change a position value to a frustum value */
  float position2Frustum(float objectDepth, float objectPosition, float screenSize) {
    float difference = getPositionFrustumDifference(objectDepth, screenSize) - screenSize * 0.5f;
    return objectPosition - difference * (objectPosition / (difference + screenSize * 0.5f));
  }


  float position2FrustumZ(float objectDepth, float objectPosition) {
    return position2Frustum(objectDepth, objectPosition, worldBox.z);
  }


  float position2FrustumX(float objectDepth, float objectPosition) {
    return position2Frustum(objectDepth, objectPosition, worldBox.x);
  }


  /* change a frustum value to a position value */
  float frustum2Position(float objectDepth, float objectPosition, float screenSize) {
    float difference = getPositionFrustumDifference(objectDepth, screenSize) - screenSize * 0.5f;
    return objectPosition + difference * (objectPosition / (screenSize * 0.5f));
  }


  float frustum2PositionZ(float objectDepth, float objectPosition) {
    return frustum2Position(objectDepth, objectPosition, worldBox.z);
  }


  float frustum2PositionX(float objectDepth, float objectPosition) {
    return frustum2Position(objectDepth, objectPosition, worldBox.x);
  }


  /* calculate the difference between a numeric position and
   * the percepted position due to perspektiv distortion
   */
  float getPositionFrustumDifference(float objectDepth, float screenSize) {
    return (cameraHeight - objectDepth) * (screenSize * 0.5f) / cameraHeight;
  }


  void drawPosition(Vector3f myPosition) {
    Vector3f p = new Vector3f();
    p.x = position2Grid(myPosition.x) * gridCellSize;
    p.y = position2Grid(myPosition.y) * gridCellSize;
    p.z = position2Grid(myPosition.z) * gridCellSize;

    noFill();
    stroke(color(0, 255, 0, 150));
    float n = gridCellSize * 0.2f;
    line(p.x + n, p.y, p.z + n, p.x + gridCellSize - n, p.y, p.z + gridCellSize - n);
    line(p.x + gridCellSize - n, p.y, p.z + n, p.x + n, p.y, p.z + gridCellSize - n);

    pushMatrix();
    translate(p.x + gridCellSize * 0.5f, p.y, p.z + gridCellSize * 0.5f);
    rotateX(PI * 0.5f);
    rect(0, 0, gridCellSize, gridCellSize);
    popMatrix();
  }


  void draw() {
    noFill();
    Vector myVector;
    for (int x = 0; x < worldBoxArraySizeX; x++) {
      for (int y = 0; y < worldBoxArraySizeY; y++) {
        for (int z = 0; z < worldBoxArraySizeZ; z++) {
          myVector = worldBoxArray[x][y][z];
          if (myVector.size() > 0) {
            stroke(color(255, 0, 0, myVector.size() * 50));
          } else {
            stroke(color(0, 0, 0, 2));
          }
          Vector3f p = array2Position(x, y, z);
          Vector3f p1 = new Vector3f(frustum2PositionX(p.y, p.x), 
            p.y, 
            frustum2PositionZ(p.y, p.z));
          Vector3f p2 = new Vector3f(frustum2PositionX(p.y, p.x), 
            p.y, 
            frustum2PositionZ(p.y, p.z + gridCellSize));
          Vector3f p3 = new Vector3f(frustum2PositionX(p.y, p.x + gridCellSize), 
            p.y, 
            frustum2PositionZ(p.y, p.z + gridCellSize));
          Vector3f p4 = new Vector3f(frustum2PositionX(p.y, p.x + gridCellSize), 
            p.y, 
            frustum2PositionZ(p.y, p.z));
          Vector3f p5 = new Vector3f(frustum2PositionX(p.y + gridCellSize, p.x), 
            p.y + gridCellSize, 
            frustum2PositionZ(p.y + gridCellSize, p.z));
          Vector3f p6 = new Vector3f(frustum2PositionX(p.y + gridCellSize, p.x), 
            p.y + gridCellSize, 
            frustum2PositionZ(p.y + gridCellSize, p.z + gridCellSize));
          Vector3f p7 = new Vector3f(frustum2PositionX(p.y + gridCellSize, p.x + gridCellSize), 
            p.y + gridCellSize, 
            frustum2PositionZ(p.y + gridCellSize, p.z + gridCellSize));
          Vector3f p8 = new Vector3f(frustum2PositionX(p.y + gridCellSize, p.x + gridCellSize), 
            p.y + gridCellSize, 
            frustum2PositionZ(p.y + gridCellSize, p.z));
          beginShape(LINES);
          vertex(p1.x, p1.y, p1.z);
          vertex(p2.x, p2.y, p2.z);
          vertex(p3.x, p3.y, p3.z);
          vertex(p4.x, p4.y, p4.z);
          endShape(CLOSE);
          beginShape(LINES);
          vertex(p5.x, p5.y, p5.z);
          vertex(p6.x, p6.y, p6.z);
          vertex(p7.x, p7.y, p7.z);
          vertex(p8.x, p8.y, p8.z);
          endShape(CLOSE);
          beginShape(LINES);
          vertex(p1.x, p1.y, p1.z);
          vertex(p5.x, p5.y, p5.z);
          vertex(p2.x, p2.y, p2.z);
          vertex(p6.x, p6.y, p6.z);
          vertex(p3.x, p3.y, p3.z);
          vertex(p7.x, p7.y, p7.z);
          vertex(p4.x, p4.y, p4.z);
          vertex(p8.x, p8.y, p8.z);
          endShape();
        }
      }
    }
  }
}
