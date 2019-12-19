import processing.core.PApplet;
import processing.core.PFont;
import mathematik.Vector3f;

SimpleVehicle mouseFollower = new SimpleVehicle(13);

int myColor;

public void setup() {
  size(400, 600, P3D);
  frameRate(60);
  background(255);

  // font
  PFont myFont = loadFont("HelveticaNeue-CondensedBlack-14.vlw");
  textFont(myFont);
  textMode(SCREEN);
}


public void draw() {
  background(255);
  drawOSD(5, 15, 
    "FLOATING.NUMBERS\n\n" +
    "'CLICK' TO ATTRACT THING");
  mouseFollower.cycle();
}


void drawOSD(int x, int y, String myText) {
  fill(color(0, 0, 0, 150));
  text(myText, x, y);
}


float constrainValue(float myValue) {
  myValue %= 2 * PI;
  if (myValue > PI) {
    myValue -= 2 * PI;
  }
  if (myValue < -PI) {
    myValue += 2 * PI;
  }
  return myValue;
}


class AbstractVehicle {

  protected Vector3f position = new Vector3f();

  protected Vector3f velocity = new Vector3f();

  protected float rotation;

  AbstractVehicle() {
  }


  // controller
  void cycle() {
  }


  // model
  void updatePosition() {
  }


  Vector3f getPosition() {
    return new Vector3f(position);
  }


  Vector3f getVelocity() {
    return new Vector3f(velocity);
  }


  float getRotation() {
    return rotation;
  }


  // view
  void draw() {
    pushMatrix();
    translate(position.x, position.z);
    rotate(rotation);
    int size = 5;
    noStroke();
    fill(color(0, 0, 0));
    quad( -size, -size, size, -size, size, size, -size, size);
    popMatrix();
  }
}


class MyTail
  extends AbstractVehicle {

  AbstractVehicle parent;

  float distance = 10f;

  MyTail(AbstractVehicle parent) {
    this.parent = parent;
  }


  void updatePosition() {
    velocity.set(position);
    velocity.sub(parent.getPosition());
    // get rotation
    rotation = atan2(velocity.z, velocity.x);
    // check to see we don t get 'null'
    float vLength = velocity.length();
    if (vLength == 0.0f) {
      velocity.set(1.0f, 0.0f, 0.0f);
    } else {
      // static distance
      float maxAngle = PI / 32;
      float myAngle = constrainValue(rotation - parent.getRotation());
      if (myAngle > maxAngle) {
        float myNewAngle = parent.getRotation() + maxAngle;
        velocity.set(cos(myNewAngle), 0f, sin(myNewAngle));
      } else if (myAngle < -maxAngle) {
        float myNewAngle = parent.getRotation() - maxAngle;
        velocity.set(cos(myNewAngle), 0f, sin(myNewAngle));
      } else {
        velocity.x /= vLength;
        velocity.y = 0f;
        velocity.z /= vLength;
      }
      velocity.scale(distance);
    }

    position.add(velocity, parent.getPosition());
  }
}


class SimpleVehicle
  extends AbstractVehicle {

  MyTail[] myTail;

  SimpleVehicle(int tailLength) {
    myTail = new MyTail[tailLength];
    myTail[0] = new MyTail(this);
    for (int i = 1; i < tailLength; i++) {
      myTail[i] = new MyTail(myTail[i - 1]);
    }
  }


  void cycle() {
    updatePosition();
    draw();
    for (int i = 0; i < myTail.length; i++) {
      myTail[i].updatePosition();
      myTail[i].draw();
    }
  }


  // model
  void updatePosition() {
    if (mousePressed) {
      Vector3f v = new Vector3f(position);
      position.set(position.x + (mouseX - position.x) / 10f, 0.0f, position.z + (mouseY - position.z) / 10f);
      v.sub(position);
      rotation = atan2(v.z, v.x);
    }
  }
}
