import de.hfkbremen.mesh.*; 
import java.awt.*; 
import java.awt.geom.*; 


ArrayList<PVector> mPoints = new ArrayList();
void settings() {
    size(640, 480, P3D);
}
void setup() {
    noFill();
}
void draw() {
    if (mousePressed) {
        mPoints.add(new PVector(mouseX, mouseY));
    }
    background(50);
    stroke(255);
    for (PVector p : mPoints) {
        point(p.x, p.y, p.z);
    }
    stroke(255, 127, 0);
    ArrayList<PVector> mHull = MeshUtil.giftWrap(mPoints);
    beginShape();
    for (PVector p : mHull) {
        vertex(p.x, p.y, p.z);
    }
    endShape(CLOSE);
}
