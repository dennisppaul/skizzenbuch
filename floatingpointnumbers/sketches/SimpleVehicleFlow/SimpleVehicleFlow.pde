import mathematik.Vector3f;

import processing.core.PApplet;
import processing.core.PFont;


Circle[] circleArray = new Circle[40];

SimpleVehicle[] vehicleArray = new SimpleVehicle[400];

boolean backgroundFlag = false;

float[] field = {0, 0, 400, 600};

Vector3f obstacle = new Vector3f();

int vehicleCounter = 0;

int circleCounter = 0;

boolean drawLine = false;

PFont myNumberFont;

PFont myOSDFont;

int baseColor = 0;

public void setup() {
  size(400, 600, P3D);
  frameRate(60);

  /* font */
  myOSDFont = loadFont("HelveticaNeue-CondensedBlack-14.vlw");
  myNumberFont = loadFont("Sabon_Italic_Oldstyle_Figures.vlw");
  textFont(myOSDFont);

  // circle
  ellipseMode(CENTER);
  rectMode(CENTER);

  // kill circle objects
  for (int i = 0; i < circleArray.length; i++) {
    circleArray[i] = null;
  }

  noFill();
  for (int i = 0; i < vehicleArray.length; i++) {
    int c = color(255, 255, 255, 50 + 50 * ( (float) i / vehicleArray.length));
    vehicleArray[i] = new SimpleVehicle(c, 1.5f, (int) random(200));
    vehicleArray[i].position.x = 0.0f;
    vehicleArray[i].position.y = -random(200) - 200;
    vehicleArray[i].home.y = -random(200) - 200;
    vehicleArray[i].position.z = random(getBorderByDepth(600, vehicleArray[i].position.y, 600)) -
      0.5f * (getBorderByDepth(600, vehicleArray[i].position.y, 600));
  }
}


public void draw() {
  // setup view
  background(255);

  drawOSD(myOSDFont, 5, 15, 
    "FLOATING.NUMBERS\n\n" +
    "'CLICK' TO ATTRACT VEHICLE TO SURFACE\n" +
    "'R' AND 'R'+SHIFT TO SWITCH SHAPE\n" +
    "'Q' TO RESET VIEW\n" +
    "ARROW KEYS FOR NAVIGATION");

  setupViewer();

  // obstacle
  obstacle.x = mouseX - 200;
  obstacle.z = -mouseY + 300;

  // draw object
  pushMatrix();
  for (int i = 0; i < vehicleArray.length; i++) {
    vehicleArray[i].cycle();
  }
  popMatrix();

  // circle
  pushMatrix();
  for (int i = 0; i < circleArray.length; i++) {
    Circle myCircle = circleArray[i];
    // cycle each circle
    if (myCircle != null) {
      myCircle.cycle();
    }
  }
  popMatrix();
}


void drawOSD(PFont myOSDFont, int x, int y, String myText) {
  textMode(SCREEN);
  textAlign(LEFT);
  fill(color(0, 0, 0, 150));
  textFont(myOSDFont);
  text(myText, x, y);
}


/* simpleViewer */
float getBorderByDepth(float camDepth, float objDepth, float boxRange) {
  // camDepth is a positiv value
  // objDepth is a negativ value
  // boxSize is an arbitrary value
  return (abs(objDepth) + camDepth) * boxRange / camDepth;
}


/* a very simple viewer */
int moveZ, moveY, moveX;

float rotX = 50;

float rotY = 50;

float rotZ = 0;

void setupViewer() {
  noFill();
  stroke(color(baseColor, baseColor, baseColor, 20));
  translate(200 + moveX, 300 + moveY, -300 + moveZ);
  rotateX(radians(rotX) + PI / 2);
  rotateY(radians(rotY));
  box(400, 600, 600);
  translate(0, 300, 0);
}


void startRipple(int x, int y) {
  circleArray[circleCounter++] = new Circle(x, y);
  circleCounter = circleCounter % circleArray.length;
}


