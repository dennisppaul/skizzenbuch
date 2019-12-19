import mathematik.Vector3f;

import processing.core.PApplet;
import processing.core.PFont;


SimpleVehicle[] vehicleArray = new SimpleVehicle[20];

boolean backgroundFlag = false;

float[] field = {0, 0, 400, 600};

Vector3f obstacle = new Vector3f();

int vehicleCounter = 0;

boolean drawLine = true;

boolean drawColor = false;

PFont myOSDFont;

int baseColor = 0;

public void setup() {
  size(400, 600, P3D);

  frameRate(60);
  rectMode(CENTER);

  /* font */
  myOSDFont = loadFont("HelveticaNeue-CondensedBlack-14.vlw");
  textFont(myOSDFont);
  textMode(SCREEN);
  textAlign(LEFT);

  noFill();
  for (int i = 0; i < vehicleArray.length; i++) {
    vehicleArray[i] = new SimpleVehicle();
    vehicleArray[i].behavior.setPosition(0.0f, 0.0f, random(200) - 100);
  }
}


public void draw() {
  // setup view
  background(255);

  drawOSD(5, 15, 
    "FLOATING.NUMBERS\n\n");

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
}


void drawOSD(int x, int y, String myText) {
  fill(color(0, 0, 0, 150));
  text(myText, x, y);
}


/* simpleViewer     */
float getBorderByDepth(float camDepth, float objDepth, float boxRange) {
  // camDepth is a positiv value
  // objDepth is a negativ value
  // boxSize is an arbitrary value
  return (abs(objDepth) + camDepth) * boxRange / camDepth;
}


int moveZ, moveY, moveX;

float rotX = 0;

float rotY = 0;

float rotZ = 0;

void setupViewer() {
  noFill();
  stroke(color(baseColor, baseColor, baseColor, 20));
  translate(200 + moveX, 300 + moveY, -300 + moveZ);
  rotateX(radians(rotX) + PI / 2);
  rotateY(radians(rotY));
  translate(0, 300, 0);
}


float value_a = 6.1f;

float value_b = 71.0f;

void drawShape(SimpleVehicle me) {

  Vector3f position = me.behavior.getPosition();
  Vector3f velocity = me.behavior.getVelocity();

  // color
  float myAlpha = value_b + ( (float) position.y / value_a);
  int myColor = color(baseColor, baseColor, baseColor, myAlpha);

  if (!drawColor) {
    myColor = color(baseColor, baseColor, baseColor, myAlpha);
  }

  // draw shape

  stroke(0);
  point(me.behavior.goToPoint.pointPosition.x, 0.0f, me.behavior.goToPoint.pointPosition.z);

  pushMatrix();
  translate(position.x, position.y, position.z);

  noFill();
  if (drawLine) {
    stroke(255, 0, 0);
    line(0, 0, 0, velocity.x * 10, velocity.y * 10, velocity.z * 10);
  }
  rotateY( (float) me.behavior.rotation.getSmoothVelocityRotation());
  int size = 5;
  stroke(255, 0, 0);
  line( -size, 0, 0, size, 0, 0);
  line(0, 0, size, 0, 0, 0);
  stroke(myColor);
  rotateX(PI / 2);
  quad( -size, -size, 
    size, -size, 
    size, size, 
    -size, size);

  popMatrix();
}


class SimpleVehicle {

  behavior.Behavior behavior = new behavior.Behavior();

  Vector3f velocity = behavior.velocity;

  Vector3f position = behavior.position;

  // behavior

  Vector3f direction_wandering = new Vector3f();

  Vector3f direction_stayHome = new Vector3f();

  Vector3f steering_direction = new Vector3f();

  // behavior relevance

  float wanderingRelevance = 0.7f;

  float goToRelevance = 0.3f;

  // physic

  Vector3f steering_force = new Vector3f();

  Vector3f acceleration = new Vector3f();

  float max_force = 0.3f;

  float max_speed = 0.1f;

  float massReset;

  float mass;

  int counter = (int) random( -10);


  SimpleVehicle() {
    mass = 1.0f;
    massReset = mass;
    // setup behaviors
    behavior.goToPoint.pointPosition = new Vector3f(random(100) - 50, 0.0f, random(100) - 50);
  }


  void cycle() {

    counter++;

    // wandering
    direction_wandering.set(behavior.wander.get());

    // stayHome
    direction_stayHome.set(behavior.goToPoint.get());

    // add vectors with relevance
    direction_wandering.scale(wanderingRelevance);
    direction_stayHome.scale(goToRelevance);
    steering_direction.add(direction_wandering, direction_stayHome);

    // physic
    steering_force.set(steering_direction);
    if (steering_force.length() > max_force) {
      steering_force.normalize();
      steering_force.scale(max_force);
    }
    acceleration.scale(1.0f / mass, steering_force);
    velocity.normalize();
    velocity.add(acceleration);

    /////////////
    /////////////
    /////////////

    if (counter < 4) {
      max_speed += 0.5f;
    } else if (counter > 8) {
      max_speed -= 0.02f;
      if (max_speed < 0.2f) {
        counter = 0;
        max_speed = 0.2f;
        wanderingRelevance = 0.5f;
        goToRelevance = 0.5f;
      }
    } else if (counter == 4) {
      wanderingRelevance = 0.8f;
      goToRelevance = 0.2f;
    }

    Vector3f v = new Vector3f();
    v.sub(position, behavior.goToPoint.pointPosition);
    if (v.length() < 15f) {
      behavior.goToPoint.pointPosition = new Vector3f(random(400) - 200, 0.0f, random(600) - 300);
    }

    /////////////
    /////////////
    /////////////

    velocity.normalize();
    velocity.scale(max_speed);

    position.add(velocity);

    // reset object
    float border = getBorderByDepth(600, position.y, 600) * 0.5f + 30.0f;
    if (position.z > border) {
      position.z = -border;
    }
    if (position.z < -border) {
      position.z = border;
    }

    behavior.rotation.calculateRotation();

    drawShape(this);
  }
}
