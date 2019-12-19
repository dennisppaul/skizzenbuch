package de.hfkbremen.mesh.examples;

import de.hfkbremen.mesh.ModelData;
import de.hfkbremen.mesh.ModelLoaderOBJ;
import de.hfkbremen.mesh.OBJWeirdObject;
import processing.core.PApplet;

public class SketchOBJModelDrawingManually extends PApplet {

    private ModelData mModelData;

    public void settings() {
        size(640, 480, P3D);
    }

    public void setup() {
        mModelData = ModelLoaderOBJ.parseModelData(OBJWeirdObject.DATA);
        println(mModelData);
    }

    public void draw() {
        background(255);

        translate(width / 2, height / 2, -200);
        rotateX(sin(frameCount * 0.01f) * TWO_PI);
        rotateY(cos(frameCount * 0.0037f) * TWO_PI);

        stroke(0);
        noFill();
        for (int i = 0; i < mModelData.vertices().length; i += 3) {
            float x = mModelData.vertices()[i + 0];
            float y = mModelData.vertices()[i + 1];
            float z = mModelData.vertices()[i + 2];
            line(0, 0, 0, x, y, z);
        }
    }

    public static void main(String[] args) {
        PApplet.main(SketchOBJModelDrawingManually.class.getName());
    }
}
