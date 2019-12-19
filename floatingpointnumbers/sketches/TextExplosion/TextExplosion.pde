import processing.core.PApplet;
import processing.core.PFont;
import mathematik.Vector3f;
import behavior.Behavior;

VehicleController vehicleController;

PFont myOSDFont;

public void setup() {
  size(400, 600, P3D);
  background(255);
  frameRate(60);
  vehicleController = new VehicleController(255);
  myOSDFont = loadFont("HelveticaNeue-CondensedBlack-14.vlw");
}


public void draw() {
  background(255);

  drawOSD(myOSDFont, 5, 15, 
    "FLOATING.NUMBERS\n\n" +
    "'CLICK' TO EXPLODE VEHICLES");

  vehicleController.cycle();
}


void drawOSD(PFont myFont, int x, int y, String myText) {
  textAlign(LEFT);
  fill(color(0, 0, 0, 150));
  textFont(myFont, 14);
  text(myText, x, y);
}


public void mousePressed() {
  for (int i = 0; i < vehicleController.vehicle.length; i++) {
    vehicleController.vehicle[i].setState(FloatVehicle.EXPLODING);
  }
}


class FloatVehicle {

  int ID;

  float xTextPosition;

  float yTextPosition;

  int counter;

  Vector3f finalTextPosition = new Vector3f();

  float myAlpha;

  // states

  static final int EXPLODING = 0;

  static final int FINDING = 1;

  static final int REMAINING = 2;

  static final int LEAVING = 3;

  static final int IDLE = 4;

  int state = IDLE;

  // behavior

  float rotation;

  Behavior behavior = new Behavior();

  Vector3f velocity = behavior.velocity;

  Vector3f position = behavior.position;

  Vector3f direction_wandering = new Vector3f();

  Vector3f direction_goto = new Vector3f();

  // behavior relevance

  float wanderingRelevance;

  float goToRelevance;

  // physic

  Vector3f steering_direction = new Vector3f();

  Vector3f steering_force = new Vector3f();

  Vector3f acceleration = new Vector3f();

  float max_force;

  float max_speed;

  float mass;

  FloatVehicle(int ID) {
    this.ID = ID;
    int numberOfCharactersPerLine = 32;
    yTextPosition = (float) Math.floor(ID / (float) numberOfCharactersPerLine);
    xTextPosition = ID - yTextPosition * numberOfCharactersPerLine;
    // setup vehicle
    reset();
  }


  void reset() {
    setState(IDLE);
  }


  void setState(int newState) {
    switch (newState) {

    case EXPLODING:

      // set initial position
      float startX = mouseX;
      float startY = mouseY;
      position.set(startX, 0.0f, startY);

      // set point to go to
      float randomValue = (float) Math.random() * 360;
      float radius = 100.0f + (float) Math.random() * 100.0f;
      float aimX = sin(randomValue) * radius + startX;
      float aimY = cos(randomValue) * radius + startY;
      behavior.goToPoint.pointPosition = new Vector3f(aimX, 0.0f, aimY);

      velocity.set(0.0f, 0.0f, 0.1f);
      wanderingRelevance = 0.0f;
      goToRelevance = 1.0f;
      max_force = 0.6f + (float) Math.random() * 0.3f;
      max_speed = 3.0f + (float) Math.random() * 2.0f;
      mass = 0.1f + (float) Math.random() * 0.1f;
      myAlpha = 255;
      counter = 0;
      break;

    case IDLE:
      wanderingRelevance = 0.8f;
      goToRelevance = 0.2f;
      max_force = 0.3f;
      max_speed = 1.0f;
      mass = 1.0f;
      myAlpha = 255;
      counter = 0;
      break;

    case FINDING:
      float textStartX = 150.0f;
      float textStartY = 300.0f;
      float spacerX = 5;
      float spacerY = 8;
      finalTextPosition = new Vector3f(textStartX + xTextPosition * spacerX, 0.0f, 
        textStartY + yTextPosition * spacerY);
      behavior.goToPoint.pointPosition = finalTextPosition;

      //
      wanderingRelevance = 0.2f;
      goToRelevance = 0.8f;
      max_force = 0.1f;
      max_speed = 4.0f;
      mass = 4.0f;
      counter = 0;
      break;

    case REMAINING:
      wanderingRelevance = 0.0f;
      goToRelevance = 0.0f;
      max_force = 0.1f;
      max_speed = 1.0f;
      mass = 1.0f;
      counter = 0;
      break;

    case LEAVING:

      // set point to go to
      randomValue = (float) Math.random() * 360;
      radius = 10.0f + (float) Math.random() * 150.0f;
      aimX = sin(randomValue) * radius + position.x;
      aimY = cos(randomValue) * radius + position.z;
      behavior.goToPoint.pointPosition = new Vector3f(aimX, 0.0f, aimY);
      velocity.set(1.0f, 0.0f, 0.0f);

      wanderingRelevance = 0.6f;
      goToRelevance = 0.4f;
      max_force = 0.4f;
      max_speed = 2.0f;
      mass = 2.0f;
      counter = 0;
      myAlpha = 255;
      break;
    }

    state = newState;
  }


