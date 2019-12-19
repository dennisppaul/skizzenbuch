import mathematik.Vector3f;

import processing.core.PApplet;
import processing.core.PFont;

Trail[] trailArray = new Trail[400];

SimpleVehicle[] vehicleArray = new SimpleVehicle[10];

boolean backgroundFlag = false;

float[] field = {0, 0, 400, 600};

Vector3f obstacle = new Vector3f();

int vehicleCounter = 0;

int trailCounter = 0;

boolean drawLine = false;

boolean drawTrails = true;

PFont myNumberFont;

PFont myOSDFont;

public void setup() {
  size(400, 600, P3D);
  background(255);
  frameRate(60);
  noFill();

  // font
  myOSDFont = loadFont("HelveticaNeue-CondensedBlack-14.vlw");
  myNumberFont = loadFont("Sabon_Italic_Oldstyle_Figures.vlw");
  textFont(myOSDFont);

  // circle
  ellipseMode(CENTER);

  // kill circle objects
  for (int i = 0; i < trailArray.length; i++) {
    trailArray[i] = null;
  }

  for (int i = 0; i < vehicleArray.length; i++) {
    int c = color(255, 255, 255, 50 + 50 * ( (float) i / vehicleArray.length));
    vehicleArray[i] = new SimpleVehicle(c, 2.5f, (int) random(20));
    vehicleArray[i].position.x = random(400) - 200;
    vehicleArray[i].position.y = 0;
    vehicleArray[i].position.z = random(660) - 330;
  }
}


