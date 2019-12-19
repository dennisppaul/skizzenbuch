package de.hfkbremen.mesh;

import processing.core.PVector;

import java.util.ArrayList;

import static java.lang.Math.abs;

public class Line3 {

    private static final PVector[] mPotentialUpVectors = new PVector[]{new PVector(1, 0, 0),
                                                                       new PVector(0, 1, 0),
                                                                       new PVector(0, 0, 1)};

    private static boolean isParallel(PVector p0, PVector p1) {
        final float mDot = abs(PVector.dot(p0.normalize(null), p1.normalize(null)));
        return mDot == 1.0f;
    }

    private static PVector approximateUpVector(PVector p0, PVector p1) {
        PVector d = PVector.sub(p0, p1).normalize();
        PVector mUpApprox = new PVector();
        float mSmallestAngle = Float.MAX_VALUE;
        for (PVector mPotentialUpVector : mPotentialUpVectors) {
            float mAngle = abs(PVector.dot(d, mPotentialUpVector));
            if (mAngle < mSmallestAngle) {
                mSmallestAngle = mAngle;
                mUpApprox.set(mPotentialUpVector);
            }
        }

        return mUpApprox;
    }

    private static void interpolateCaps(PVector[] a, PVector[] b, PVector[] pResult) {
        for (int i = 0; i < a.length; i++) {
            PVector p = PVector.add(a[i], b[i]);
            p.mult(0.5f);
            pResult[i] = p;
        }
    }

    private static void triangulateSideFromCaps(ArrayList<PVector> pTriangles, PVector[][] pCaps, int pSide) {
        final int A = (0 + pSide) % 4;
        final int B = (1 + pSide) % 4;
        pTriangles.add(pCaps[0][A]);
        pTriangles.add(pCaps[1][A]);
        pTriangles.add(pCaps[1][B]);
        pTriangles.add(pCaps[0][A]);
        pTriangles.add(pCaps[1][B]);
        pTriangles.add(pCaps[0][B]);
    }

    private static void triangulateCap(ArrayList<PVector> pTriangles, PVector[] pCap) {
        pTriangles.add(pCap[0]);
        pTriangles.add(pCap[1]);
        pTriangles.add(pCap[2]);
        pTriangles.add(pCap[0]);
        pTriangles.add(pCap[2]);
        pTriangles.add(pCap[3]);
    }

    private static void calculateCap(PVector p, float pSize, PVector pSide, PVector pUp, PVector[] pCap) {
        pCap[0] = PVector.add(p, PVector.mult(pSide, pSize));
        pCap[1] = PVector.add(p, PVector.mult(pUp, pSize));
        pCap[2] = PVector.add(p, PVector.mult(pSide, -pSize));
        pCap[3] = PVector.add(p, PVector.mult(pUp, -pSize));
    }

    private static ArrayList<PVector> triangles(PVector p0,
                                                PVector p1,
                                                PVector p2,
                                                PVector p3,
                                                float pSize,
                                                boolean pClosedCaps,
                                                ArrayList<PVector> pTriangles) {
        if (pTriangles == null) {
            pTriangles = new ArrayList<>();
        }

        final int PRE = 0;
        final int CENTER = 1;
        final int POST = 2;
        LineSegmentStruct[] mLineSegments = new LineSegmentStruct[3];
        mLineSegments[PRE] = new LineSegmentStruct(p0, p1, approximateUpVector(p0, p1));
        mLineSegments[CENTER] = new LineSegmentStruct(p1, p2, approximateUpVector(p1, p2));
        mLineSegments[POST] = new LineSegmentStruct(p2, p3, approximateUpVector(p2, p3));

        final int PRE_BACK = 0;
        final int CENTER_FRONT = 1;
        final int CENTER_BACK = 2;
        final int POST_FRONT = 3;
        PVector[][] mCapsSegments = new PVector[4][4];
        calculateCap(p1, pSize, mLineSegments[PRE].side, mLineSegments[PRE].up, mCapsSegments[PRE_BACK]);
        calculateCap(p1, pSize, mLineSegments[CENTER].side, mLineSegments[CENTER].up, mCapsSegments[CENTER_FRONT]);
        calculateCap(p2, pSize, mLineSegments[CENTER].side, mLineSegments[CENTER].up, mCapsSegments[CENTER_BACK]);
        calculateCap(p2, pSize, mLineSegments[POST].side, mLineSegments[POST].up, mCapsSegments[POST_FRONT]);

        final int FRONT = 0;
        final int BACK = 1;
        PVector[][] mCapsInterpolated = new PVector[2][4];
        interpolateCaps(mCapsSegments[PRE_BACK], mCapsSegments[CENTER_FRONT], mCapsInterpolated[FRONT]);
        interpolateCaps(mCapsSegments[CENTER_BACK], mCapsSegments[POST_FRONT], mCapsInterpolated[BACK]);
        for (int i = 0; i < 4; i++) {
            triangulateSideFromCaps(pTriangles, mCapsInterpolated, i);
        }

        return pTriangles;
    }