  void cycle() {
    counter++;
    // select state
    switch (state) {
    case EXPLODING:
      if (counter > 10 && max_force > 0.2f) {
        max_force -= 0.1f;
      }
      if (counter > 5 && max_speed > 0.2f) {
        max_speed -= 0.18f;
      }
      if (counter == 25) {
        setState(FINDING);
      }
      break;
    case FINDING:
      if (counter > 10) {
        max_force = 0.5f;
      }
      if (mass > 0.2f) {
        mass -= 0.07;
      }

      // check distance to arrival position
      Vector3f distanceVector = new Vector3f();
      distanceVector.sub(finalTextPosition, position);
      float distance = distanceVector.length();
      if (distance < 10) {
        max_speed = distance / 2.5f;
        max_force = distance / 14.0f;
      }
      if (distance < 1) {
        setState(REMAINING);
      }
      break;

    case REMAINING:
      if (rotation > 0.01f || rotation < -0.01f) {
        rotation *= 0.8f;
      } else {
        position.set(finalTextPosition);
        rotation = 0.0f;
      }
      if (counter == 100) {
        setState(LEAVING);
      }
      break;

    case LEAVING:
      if (myAlpha > 5.0f) {
        myAlpha -= 5.0f;
      }
      if (counter == 150) {
        setState(IDLE);
      }
      break;

    case IDLE:
      behavior.goToPoint.pointPosition = new Vector3f(mouseX, 0.0f, mouseY);
      break;
    }

    if (state != REMAINING) {
      // wandering
      direction_wandering.set(behavior.wander.get());

      // stayHome
      direction_goto.set(behavior.goToPoint.get());

      // add vectors with relevance
      direction_wandering.scale(wanderingRelevance);
      direction_goto.scale(goToRelevance);

      steering_direction.set(0.0f, 0.0f, 0.0f);
      steering_direction.add(direction_goto);
      steering_direction.add(direction_wandering);

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
      rotation = atan2(velocity.z, velocity.x);
    }
  }
}


class VehicleController {

  FloatVehicle[] vehicle;

  VehicleController(int NumberOfVehicles) {
    vehicle = new FloatVehicle[NumberOfVehicles];
    for (int i = 0; i < vehicle.length; i++) {
      vehicle[i] = new FloatVehicle(i);
      vehicle[i].position.set(random(400), 0.0f, random(600));
    }
  }


  // cycle+draw objects
  void cycle() {
    for (int i = 0; i < vehicle.length; i++) {
      vehicle[i].cycle();
      this.draw(vehicle[i]);
    }
  }


  // draw object
  void draw(FloatVehicle me) {
    // get object properties
    Vector3f position = me.position;
    Vector3f velocity = me.velocity;
    float rotation = me.rotation;
    float myAlpha = me.myAlpha;

    boolean simple = false;
    noFill();
    if (simple) {
      stroke(color(0, 0, 0, myAlpha));
      point(position.x, position.z);
    } else {
      pushMatrix();
      translate(position.x, position.z);
      scale(0.4f);
      stroke(color(255, 0, 0, myAlpha));
      line(0, 0, velocity.x * 10, velocity.z * 10);
      rotate(rotation);
      stroke(color(0, 0, 0, myAlpha));
      rect( -20, -5, 20, 10);
      stroke(color(255, 0, 0, myAlpha));
      line(0, 0, -5, 0);
      popMatrix();
    }
  }
}


/* calculate the rotation by the velocity vector */
float getNORMALRotation(Vector3f velocity) {
  return atan2(velocity.z, velocity.x);
}