public void draw() {
  background(255);

  drawOSD(myOSDFont, 5, 15, 
    "FLOATING.NUMBERS\n\n" +
    "'CLICK' TO ATTRACT VEHICLE\n" +
    "'T' TO TOGGLE TRAILS\n" +
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
  if (drawTrails) {
    pushMatrix();
    for (int i = 0; i < trailArray.length; i++) {
      Trail myTrail = trailArray[i];
      // cycle each circle
      if (myTrail != null) {
        myTrail.cycle();
      }
    }
    popMatrix();
  }
}


void drawOSD(PFont myOSDFont, int x, int y, String myText) {
  textMode(SCREEN);
  textAlign(LEFT);
  fill(color(0, 0, 0, 150));
  textFont(myOSDFont);
  text(myText, x, y);
}


/** simpleViewer
 */
float getBorderByDepth(float camDepth, float objDepth, float boxRange) {
  // camDepth is a positiv value
  // objDepth is a negativ value
  // boxSize is an arbitrary value
  return (abs(objDepth) + camDepth) * boxRange / camDepth;
}


/** a very simple viewer
 */
int moveZ, moveY, moveX;

float rotX = 0;

float rotY = 0;

float rotZ = 0;

void setupViewer() {
  noFill();
  stroke(0);
  translate(200 + moveX, 300 + moveY, -300 + moveZ);
  rotateX(radians(rotX) + PI / 2);
  rotateY(radians(rotY));
  stroke(0);
  translate(0, 300, 0);
}


public void mousePressed() {
  vehicleArray[vehicleCounter].toggleFollow = !vehicleArray[vehicleCounter].toggleFollow;
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
  // object
  if (key == 'r') {
    println("rotation type: SMOOTH");
    for (int i = 0; i < vehicleArray.length; i++) {
      vehicleArray[i].myRotationType = vehicleArray[i].SMOOTH;
    }
  }
  if (key == 'R') {
    println("rotation type: NORMAL");
    for (int i = 0; i < vehicleArray.length; i++) {
      vehicleArray[i].myRotationType = vehicleArray[i].NORMAL;
    }
  }
  if (key == 'l') {
    drawLine = !drawLine;
  }
  if (key == 't') {
    drawTrails = !drawTrails;
  }
}


void drawShape(Vector3f position, 
  Vector3f velocity, 
  int myRotationType, 
  boolean toggleFollow, 
  int number) {

  final int NORMAL = 0;
  final int SMOOTH = 1;
  float orientation;
  int myColor = 0;

  // draw shape
  noFill();
  stroke(myColor);

  pushMatrix();
  translate(position.x, position.y, position.z);
  switch (myRotationType) {
  case NORMAL:
    if (toggleFollow) {
      stroke(255, 0, 0);
    } else {
      stroke(color(myColor, myColor, myColor, 50));
    }
    if (drawLine) {
      line(0, 0, 0, velocity.x * 10, velocity.y * 10, velocity.z * 10);
    }
    orientation = atan2(velocity.x, velocity.z);
    rotateY(orientation);
    box(10, 5, 20);
    break;

  case SMOOTH:
    if (toggleFollow) {
      fill(255, 0, 0);
    } else {
      fill(myColor);
    }
    if (drawLine) {
      line(0, 0, 0, velocity.x * 10, velocity.y * 10, velocity.z * 10);
    }
    orientation = atan2(velocity.x, velocity.z);
    rotateY(orientation);
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

  float orientation = atan2(velocity.z, velocity.x);

  final int NORMAL = 0;

  final int SMOOTH = 1;

  int myRotationType = NORMAL;

  int number;

  int myTextSize;

  int counter = 0;

  boolean toggleFollow = false;

  final int FLOAT = 0;

  final int SURFACE = 1;

  int objectState = FLOAT;

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
    steering_direction_stayHome.sub(home, position);
    steering_direction_stayHome.z = 0.0f; // make it 1D
    steering_direction_stayHome.normalize();
    steering_direction_stayHome.scale(steering_limit);

    // steering.obstacleAvoid -> is now follow mouse
    steering_direction_obstacleAvoid.sub(obstacle, position);
    steering_direction_obstacleAvoid.normalize();
    steering_direction_obstacleAvoid.scale(steering_limit);

    // steering.current
    steering_direction_current = new Vector3f(0.0f, 0.0f, 1.0f);

    // addVectors with relevance
    float wanderingRelevance;
    float stayHomeRelevance;
    float currentRelevance;
    float obstacleAvoidRelevance;
    if (toggleFollow) {
      max_speed = 1.5f;
      mass = 0.5f;
      wanderingRelevance = 0.2f;
      stayHomeRelevance = 0.0f;
      obstacleAvoidRelevance = 0.8f;
      currentRelevance = 0.0f;
    } else {
      max_speed = 1.0f;
      mass = massReset;
      wanderingRelevance = 0.6f;
      stayHomeRelevance = 0.2f;
      obstacleAvoidRelevance = 0.0f;
      currentRelevance = 0.2f;
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
    if (position.z > border) {
      position.z = -border;
    }
    if (position.z < -border) {
      position.z = border;
    }

    drawShape(position, 
      velocity, 
      myRotationType, 
      toggleFollow, 
      number);

    // trails
    counter++;
    if (counter == 3) {
      spawnTrail(position, velocity);
      counter = 0;
    }
  }
}


void spawnTrail(Vector3f position, Vector3f velocity) {
  trailArray[trailCounter++] = new Trail(position, velocity);
  trailCounter = trailCounter % trailArray.length;
}


class Trail {

  int myTime;

  int lifeTime = 50;

  int baseColor = 0;

  float speed = 0.4f;

  int offset = 20;

  Vector3f position = new Vector3f();

  Vector3f velocity = new Vector3f();

  Vector3f trailPath;

  Trail(Vector3f aPosition, Vector3f aVelocity) {
    position.set(aPosition);
    velocity.set(aVelocity);
    velocity.y = 0;
    velocity.normalize();
    myTime = 0;
    trailPath = new Vector3f();
    trailPath.cross(new Vector3f(0.0f, 1.0f, 0.0f), velocity);
    trailPath.normalize();
  }


  void cycle() {

    if (myTime < lifeTime) {
      // draw object
      int myColor = color(baseColor, baseColor, baseColor, 100 - (float) myTime / (float) lifeTime * 50);
      stroke(myColor);
      noFill();

      pushMatrix();
      translate(position.x, position.y, position.z);
      Vector3f v = new Vector3f();
      v.scale( (myTime + offset) * speed, trailPath);
      point( (int) v.x, 0, (int) v.z);
      point( - (int) v.x, 0, - (int) v.z);
      popMatrix();
      myTime++;
    }
  }
}
