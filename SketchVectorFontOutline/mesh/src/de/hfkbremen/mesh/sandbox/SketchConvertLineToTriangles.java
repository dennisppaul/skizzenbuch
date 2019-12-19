package de.hfkbremen.mesh.sandbox;

import de.hfkbremen.mesh.ArcBall;
import de.hfkbremen.mesh.Line3;
import processing.core.PApplet;
import processing.core.PVector;

import java.util.ArrayList;

public class SketchConvertLineToTriangles extends PApplet {

    private ArrayList<PVector> mVerticeCloud = new ArrayList<>();

    public void settings() {
        size(1024, 768, P3D);
    }

    public void setup() {
        ArcBall.setupRotateAroundCenter(this, false);

        for (int i = 0; i < 100; i++) {
            PVector p = new PVector(random(-width / 2, width / 2), random(-height / 2, height / 2), random(-250, 250));
            mVerticeCloud.add(p);
        }
    }

    public void draw() {
        background(0, 127, 255);
        lights();
        translate(width / 2, height / 2);

        //        drawRandomLines();
        drawSpiralContinuous();
        //        drawSpiral();
        //        drawRing();
        //        drawBasket();
    }

    private float dot(PVector p0, PVector p1) {
        return abs(PVector.dot(p0, p1));
    }

    private void drawRandomLines() {
        noStroke();
        fill(255);
        drawTriangles(Line3.triangles(mVerticeCloud, 1, true, null));
    }

    private void drawRing() {
        noStroke();
        fill(255);
        float mRadius = 200;
        PVector mPPrev = null;
        final float mLineWidth = 30;
        final int mStep = 36;
        for (int i = -mStep; i < 360; i += mStep) {
            float r = radians(i);
            PVector mP = new PVector(sin(r) * mRadius, cos(r) * mRadius);
            if (mPPrev != null) {
                drawLineSegment(mPPrev, mP, mLineWidth);
            }
            mPPrev = new PVector(mP.x, mP.y);
        }
    }

    private void drawSpiralContinuous() {
        noFill();
        stroke(255);

        float mRadius = 200;
        final float mLineWidth = 50;
        final int mStep = 36;
        final int mHeightInc = 10;
        int mHeight = 0;

        ArrayList<PVector> mVertices = new ArrayList<>();
        for (int i = 0; i < 360 * 3; i += mStep) {
            float r = radians(i);
            PVector p = new PVector(sin(r) * mRadius, cos(r) * mRadius, mHeight);
            mHeight += mHeightInc;
            mVertices.add(p);
        }

        ArrayList<PVector> mTriangles = Line3.triangles_continuous(mVertices, 20, true, null);
        drawTriangles(mTriangles);
    }

    private void drawSpiral() {
        noFill();
        stroke(255);
        float mRadius = 200;
        PVector mPPrev = null;
        final float mLineWidth = 30;
        final int mStep = 36;
        final int mHeightInc = 10;
        int mHeight = 0;
        for (int i = 0; i < 360 * 3; i += mStep) {
            float r = radians(i);
            PVector mP = new PVector(sin(r) * mRadius, cos(r) * mRadius);
            if (mPPrev != null) {
                mHeight += mHeightInc;
                drawLineSegment(mPPrev, new PVector(mP.x, mP.y, mHeight), mLineWidth);
            }
            mPPrev = new PVector(mP.x, mP.y, mHeight);
        }
    }

    private void drawBasket() {
        noStroke();
        fill(255);
        float v = 200;
        PVector p = null;
        for (int i = -10; i < 360; i += 10) {
            float r = radians(i);
            float x = sin(r) * v;
            float y = cos(r) * v;
            drawLineSegment(new PVector(-y, x, v), new PVector(x, y, -v), 1);
            drawLineSegment(new PVector(x, y, v), new PVector(x, y, v * 1.1f), 0.5f);
            drawLineSegment(new PVector(x, y, -v), new PVector(x, y, -v * 1.1f), 0.5f);
            if (p != null) {
                drawLineSegment(new PVector(p.x, p.y, v), new PVector(x, y, v), 2);
                drawLineSegment(new PVector(-p.y, p.x, -v), new PVector(-y, x, -v), 4);
            }
            p = new PVector(x, y, v);
        }
    }

    private void drawLineSegment(PVector p0, PVector p1, float mSize) {
        drawTriangles(Line3.triangles(p0, p1, mSize, false, null));
    }

    private void drawTriangles(ArrayList<PVector> pTriangles) {
        beginShape(TRIANGLES);
        for (PVector p : pTriangles) {
            vertex(p);
        }
        endShape();
    }

    private void vertex(PVector p) {
        vertex(p.x, p.y, p.z);
    }

    public static void main(String[] args) {
        PApplet.main(SketchConvertLineToTriangles.class.getName());
    }
}
