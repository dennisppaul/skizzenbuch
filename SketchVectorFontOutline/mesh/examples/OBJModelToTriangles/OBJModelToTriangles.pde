import de.hfkbremen.mesh.*; 
import java.awt.*; 
import java.awt.geom.*; 


ArrayList<Triangle> mTriangles;
void settings() {
    size(640, 480, P3D);
}
void setup() {
    ModelData mModelData = ModelLoaderOBJ.parseModelData(OBJWeirdObject.DATA);
    Mesh mModelMesh = mModelData.mesh();
    mTriangles = mModelMesh.triangles();
}
void draw() {
    background(255);
    translate(width / 2, height / 2, -200);
    rotateX(sin(frameCount * 0.01f) * TWO_PI);
    rotateY(cos(frameCount * 0.0037f) * TWO_PI);
    stroke(255);
    beginShape(TRIANGLES);
    for (Triangle t : mTriangles) {
        fill(0, random(127, 255), random(127, 255));
        vertex(t.a.x, t.a.y, t.a.z);
        vertex(t.b.x, t.b.y, t.b.z);
        vertex(t.c.x, t.c.y, t.c.z);
    }
    endShape();
}
