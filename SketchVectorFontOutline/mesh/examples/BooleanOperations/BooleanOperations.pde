import de.hfkbremen.mesh.*; 
import java.awt.*; 
import java.awt.geom.*; 


Mesh mSolidA;
Mesh mSolidB;
Mesh mIntersection;
CGALBooleanOperations3 mBooleanOperation;
float mRotation;
void settings() {
    size(640, 480, P3D);
}
void setup() {
    mSolidA = ModelLoaderOBJ.parseModelData(OBJWeirdObject.DATA).mesh();
    mSolidA.translate(100, 0, 0);
    mSolidB = ModelLoaderOBJ.parseModelData(OBJWeirdObject.DATA).mesh();
    mBooleanOperation = new CGALBooleanOperations3();
    float SCALER = 1.0f;
    for (int i = 0; i < mSolidB.vertices().length; i++) {
        mSolidB.vertices()[i] *= SCALER;
    }
    for (int i = 0; i < mSolidA.vertices().length; i++) {
        mSolidA.vertices()[i] *= SCALER;
    }
}
void draw() {
    background(255);
    translate(width / 2, height / 2);
    rotateY(mRotation += 1 / 30f * 0.5f);
    if (mIntersection != null) {
        stroke(255);
        fill(0, 127, 255);
        mIntersection.draw(g);
    }
    noFill();
    if (mIntersection == null) {
        stroke(255, 0, 0, 128);
    } else {
        stroke(255, 0, 0, 32);
    }
    mSolidA.draw(g);
    if (mIntersection == null) {
        stroke(0, 255, 0, 128);
    } else {
        stroke(0, 255, 0, 32);
    }
    mSolidB.draw(g);
}
void keyPressed() {
    if (key == '1') {
        mIntersection = mBooleanOperation.boolean_operation_mesh(CGALBooleanOperations3.INTERSECTION,
                                                                 mSolidB.vertices(),
                                                                 mSolidA.vertices());
    } else if (key == '2') {
        mIntersection = mBooleanOperation.boolean_operation_mesh(CGALBooleanOperations3.JOIN, //
                                                                 mSolidB.vertices(), //
                                                                 mSolidA.vertices());
    } else if (key == '3') {
        mIntersection = mBooleanOperation.boolean_operation_mesh(CGALBooleanOperations3.DIFFERENCE,
                                                                 mSolidB.vertices(),
                                                                 mSolidA.vertices());
    } else if (key == '4') {
        mIntersection = mBooleanOperation.boolean_operation_mesh(CGALBooleanOperations3.DIFFERENCE,
                                                                 mSolidA.vertices(),
                                                                 mSolidB.vertices());
    } else if (key == ' ') {
        mIntersection = null;
    }
}
