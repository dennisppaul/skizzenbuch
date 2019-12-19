package de.hfkbremen.mesh.examples;

import de.hfkbremen.mesh.VectorFont;
import processing.core.PApplet;

import java.awt.*;
import java.awt.geom.Ellipse2D;
import java.awt.geom.PathIterator;

public class SketchVectorFontOnPathJAVA2D extends PApplet {

    private Shape mCharacters;

    public void settings() {
        size(640, 480, P3D);
    }

    public void setup() {
        VectorFont mPathCreator = new VectorFont("Helvetica", 32);
        mPathCreator.insideFlag(VectorFont.CLOCKWISE);
        mPathCreator.outline_flatness(0.25f);
        mPathCreator.stretch_to_fit(true);
        mPathCreator.repeat(false);

        final Ellipse2D.Float mPath = new Ellipse2D.Float();
        mPath.x = width / 2 - 150;
        mPath.y = height / 2 - 150;
        mPath.width = 300;
        mPath.height = 300;
        mCharacters = mPathCreator.charactersJAVA2D("Since I was very young I realized ...", mPath);
    }

    public void draw() {
        background(255);
        drawOutline(mCharacters);
    }

    private void drawOutline(Shape pShape) {
        stroke(0, 64);
        noFill();

        if (pShape != null) {
            final PathIterator it = pShape.getPathIterator(null, 1.0f);
            int type;
            float[] points = new float[6];
            beginShape(POLYGON);
            while (!it.isDone()) {
                type = it.currentSegment(points);
                vertex(points[0], points[1]);
                if (type == PathIterator.SEG_CLOSE) {
                    endShape(CLOSE);
                    beginShape();
                }
                it.next();
            }
            endShape();
        }
    }

    public static void main(String[] args) {
        PApplet.main(SketchVectorFontOnPathJAVA2D.class.getName());
    }
}
