package de.hfkbremen.mesh.examples;

import de.hfkbremen.mesh.Mesh;
import de.hfkbremen.mesh.ModelData;
import de.hfkbremen.mesh.ModelLoaderOBJ;
import de.hfkbremen.mesh.OBJWeirdObject;
import de.hfkbremen.mesh.Triangle;
import processing.core.PApplet;

import java.util.ArrayList;

public class SketchOBJModelToTriangles extends PApplet {

    private ArrayList<Triangle> mTriangles;

    public void settings() {
        size(640, 480, P3D);
    }

    public void setup() {
        ModelData mModelData = ModelLoaderOBJ.parseModelData(OBJWeirdObject.DATA);
        Mesh mModelMesh = mModelData.mesh();
        mTriangles = mModelMesh.triangles();
    }

    public void draw() {
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

    public static void main(String[] args) {
        PApplet.main(SketchOBJModelToTriangles.class.getName());
    }
}
