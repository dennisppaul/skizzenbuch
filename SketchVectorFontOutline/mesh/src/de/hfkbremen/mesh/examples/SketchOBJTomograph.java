package de.hfkbremen.mesh.examples;

import de.hfkbremen.mesh.ArcBall;
import de.hfkbremen.mesh.Mesh;
import de.hfkbremen.mesh.MeshUtil;
import de.hfkbremen.mesh.ModelData;
import de.hfkbremen.mesh.ModelLoaderOBJ;
import de.hfkbremen.mesh.OBJMan;
import de.hfkbremen.mesh.Triangle;
import processing.core.PApplet;
import processing.core.PVector;

import java.util.ArrayList;

public class SketchOBJTomograph extends PApplet {

    private ArrayList<Triangle> mTriangles;
    private ArcBall mArcBall;

    public void settings() {
        size(640, 480, P3D);
    }

    public void setup() {
        ModelData mModelData = ModelLoaderOBJ.parseModelData(OBJMan.DATA);
        Mesh mModelMesh = mModelData.mesh();
        mTriangles = mModelMesh.triangles();
        mArcBall = new ArcBall(this, true);
    }

    public void draw() {
        background(50);

        pushMatrix();
        translate(width * 0.33f, 0, 0);
        mArcBall.update();
        translate(width * 0.5f, height, -200);
        scale(1, -1, 1);

        stroke(255, 16);
        noFill();
        beginShape(TRIANGLES);
        for (Triangle t : mTriangles) {
            vertex(t.a.x, t.a.y, t.a.z);
            vertex(t.b.x, t.b.y, t.b.z);
            vertex(t.c.x, t.c.y, t.c.z);
        }
        endShape();

        stroke(255, 127, 0);
        noFill();
        final float mTomographRadius = 250;
        final float mHeight = mouseY * 2;
        final float mTomographScanPoints = 72;
        ArrayList<PVector> mOutline = scanSlice(mTriangles, mHeight, mTomographScanPoints, mTomographRadius);
        beginShape();
        for (PVector p : mOutline) {
            vertex(p.x, mHeight, p.y);
        }
        endShape(CLOSE);
        popMatrix();

        stroke(255, 192, 0);
        fill(255, 127, 0);
        translate(width * 0.33f, height / 2);
        beginShape();
        for (PVector p : mOutline) {
            vertex(p.x, p.y);
        }
        endShape(CLOSE);
    }

    private ArrayList<PVector> scanSlice(ArrayList<Triangle> pTriangles, float pHeight, float pScanPoints, float pRadius) {
        final ArrayList<PVector> mOutline = new ArrayList<>();
        for (float r = 0; r < TWO_PI; r += TWO_PI / pScanPoints) {
            PVector p0 = new PVector(sin(r) * pRadius, pHeight, cos(r) * pRadius);
            PVector p1 = new PVector(sin(r + PI) * pRadius, pHeight, cos(r + PI) * pRadius);
            PVector mResult = new PVector();
            boolean mSucess = findIntersection(pTriangles, p0, p1, mResult);
            if (mSucess) {
                mOutline.add(mResult);
            }
        }
        /* convert to 2D */
        final ArrayList<PVector> mOutline2D = new ArrayList<>();
        for (PVector p : mOutline) {
            mOutline2D.add(new PVector(p.x, p.z));
        }
        return MeshUtil.giftWrap(mOutline2D);
    }

    private boolean findIntersection(ArrayList<Triangle> pTriangles, PVector p0, PVector p1, PVector pResult) {
        final PVector pRayOrigin = p1;
        final PVector pRayDirection = PVector.sub(p1, p0);
        for (Triangle t : mTriangles) {
            final PVector mResult = new PVector();
            boolean mSuccess = MeshUtil.findRayTriangleIntersectionPoint(pRayOrigin, pRayDirection, t.a, t.b, t.c, mResult, true);
            if (mSuccess) {
                pResult.set(mResult);
                return true;
            }
        }
        return false;
    }

    public static void main(String[] args) {
        PApplet.main(SketchOBJTomograph.class.getName());
    }
}