    public static ArrayList<PVector> triangles_continuous(ArrayList<PVector> pVertices,
                                                          float pSize,
                                                          boolean pClosedCaps,
                                                          ArrayList<PVector> pTriangles) {
        if (pTriangles == null) {
            pTriangles = new ArrayList<>();
        }

        final int PRE_BACK = 0;
        final int CENTER_FRONT = 1;
        final int CENTER_BACK = 2;
        final int POST_FRONT = 3;
        for (int i = 0; i < pVertices.size() - 4; i++) {
            triangles(pVertices.get(i + PRE_BACK),
                      pVertices.get(i + CENTER_FRONT),
                      pVertices.get(i + CENTER_BACK),
                      pVertices.get(i + POST_FRONT),
                      pSize,
                      pClosedCaps,
                      pTriangles);
        }
        return pTriangles;
    }

    public static ArrayList<PVector> triangles(ArrayList<PVector> pVertices,
                                               float pSize,
                                               boolean mClosedCaps,
                                               ArrayList<PVector> pTriangles) {
        if (pTriangles == null) {
            pTriangles = new ArrayList<>();
        }

        final int P0 = 0;
        final int P1 = 1;
        for (int i = 0; i < pVertices.size() - 1; i++) {
            triangles(pVertices.get(i + P0), pVertices.get(i + P1), pSize, mClosedCaps, pTriangles);
        }
        return pTriangles;
    }

    public static ArrayList<PVector> triangles(PVector p0,
                                               PVector p1,
                                               float pSize,
                                               boolean pClosedCaps,
                                               ArrayList<PVector> pTriangles) {
        if (pTriangles == null) {
            pTriangles = new ArrayList<>();
        }

        LineSegmentStruct mLineSegment = new LineSegmentStruct(p0, p1, approximateUpVector(p0, p1));

        final int FRONT = 0;
        final int BACK = 1;

        PVector[][] mCaps = new PVector[2][4];
        calculateCap(p0, pSize, mLineSegment.side, mLineSegment.up, mCaps[FRONT]);
        calculateCap(p1, pSize, mLineSegment.side, mLineSegment.up, mCaps[BACK]);
        if (pClosedCaps) {
            triangulateCap(pTriangles, mCaps[FRONT]);
            triangulateCap(pTriangles, mCaps[BACK]);
        }
        triangulateSideFromCaps(pTriangles, mCaps, 0);
        triangulateSideFromCaps(pTriangles, mCaps, 1);
        triangulateSideFromCaps(pTriangles, mCaps, 2);
        triangulateSideFromCaps(pTriangles, mCaps, 3);

        return pTriangles;
    }

    private static class LineSegmentStruct {

        static final int FRONT = 0;
        static final int BACK = 1;
        final PVector forward;
        final PVector side;
        final PVector up;

        private LineSegmentStruct(PVector p0, PVector p1, PVector mUpApprox) {
            forward = PVector.sub(p0, p1).normalize(null);
            side = PVector.cross(forward, mUpApprox, null).normalize(null);
            up = PVector.cross(forward, side, null).normalize(null);
        }
    }
}
