import wellen.*;
import teilchen.*;
import teilchen.behavior.*;
import teilchen.constraint.*;
import teilchen.cubicle.*;
import teilchen.force.*;
import teilchen.integration.*;
import teilchen.util.*;

Physics mPhysics;
Particle mPendulumRoot;
Particle mPendulumTip;
Pulse mPulse;

MDetector mDetector;

void settings() {
    size(640, 480, P3D);
}

void setup() {
    mPhysics = new Physics();
    mPhysics.add(new Gravity());

    mPendulumRoot = mPhysics.makeParticle(0, 0, 0, 0.05f);
    mPendulumRoot.position().set(width / 2.0f, 15);
    mPendulumRoot.fixed(true);

    mPendulumTip = mPhysics.makeParticle(0, 0, 0, 0.05f);

    float mSegmentLength = height / 2.0f;
    Spring mConnection = new Spring(mPendulumRoot, mPendulumTip, mSegmentLength);
    mConnection.damping(0.0f);
    mConnection.strength(10);
    mPhysics.add(mConnection);

    mPulse = new Pulse(mPendulumTip);
    mPulse.damping(0.99f);
    mPhysics.add(mPulse);

    mDetector = new MDetector();
    mDetector.position().set(width / 2, height / 2 + 20);
}

void draw() {
    mPhysics.step(1.0f / frameRate, 5);
    mDetector.loop();

    background(255);
    Particle p1 = mPendulumRoot;
    Particle p2 = mPendulumTip;

    stroke(0, 191);
    noFill();
    line(p1.position().x, p1.position().y, p2.position().x, p2.position().y);

    fill(0);
    noStroke();
    circle(p1.position().x, p1.position().y, 10);
    circle(p2.position().x, p2.position().y, 20);

    mDetector.draw(g);
}

void mousePressed() {
    mPulse.force().set(mPendulumTip.velocity().normalize().mult(100));
}

class MDetector {

    PVector mPosition;
    float mThresholdDistance;
    int mNote;
    boolean mSensorTriggered;

    MDetector() {
        Tone.instrument().set_oscillator_type(Wellen.WAVESHAPE_TRIANGLE);
        mPosition = new PVector();
        mThresholdDistance = 20;
    }

    PVector position() {
        return mPosition;
    }

    void loop() {
        final float mDistance = mPosition.dist(mPendulumTip.position());
        boolean mNewSensorTriggered = mDistance < mThresholdDistance;

        if (mSensorTriggered != mNewSensorTriggered) {
            if (mNewSensorTriggered) {
                Tone.note_on(49, 127);
            } else {
                Tone.note_off();
            }
        }
        mSensorTriggered = mNewSensorTriggered;
    }

    void draw(PGraphics g) {
        if (mSensorTriggered) {
            g.noFill();
            g.stroke(0, 127, 255);
        } else {
            g.noStroke();
            g.fill(0, 127, 255);
        }
        g.circle(mPosition.x, mPosition.y, mThresholdDistance);
    }
}
