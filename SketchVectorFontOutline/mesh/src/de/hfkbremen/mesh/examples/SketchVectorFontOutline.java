package de.hfkbremen.mesh.examples;

import de.hfkbremen.mesh.VectorFont;
import processing.core.PApplet;
import processing.core.PVector;

import java.util.ArrayList;

public class SketchVectorFontOutline extends PApplet {

    private VectorFont mPathCreator;

    public void settings() {
        size(640, 480, P3D);
    }

    public void setup() {
        mPathCreator = new VectorFont("Helvetica", 500);
    }

    public void draw() {
        mPathCreator.outline_flatness((float) mouseX / (float) width * 5);
        ArrayList<PVector> mVertices = mPathCreator.outline("23");

        background(255);
        noStroke();
        fill(0);
        translate(50, height - 75);
        for (int i = 0; i < mVertices.size(); i++) {
            PVector p = mVertices.get(i);
            final float mRadius = sin(radians(i * 10 + frameCount * 3)) * 2 + 4;
            ellipse(p.x, p.y, mRadius * 2, mRadius * 2);
        }
    }

    public static void main(String[] args) {
        PApplet.main(SketchVectorFontOutline.class.getName());
    }
}
