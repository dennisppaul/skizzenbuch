package de.hfkbremen.mesh.examples;

import de.hfkbremen.mesh.IcoSphere;
import de.hfkbremen.mesh.Mesh;
import processing.core.PApplet;

public class SketchIcoSphereMesh extends PApplet {

    private Mesh mMesh;

    public void settings() {
        size(640, 480, P3D);
    }

    public void setup() {
        mMesh = IcoSphere.mesh(4);
    }

    public void draw() {
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

    public static void main(String[] args) {
        PApplet.main(SketchIcoSphereMesh.class.getName());
    }
}
