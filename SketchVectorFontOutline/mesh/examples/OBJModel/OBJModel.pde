import de.hfkbremen.mesh.*; 
import java.awt.*; 
import java.awt.geom.*; 


Mesh mModelMesh;
void settings() {
    size(640, 480, P3D);
}
void setup() {
    ModelData mModelData = ModelLoaderOBJ.parseModelData(OBJMan.DATA);
    mModelMesh = mModelData.mesh();
    println(mModelData);
}
void draw() {
    background(255);
    if (mousePressed) {
        noFill();
        stroke(0);
        mModelMesh.primitive(POINTS);
    } else {
        fill(0, 127, 255);
        stroke(255);
        mModelMesh.primitive(TRIANGLES);
    }
    translate(width / 2, height, -200);
    rotateX(PI);
    rotateY(cos(frameCount * 0.0037f) * TWO_PI);
    mModelMesh.draw(g);
}
