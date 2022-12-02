static final int MIRROR_GRID_WIDTH = 16;
static final int NUM_MIRRORS = MIRROR_GRID_WIDTH * MIRROR_GRID_WIDTH;

ArrayList<Mirror> fMirrors;
Ray fRay;

void settings() {
    size(1024, 768);
}

void setup() {
    fRay = new Ray();
    fMirrors = new ArrayList<Mirror>();
    for (int i=0; i < NUM_MIRRORS; i++) {
        Mirror m = new Mirror();
        m.position.set(i % MIRROR_GRID_WIDTH, i / MIRROR_GRID_WIDTH);
        m.position.mult(1.0 / MIRROR_GRID_WIDTH);
        m.position.x *= width;
        m.position.y *= height;
        m.position.x += 0.5 * width / MIRROR_GRID_WIDTH;
        m.position.y += 0.5 * width / MIRROR_GRID_WIDTH;
        final float mNoiseScale = 0.003;
        m.rotation = noise(m.position.x * mNoiseScale, m.position.y * mNoiseScale) * TWO_PI;
        //m.rotation = TWO_PI * i / NUM_MIRRORS;
        m.update();
        fMirrors.add(m);
    }
}

void draw() {
    if (!keyPressed) {
        for (Mirror m : fMirrors) {
            m.rotation = m.rotation + 0.1 / frameRate;
            m.update();
        }
    }

    fRay.position.set(new PVector(mouseX, mouseY));
    if (mousePressed) {
        fRay.direction.set(PVector.sub(new PVector(width / 2, height / 2), fRay.position).normalize());
    }
    fRay.update(fMirrors);

    background(0);
    for (Mirror n : fMirrors) {
        n.draw();
    }
    fRay.draw();
}
