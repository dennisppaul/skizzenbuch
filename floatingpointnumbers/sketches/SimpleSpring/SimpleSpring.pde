import java.util.Vector;

import processing.core.PApplet;
import processing.core.PFont;

SpringBox springBox;

int counter;

Vector springBoxes = new Vector();

public void setup() {

  size(400, 600, P3D);
  frameRate(60);
  rectMode(CENTER);

  // font
  PFont myFont = loadFont("HelveticaNeue-CondensedBlack-14.vlw");
  textFont(myFont);
}


public void draw() {
  background(255);

  drawOSD(5, 15, 
    "FLOATING.NUMBERS\n\n" +
    "'CLICK' TO GENERATE SPRINGS");

  if (mousePressed) {
    springBoxes.add(new SpringBox(mouseX, 
      mouseY, 
      atan2(mouseY - pmouseY, mouseX - pmouseX), 
      new Spring()));
  }

  for (int i = 0; i < springBoxes.size(); i++) {
    springBox = (SpringBox) springBoxes.get(i);
    if (springBox.spring.active) {
      springBox.spring.cycle();
      if (!springBox.spring.active) {
        springBox.spring.active = true;
        springBox.spring.position = 0.0f;
      }
    }

    springBox.draw(15 - 5 * (1f - springBox.spring.get()));
    springBox.counter++;
  }
}


void drawOSD(int x, int y, String myText) {
  fill(color(0, 0, 0, 150));
  text(myText, x, y);
}


class SpringBox {
  Spring spring;

  int x;

  int y;

  int counter;

  float rotation;

  SpringBox(int x, int y, float rotation, Spring spring) {
    this.x = x;
    this.y = y;
    this.spring = spring;
    this.rotation = rotation;
  }


  void draw(float size) {
    noStroke();
    fill(0);
    pushMatrix();
    translate(x, y);
    rotate(rotation);
    quad( -size, -size, size, -size, size, size, -size, size);
    popMatrix();
  }
}


class Spring {

  boolean active = true;

  float MASS = 2.0f;

  float SPRING_CONSTANT = 0.2f;

  float DAMPING = 0.90f;

  float REST_POSITION = 1.0f;

  float position = 0.0f;

  float velocity = 0.0f;

  float acceleration = 0.0f;

  float force = 0.0f;

  float get() {
    return position;
  }


  void cycle() {
    if (active) {
      force = -SPRING_CONSTANT * (position - REST_POSITION);
      acceleration = force / MASS;
      velocity = DAMPING * (velocity + acceleration);
      position = position + velocity;
      if (abs(position - REST_POSITION) < 0.02f
        && abs(velocity) < 0.04f) {
        position = REST_POSITION;
        active = false;
      }
    }
  }
}
