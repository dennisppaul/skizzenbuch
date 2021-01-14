ArrayList<PVector> mPointCloud = new ArrayList<>();
PVector mCenter;

void settings() {
    size(1024, 768, P3D);
}

void setup() {
    mCenter = new PVector(0.0, 0.0, 0.0);
    sphereDetail(8);
    fill(0);
    noStroke();
}

void draw() {
    prepareView();
    /* add multiple points per frame */
    for (int i = 0; i < 50; i++) {
        addPointToCloud();
    }
    drawPointCloud();
}

void prepareView() {
    background(255);
    translate(width * 0.5, height * 0.5);
    rotateX(map(mouseY, 0, height, -PI, PI));
    rotateY(map(mouseX, 0, width, -PI, PI));
}

void addPointToCloud() {
    /* create random point */
    PVector mPoint = new PVector();
    mPoint.x = random(-width * 0.5, width * 0.5);
    mPoint.y = random(-height * 0.5, height * 0.5);
    mPoint.z = random(-height * 0.5, height * 0.5);

    /* add point to point cloud ... if within radius */
    final float mRadius = width * 0.25;
    if (mPoint.dist(mCenter) < mRadius) {
        mPointCloud.add(mPoint);
    }
}

void drawPointCloud() {
    /* draw point cloud */
    for (PVector p : mPointCloud) {
        pushMatrix();
        translate(p.x, p.y, p.z);
        sphere(5);
        popMatrix();
    }
}