public void mousePressed() {
  if (vehicleArray[0].state == SimpleVehicle.FLOAT) {
    vehicleArray[0].state = SimpleVehicle.SURFACE;
  } else {
    if (vehicleArray[0].position.y > -20) {
      startRipple( (int) vehicleArray[0].position.x, - (int) vehicleArray[0].position.z);
    }
    vehicleArray[0].state = SimpleVehicle.DIVE;
  }
}


boolean toggleShift;

public void keyPressed() {
  // camera control
  int speed = 10;

  if (keyCode == SHIFT) {
    toggleShift = !toggleShift;
    println("shift: " + toggleShift);
  }

  if (toggleShift) {
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

  if (key == 'q') {
    moveX = 0;
    moveY = 0;
    moveZ = 0;
    rotX = 0;
    rotY = 0;
    rotZ = 0;
  }
  // object
  if (key == 'r') {
    for (int i = 0; i < vehicleArray.length; i++) {
      vehicleArray[i].myRotationType = vehicleArray[i].SMOOTH;
    }
  }
  if (key == 'R') {
    for (int i = 0; i < vehicleArray.length; i++) {
      vehicleArray[i].myRotationType = vehicleArray[i].NORMAL;
    }
  }
  if (key == 'l') {
    drawLine = !drawLine;
  }
  if (key == 'o') {
    value_a -= 0.1f;
  }
  if (key == 'p') {
    value_a += 0.1f;
  }
  if (key == 'k') {
    value_b -= 10f;
  }
  if (key == 'l') {
    value_b += 10f;
  }
  if (key == 'i') {
    println("value_a: " + value_a + " / value_b: " + value_b);
  }
}


float value_a = 6.1f;

float value_b = 71.0f;

void drawShape(Vector3f position, 
  Vector3f velocity, 
  int myRotationType, 
  int objState, 
  int number, 
  SimpleVehicle me, 
  float rotationOffset) {

  float orientation;

  // color
  float myAlpha = value_b + ( (float) me.position.y / value_a);
  int myColor = color(100, 100, 100, myAlpha);

  switch (objState) {
  case SimpleVehicle.FLOAT:
    myColor = color(baseColor, baseColor, baseColor, myAlpha);
    break;

  case SimpleVehicle.SURFACE:
    myColor = color(0, 255, 0, myAlpha);
    break;

  case SimpleVehicle.FOLLOW:
    myColor = color(255, 0, 0, myAlpha);
    break;

  case SimpleVehicle.CONTENT:
    myColor = color(255, 128, 0);
    pushMatrix();
    translate(me.content.x, me.content.y, me.content.z);
    stroke(100, 100, 100);
    rotateX( -PI * 0.5f);
    rect(0, 0, 50, 50);
    popMatrix();
    break;

  case SimpleVehicle.DIVE:
    myColor = color(0, 128, 255);
    break;
  }

  // draw shape
  pushMatrix();
  translate(position.x, position.y, position.z);
  switch (myRotationType) {

  case SimpleVehicle.NORMAL:
    noFill();
    stroke(myColor);
    if (drawLine) {
      line(0, 0, 0, velocity.x * 10, velocity.y * 10, velocity.z * 10);
    }
    orientation = atan2(velocity.x, velocity.z);
    rotateY(orientation + rotationOffset);
    box(10, 5, 20);
    break;

  case SimpleVehicle.SMOOTH:
    stroke(myColor);
    if (drawLine) {
      line(0, 0, 0, velocity.x * 10, velocity.y * 10, velocity.z * 10);
    }
    noStroke();
    fill(myColor);
    orientation = atan2(velocity.x, velocity.z);
    rotateY(orientation + rotationOffset);
    translate(0, 10);
    rotateX(PI * -0.5f);

    textMode(MODEL);
    textFont(myNumberFont, 36);
    textAlign(CENTER);
    text(number, 0, 0);

    break;
  }
  popMatrix();
}


class SimpleVehicle {
  float massReset;

  float mass;

  public Vector3f position = new Vector3f();

  public Vector3f velocity = new Vector3f(0.0f, 0.0f, 1.0f);

  float max_force = 0.1f;

  float max_speed = 2.0f;

  float steering_offset = 0.2f;

  float steering_max_change = 0.1f;

  float steering_limit = 0.3f;

  private Vector3f steering_direction_wandering = new Vector3f();

  float random_velocity_offset = 0;

  float random_velocity_change = 0.0005f;

  float random_velocity_limit = 0.001f;

  private Vector3f steering_direction_stayHome = new Vector3f();

  private Vector3f steering_direction_obstacleAvoid = new Vector3f();

  private Vector3f steering_direction = new Vector3f();

  private Vector3f steering_force = new Vector3f();

  private Vector3f acceleration = new Vector3f();

  private Vector3f steering_direction_current = new Vector3f(0.0, 0.0f, -1.0);

  int myColor;

  private Vector3f home = new Vector3f(0.0f, 0.0f, 0.0f);

  public Vector3f content = new Vector3f(150.0f, 0.0f, 180.0f);

  float orientation = atan2(velocity.z, velocity.x);

  final static int NORMAL = 0;

  final static int SMOOTH = 1;

  int myRotationType = NORMAL;

  int number;

  int myTextSize;

  float rotationOffset = 0.0f;

  float rotationOffsetChange = random(100) / 10000.0f - 0.005f;

  final static int FLOAT = 0;

  final static int SURFACE = 1;

  final static int FOLLOW = 2;

  final static int CONTENT = 3;

  final static int DIVE = 4;

  int state = FLOAT;

  SimpleVehicle(int c, float tMass, int number) {
    myColor = c;
    mass = tMass;
    massReset = tMass;
    this.number = number;
    myTextSize = (int) random(2, 8) * 16;
  }


  /* calculate the rotation by the velocity vector */
  float getNORMALRotation(Vector3f velocity) {
    return atan2(velocity.z, velocity.x);
  }


  void changeToSurfaceState() {
    state = SURFACE;
  }


  void cycle() {
    // wandering
    steering_direction_wandering.normalize(velocity);
    steering_direction_wandering.cross(new Vector3f(0.0f, 1.0f, 0.0f), steering_direction_wandering);
    steering_offset += (float) Math.random() * steering_max_change - steering_max_change * 0.5f;
    steering_offset = (float) Math.min(steering_limit, steering_offset);
    steering_offset = (float) Math.max( -steering_limit, steering_offset);
    steering_direction_wandering.scale(steering_offset);

    // random_velocity_offset
    random_velocity_offset += (float) Math.random() * random_velocity_change - random_velocity_change * 0.5f;
    random_velocity_offset = (float) Math.min(random_velocity_limit, random_velocity_offset);
    random_velocity_offset = (float) Math.max( -random_velocity_limit, random_velocity_offset);

    Vector3f tVektor = new Vector3f();
    tVektor.scale(random_velocity_offset, velocity);
    steering_direction_wandering.add(tVektor);

    // steering.stayHome
    switch (state) {
    default:
      steering_direction_stayHome.sub(home, position);
      steering_direction_stayHome.z = 0.0f; // make it 1D
      steering_direction_stayHome.normalize();
      steering_direction_stayHome.scale(steering_limit);
      break;
    }
    // steering.obstacleAvoid -> is now follow mouse
    if (state == CONTENT || state == SURFACE) {
      steering_direction_obstacleAvoid.sub(content, position);
    } else {
      steering_direction_obstacleAvoid.sub(obstacle, position);
    }
    steering_direction_obstacleAvoid.normalize();
    steering_direction_obstacleAvoid.scale(steering_limit);

    // steering.current
    steering_direction_current = new Vector3f(0.0f, 0.0f, 1.0f);

    // addVectors with relevance
    float wanderingRelevance = 0.0f;
    float stayHomeRelevance = 0.0f;
    float currentRelevance = 0.0f;
    float obstacleAvoidRelevance = 0.0f;
    switch (state) {
    case FOLLOW:
      max_speed = 3.0f;
      mass = 0.5f;
      wanderingRelevance = 0.2f;
      stayHomeRelevance = 0.0f;
      obstacleAvoidRelevance = 0.8f;
      currentRelevance = 0.0f;
      break;
    case FLOAT:
      max_speed = 1.0f;
      mass = massReset;
      wanderingRelevance = 0.5f;
      stayHomeRelevance = 0.25f;
      obstacleAvoidRelevance = 0.0f;
      currentRelevance = 0.25f;
      break;
    case SURFACE:
      max_speed = 2.0f;
      mass = 0.5f;
      wanderingRelevance = 0.4f;
      stayHomeRelevance = 0.0f;
      obstacleAvoidRelevance = 0.6f;
      currentRelevance = 0.0f;
      break;
    case CONTENT:
      max_speed = 1.0f;
      mass = 2.0f;
      wanderingRelevance = 0.5f;
      stayHomeRelevance = 0.0f;
      obstacleAvoidRelevance = 0.5f;
      currentRelevance = 0.0f;
      break;
    case DIVE:
      max_speed = 4.0f;
      mass = 0.5f;
      wanderingRelevance = 0.1f;
      stayHomeRelevance = 0.8f;
      obstacleAvoidRelevance = 0.0f;
      currentRelevance = 0.1f;
      break;
    }

    // add vectors with relevance
    steering_direction_wandering.scale(wanderingRelevance);
    steering_direction_stayHome.scale(stayHomeRelevance);
    steering_direction_obstacleAvoid.scale(obstacleAvoidRelevance);
    steering_direction_current.scale(currentRelevance);
    steering_direction.add(steering_direction_wandering, steering_direction_stayHome);
    steering_direction.add(steering_direction_obstacleAvoid);
    steering_direction.add(steering_direction_current);

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
    mass = massReset;

    float border = getBorderByDepth(600, position.y, 600) * 0.5f + 30.0f;

    // reset object
    if (position.z > border) {
      position.z = -border;
    }
    if (position.z < -border) {
      position.z = border;
    }

    // check states
    if (state == SURFACE && position.y > -1.0f) {
      println("switch to CONTENT state");
      startRipple( (int) position.x, - (int) position.z);
      state = CONTENT;
    }
    if (state == DIVE && position.y < -250.0f) {
      println("switch to FLOAT state");
      state = FLOAT;
    }

    rotationOffset += rotationOffsetChange;

    drawShape(position, 
      velocity, 
      myRotationType, 
      state, 
      number, 
      this, 
      rotationOffset);
  }
}


class Circle {

  int myTime;

  Vector3f position = new Vector3f();

  float s = 0.5f;

  Circle(float x, float y) {
    position.x = x;
    position.z = y;
    myTime = 0;
  }


  void cycle() {
    // do stuff if time is < lifeTime
    if (myTime < 45) {
      myTime++;
      noFill();
      int c = color(baseColor, baseColor, baseColor, 50 - myTime);
      stroke(c);
      pushMatrix();
      rotateX(PI * -0.5f);
      ellipse(position.x, position.z, (myTime * 3 * s), (myTime * 3 * s));
      ellipse(position.x, position.z, (myTime * 4 * s), (myTime * 4 * s));
      ellipse(position.x, position.z, (myTime * 5 * s), (myTime * 5 * s));
      ellipse(position.x, position.z, (myTime * 6 * s), (myTime * 6 * s));
      ellipse(position.x, position.z, (myTime * 7 * s), (myTime * 7 * s));
      popMatrix();
    }
  }
}
