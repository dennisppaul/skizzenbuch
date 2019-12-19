package de.hfkbremen.mesh.examples;

import de.hfkbremen.mesh.MeshUtil;
import processing.core.PApplet;
import processing.core.PVector;

import java.util.ArrayList;

public class SketchConvexHull2D extends PApplet {

    private ArrayList<PVector> mPoints = new ArrayList<>();

    public void settings() {
        size(640, 480, P3D);
    }

    public void setup() {
        noFill();
    }

    public void draw() {
        if (mousePressed) {
            mPoints.add(new PVector(mouseX, mouseY));
        }

        background(50);
        stroke(255);
        for (PVector p : mPoints) {
            point(p.x, p.y, p.z);
        }

        stroke(255, 127, 0);
        ArrayList<PVector> mHull = MeshUtil.giftWrap(mPoints);
        beginShape();
        for (PVector p : mHull) {
            vertex(p.x, p.y, p.z);
        }
        endShape(CLOSE);
    }

    public static void main(String[] args) {
        PApplet.main(SketchConvexHull2D.class.getName());
    }
}
