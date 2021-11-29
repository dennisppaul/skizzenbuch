ArrayList<Thing> mThings = new ArrayList<>();
Picker mPicker = new PickerRect();

void settings() {
    size(1024, 768, P3D);
}

void setup() {
    for (int i = 0; i < 2500; i++) {
        Thing t = new Thing();
        t.position.x = random(width);
        t.position.y = random(height);
        mThings.add(t);
    }
}

void draw() {
    mPicker.position.set(mouseX, mouseY);
    ArrayList<Thing> mPickedThings = mPicker.pick(mThings);

    background(20);

    /* draw picker */
    noFill();
    stroke(255, 127);
    mPicker.draw();

    /* draw picked things */
    noStroke();
    fill(255, 0, 0);
    for (Thing t : mPickedThings) {
        t.draw();
    }

    /* draw all things */
    noStroke();
    fill(255, 63);
    for (Thing t : mThings) {
        t.draw();
    }
}

void mousePressed() {
    mPicker = new PickerCircle();
}

void mouseReleased() {
    mPicker = new PickerRect();
}

abstract class Picker {

    PVector position = new PVector();

    abstract void draw();

    protected abstract boolean isPicked(Thing t);

    ArrayList<Thing> pick(ArrayList<Thing> pThings) {
        ArrayList<Thing> mPickedThings = new ArrayList<>();
        for (Thing t : pThings) {
            if (isPicked(t)) {
                mPickedThings.add(t);
            }
        }
        return mPickedThings;
    }
}

class PickerCircle extends Picker {

    float radius = 100;

    void draw() {
        ellipse(position.x, position.y, radius * 2, radius * 2);
    }

    protected boolean isPicked(Thing t) {
        float mDist = t.position.dist(position);
        return mDist < radius;
    }
}

class PickerRect extends Picker {

    PVector scale = new PVector(100, 100);

    void draw() {
        rect(position.x, position.y, scale.x, scale.y);
    }

    protected boolean isPicked(Thing t) {
        return t.position.x > position.x && t.position.y > position.y && t.position.x < position.x + scale.x && t.position.y <
            position.y + scale.y;
    }
}

class Thing {

    PVector position = new PVector();

    void draw() {
        final float mDiameter = 7;
        ellipse(position.x, position.y, mDiameter, mDiameter);
    }
}
