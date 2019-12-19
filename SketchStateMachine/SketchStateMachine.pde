final int MODE_EDIT = 0;
final int MODE_SIMULATE = 1;
final int MODE_IDLE = 2;

State mState = new StateEdit();

void settings() {
  size(640, 480);
}

void setup() {
}

void draw() {
  background(50);
  fill(255, 0, 0);
  stroke(255, 0, 0);

  mState.loop();
}

void keyPressed() {
  if (key=='1') {
    mState = new StateEdit();
  }
  if (key=='2') {
    mState = new StateSimulate();
  }
  if (key=='3') {
    mState = new StateIdle();
  }
}


interface State {
  void loop();
}

class StateEdit implements State {
  void loop() {
    ellipse(width/2, height/2, 10, 10);
  }
}

class StateSimulate implements State {
  void loop() {
    line(0, 0, width, height);
    mState = new StateIdle();
  }
}

class StateIdle implements State {
  void loop() {
    line(width, 0, 0, height);
    mState = new StateSimulate();
  }
}