import de.hfkbremen.mesh.*; 
import java.awt.*; 
import java.awt.geom.*; 


CGALAlphaShape3 cgal;
float[] mPoints3;
float[] mOptimalAlphaShape;
int mNumberOfSolidComponents = 1;
void settings() {
    size(640, 480, P3D);
}
void setup() {
    cgal = new CGALAlphaShape3();
    final int NUMBER_OF_POINTS = 1000;
    mPoints3 = new float[NUMBER_OF_POINTS * 3];
    final float mRange = 2;
    for (int i = 0; i < NUMBER_OF_POINTS; i++) {
        PVector p = new PVector().set(random(-1, 1), random(-1, 1), random(-1, 1));
        p.normalize();
        p.mult(random(mRange * 0.75f, mRange));
        mPoints3[i * 3 + 0] = p.x;
        mPoints3[i * 3 + 1] = p.y;
        mPoints3[i * 3 + 2] = p.z;
    }
    cgal.compute_cgal_alpha_shape(mPoints3);
    computeAlphaShape(mNumberOfSolidComponents);
}
void draw() {
    background(255);
    directionalLight(126, 126, 126, 0, 0, -1);
    ambientLight(102, 102, 102);
    translate(width / 2, height / 2);
    scale(100);
    rotateX(frameCount * 0.01f);
    rotateY(frameCount * 0.003f);
    fill(0, 127, 255);
    noStroke();
    if (mOptimalAlphaShape != null) {
        beginShape(TRIANGLES);
        for (int i = 0; i < mOptimalAlphaShape.length; i += 3) {
            vertex(mOptimalAlphaShape[i + 0], mOptimalAlphaShape[i + 1], mOptimalAlphaShape[i + 2]);
        }
        endShape();
    }
    strokeWeight(1f / 25f);
    stroke(255, 127, 0);
    noFill();
    beginShape(POINTS);
    for (int i = 0; i < mPoints3.length; i += 3) {
        vertex(mPoints3[i + 0], mPoints3[i + 1], mPoints3[i + 2]);
    }
    endShape();
}
void keyPressed() {
    if (key == '+') {
        mNumberOfSolidComponents++;
    }
    if (key == '-') {
        mNumberOfSolidComponents--;
    }
    computeAlphaShape(mNumberOfSolidComponents);
}
void computeAlphaShape(int mNumberOfSolidComponents) {
    System.out.println("+++ number of create components: " + mNumberOfSolidComponents);
    System.out.println("+++ optimal alpha             : " + cgal.get_optimal_alpha(mNumberOfSolidComponents));
    mOptimalAlphaShape = cgal.compute_regular_mesh_optimal(mNumberOfSolidComponents);
}
