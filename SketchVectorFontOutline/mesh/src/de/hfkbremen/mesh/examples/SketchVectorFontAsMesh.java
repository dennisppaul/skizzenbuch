package de.hfkbremen.mesh.examples;

import de.hfkbremen.mesh.Mesh;
import de.hfkbremen.mesh.MeshUtil;
import de.hfkbremen.mesh.VectorFont;
import processing.core.PApplet;
import processing.core.PVector;

import java.util.ArrayList;

public class SketchVectorFontAsMesh extends PApplet {

    private VectorFont mPathCreator;

    public void settings() {
        size(640, 480, P3D);
    }

    public void setup() {
        mPathCreator = new VectorFont("Helvetica", 128);
    }

    public void draw() {
        mPathCreator.outline_flatness((float) mouseX / (float) width * 5);
        ArrayList<PVector> mVertices = mPathCreator.vertices("01.01.1970");
        Mesh mMesh = MeshUtil.mesh(mVertices);

        background(255);
        noFill();
        stroke(0);
        translate(0, mouseY);
        mMesh.draw(g);
    }

    public static void main(String[] args) {
        PApplet.main(SketchVectorFontAsMesh.class.getName());
    }
}
