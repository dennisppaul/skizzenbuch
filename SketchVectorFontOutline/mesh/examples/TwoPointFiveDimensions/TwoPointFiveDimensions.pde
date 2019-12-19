import de.hfkbremen.mesh.*; 
import java.awt.*; 
import java.awt.geom.*; 


void settings() {
    size(1024, 768, P3D);
}
void setup() {
    rectMode(CORNERS);
    //        new ArcBall(this);
}
void draw() {
    background(255);
    // camera
    translate(width / 2, height / 2);
    rotateX(radians(mouseY * 0.25f));
    rotateZ(radians(mouseX * 0.25f));
    stroke(0);
    noFill();
    drawMirror(0, 0, radians(frameCount));
    rect(-width / 2, -height / 2, width / 2, height / 2);
    stroke(255, 0, 0);
    pushMatrix();
    translate(0, 0, 50);
    line(300, 100, 0, 0);
    popMatrix();
}
void drawMirror(float x, float y, float r) {
    final float mMirrorWidth = 50;
    final float mMirrorHeight = 100;
    float x1 = sin(r) * mMirrorWidth + x;
    float y1 = cos(r) * mMirrorWidth + y;
    float x2 = sin(r - PI) * mMirrorWidth + x;
    float y2 = cos(r - PI) * mMirrorWidth + y;
    line(x1, y1, x2, y2);
    pushMatrix();
    translate(x, y);
    rotateX(PI / 2);
    rotateY(-r);
    rect(-mMirrorWidth / 2, 0, mMirrorWidth / 2, mMirrorHeight);
    popMatrix();
}
