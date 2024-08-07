import de.hfkbremen.mesh.*; 
import java.awt.*; 
import java.awt.geom.*; 


IndexedTriangleList mIndexedTriangleList;
void settings() {
    size(640, 480, P3D);
}
void setup() {
    mIndexedTriangleList = IcoSphere.indexed_triangle_list(2);
}
void draw() {
    background(255);
    strokeWeight(1.0f / 100.0f);
    translate(width / 2, height / 2);
    rotateX(frameCount / 180.0f);
    rotateY(0.33f * frameCount / 180.0f);
    scale(100);
    beginShape(TRIANGLES);
    for (int i = 0; i < mIndexedTriangleList.indices.size(); i++) {
        int mIndex = mIndexedTriangleList.indices.get(i);
        int mHighlight = ((frameCount / 3) % mIndexedTriangleList.indices.size()) / 3;
        if (i / 3 == mHighlight) {
            stroke(0, 0, 255, 127);
            fill(0, 127, 255, 127);
        } else {
            stroke(0, 127);
            fill(255, 32);
        }
        PVector p = mIndexedTriangleList.vertices.get(mIndex);
        vertex(p.x, p.y, p.z);
    }
    endShape();
    // or for short `mIndexedTriangleList.draw(g);`
}
