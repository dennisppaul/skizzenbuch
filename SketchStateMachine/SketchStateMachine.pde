State mState = new StateSquare();

void settings() {
    size(640, 480);
}

void setup() {
    rectMode(CENTER);
}

void draw() {
    background(255);
    fill(0);
    noStroke();

    mState.loop();
}

void keyPressed() {
    if (key=='1') {
        mState = new StateSquare();
    }
    if (key=='2') {
        mState = new StateCircleSmall();
    }
    if (key=='3') {
        mState = new StateCircleLarge();
    }
}


interface State {
    void loop();
}

class StateSquare implements State {
    void loop() {
        square(width/2, height/2, 50);
    }
}

class StateCircleSmall implements State {

    int mCounter = 0;

    void loop() {
        circle(width/2, height/2, 50);
        
        mCounter++;
        if ( mCounter > 30 ) {
            mState = new StateCircleLarge();
        }
    }
}

class StateCircleLarge implements State {

    int mCounter = 0;

    void loop() {
        circle(width/2, height/2, 60);

        mCounter++;
        if ( mCounter > 30 ) {
            mState = new StateCircleSmall();
        }
    }
}
