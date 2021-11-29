PMatrix3D mMatrix;
ArrayList<PVector> mPoints = new ArrayList<>();
ArrayList<PVector> mWorldPoints = new ArrayList<>();

void settings() {
    size(1024, 768);
}

void setup() {
    mMatrix = new PMatrix3D();
    mMatrix.reset();
    mMatrix.translate(width / 2, 50);
    mMatrix.scale(2, 2);
    mMatrix.rotate(PI / 4);

    mPoints.add(new PVector(100, 100));
    mPoints.add(new PVector(200, 100));
    mPoints.add(new PVector(200, 200));
    mPoints.add(new PVector(100, 200));

    /* transform points from local space to world space */
    for (PVector mPoint : mPoints) {
        mWorldPoints.add(mMatrix.mult(mPoint, null));
    }
}

void draw() {
    background(255);
    noFill();

    /* draw shape in local coordinates */
    stroke(0);
    beginShape();
    for (PVector p : mPoints) {
        vertex(p.x, p.y);
    }
    endShape(CLOSE);

    /* draw shape in world coordinates */
    stroke(255, 0, 0);
    beginShape();
    for (PVector p : mWorldPoints) {
        vertex(p.x, p.y);
    }
    endShape(CLOSE);

    /* draw connection between two arbitrary points */
    stroke(0, 255, 0);
    line(mPoints.get(3).x, mPoints.get(3).y, mWorldPoints.get(0).x, mWorldPoints.get(0).y);
}
