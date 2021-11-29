/**
 *
 * converting spherical coordinate system to 3D euclidean space
 *
 * x = r × sin(theta) × cos(phi)
 * y = r × sin(theta) × sin(phi)
 * z = r × cos(theta)
 *
 */

ArrayList<PVector> mLines = new ArrayList();
private float mRadius = 150;
private float mTheta = 0;
private float mPhi = 0;

void settings() {
    size(640, 480, P3D);
}

void setup() {
}

void draw() {
    final float mOffset = 0.1f;
    mTheta += random(-mOffset, mOffset);
    mPhi += random(-mOffset, mOffset);
    PVector p = convertSphericalTo3D(mRadius, mTheta, mPhi);
    mLines.add(p);

    background(255);
    translate(width / 2, height / 2);
    rotateX(frameCount * 0.001f);
    rotateY(frameCount * 0.0003f);
    stroke(0, 127);
    beginShape(LINE_STRIP);
    for (PVector v : mLines) {
        vertex(v.x, v.y, v.z);
    }
    endShape();
}

PVector convertSphericalTo3D(float pRadius, float pTheta, float pPhi) {
    PVector p = new PVector();
    p.x = pRadius * sin(pTheta) * cos(pPhi);
    p.y = pRadius * sin(pTheta) * sin(pPhi);
    p.z = pRadius * cos(pTheta);
    return p;
}
