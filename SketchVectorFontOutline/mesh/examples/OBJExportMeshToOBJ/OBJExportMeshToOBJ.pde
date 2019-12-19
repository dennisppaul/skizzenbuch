import de.hfkbremen.mesh.*; 
import java.awt.*; 
import java.awt.geom.*; 


Mesh mMesh;
void settings() {
    size(640, 480, P3D);
}
void setup() {
    mMesh = IcoSphere.mesh(4);
}
void draw() {
    background(255);
    stroke(0);
    noFill();
    strokeWeight(1.0f / 100.0f);
    translate(width / 2, height / 2);
    rotateX(frameCount / 180.0f);
    rotateY(0.33f * frameCount / 180.0f);
    scale(100);
    mMesh.draw(g);
}
void keyPressed() {
    String[] mOBJ = ModelLoaderOBJ.convertMeshToOBJ(mMesh);
    saveStrings("icosphere" + frameCount + ".obj", mOBJ);
}
