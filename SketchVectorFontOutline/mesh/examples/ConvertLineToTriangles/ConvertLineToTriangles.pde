import de.hfkbremen.mesh.*; 
import java.awt.*; 
import java.awt.geom.*; 


void settings() {
    size(1024, 768, P3D);
}
void setup() {
    ArcBall.setupRotateAroundCenter(this, false);
}
void draw() {
    background(0, 127, 255);
    lights();
    lightFalloff(1.0f, 0.001f, 0.0f);
    pointLight(0, 127, 255, 50, 50, 50);
    translate(width / 2, height / 2);
    noStroke();
    fill(200);
    drawSpiral();
}
void drawSpiral() {
    float mRadius = 200;
    final float mLineWidth = 8;
    final int mStep = 12;
    final int mHeightInc = 9;
    ArrayList<PVector> mVertices = new ArrayList();
    for (int i = -360 * 3; i < 360 * 3; i += mStep) {
        float r = radians(i);
        PVector p = new PVector(sin(r) * mRadius, cos(r) * mRadius, mHeightInc * i / mStep);
        mVertices.add(p);
    }
    ArrayList<PVector> mTriangles = Line3.triangles(mVertices, mLineWidth, true, null);
    drawTriangles(mTriangles);
}
void drawTriangles(ArrayList<PVector> pTriangles) {
    beginShape(TRIANGLES);
    for (PVector p : pTriangles) {
        vertex(p.x, p.y, p.z);
    }
    endShape();
}
