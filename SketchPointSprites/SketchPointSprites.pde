PointSprites fPointSprites;
PVector[] fPoints;

public void setup() {
    size(1024, 768, P3D);
    hint(DISABLE_DEPTH_TEST);
    blendMode(ADD);

    /* create array of points */
    fPoints = new PVector[100000];
    for (int i=0; i < fPoints.length; i++) {
        fPoints[i] = new PVector(random(-200, 200), random(-200, 200), random(-200, 200));
    }

    /* create point sprites */
    PGL pgl = beginPGL();
    fPointSprites = new PointSprites(this, pgl, fPoints, dataPath("sprite.png"));
    endPGL();
}

public void draw() {
    background(0);

    /* rotate view */
    translate(width/2, height/2);
    rotateX(frameCount*0.003);
    rotateY(frameCount*0.02);

    /* draw a *normal* shape */
    fill(255);
    noStroke();
    sphere(100);

    /* move point sprites */
    if (mousePressed) {
        for (int i=0; i < fPoints.length; i++) {
            final float mOffset = 10;
            fPoints[i].x += random(-mOffset, mOffset);
            fPoints[i].y += random(-mOffset, mOffset);
            fPoints[i].z += random(-mOffset, mOffset);
        }
        fPointSprites.update(); // call this when point locations have changed
    }

    /* set point sprite size */
    fPointSprites.set_point_size(map(mouseX, 0, width, 0.1, 64));

    /* draw point sprite */
    PGL pgl = beginPGL();
    fPointSprites.draw(pgl);
    endPGL();
}
