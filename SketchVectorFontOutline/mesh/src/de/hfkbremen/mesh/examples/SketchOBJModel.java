package de.hfkbremen.mesh.examples;

import de.hfkbremen.mesh.Mesh;
import de.hfkbremen.mesh.ModelData;
import de.hfkbremen.mesh.ModelLoaderOBJ;
import de.hfkbremen.mesh.OBJMan;
import processing.core.PApplet;

public class SketchOBJModel extends PApplet {

    private Mesh mModelMesh;

    public void settings() {
        size(640, 480, P3D);
    }

    public void setup() {
        ModelData mModelData = ModelLoaderOBJ.parseModelData(OBJMan.DATA);
        mModelMesh = mModelData.mesh();
        println(mModelData);
    }

    public void draw() {
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

    public static void main(String[] args) {
        PApplet.main(SketchOBJModel.class.getName());
    }
}
