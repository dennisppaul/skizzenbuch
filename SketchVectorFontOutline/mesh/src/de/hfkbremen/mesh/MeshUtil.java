package de.hfkbremen.mesh;

import processing.core.PGraphics;
import processing.core.PVector;

import java.util.ArrayList;

public class MeshUtil {

    public static int isClockWise2D(final ArrayList<PVector> mPoints) {

        if (mPoints.size() < 3) {
            return (0);
        }

        int mCount = 0;
        for (int i = 0; i < mPoints.size(); i++) {
            final PVector p1 = mPoints.get(i);
            final PVector p2 = mPoints.get((i + 1) % mPoints.size());
            final PVector p3 = mPoints.get((i + 2) % mPoints.size());
            float z;
            z = (p2.x - p1.x) * (p3.y - p2.y);
            z -= (p2.y - p1.y) * (p3.x - p2.x);
            if (z < 0) {
                mCount--;
            } else if (z > 0) {
                mCount++;
            }
        }
        if (mCount > 0) {
            return (VectorFont.COUNTERCLOCKWISE);
        } else if (mCount < 0) {
            return (VectorFont.CLOCKWISE);
        } else {
            return 0;
        }
    }

    public static boolean inside2DPolygon(final PVector thePoint, final ArrayList<PVector> thePolygon) {
        float x = thePoint.x;
        float y = thePoint.y;

        int c = 0;
        for (int i = 0, j = thePolygon.size() - 1; i < thePolygon.size(); j = i++) {
            if ((((thePolygon.get(i).y <= y) && (y < thePolygon.get(j).y)) || ((thePolygon.get(j).y <= y) && (y < thePolygon.get(i).y)))
                    && (x < (thePolygon
                    .get(j).x - thePolygon.get(i).x) * (y - thePolygon.get(i).y) / (thePolygon.get(j).y - thePolygon.get(i).y) +
                    thePolygon.get(
                    i).x)) {
                c = (c + 1) % 2;
            }
        }
        return c == 1;
    }

    public static float[] toArray3f(final ArrayList<PVector> theData) {
        float[] myArray = new float[theData.size() * 3];
        for (int i = 0; i < theData.size(); i++) {
            final PVector v = theData.get(i);
            if (v != null) {
                myArray[i * 3 + 0] = v.x;
                myArray[i * 3 + 1] = v.y;
                myArray[i * 3 + 2] = v.z;
            }
        }
        return myArray;
    }

    public static void createNormals(float[] theVertices, float[] theNormals) {
        final int NUMBER_OF_VERTEX_COMPONENTS = 3;
        final int myNumberOfPoints = 3;
        for (int i = 0; i < theVertices.length; i += (myNumberOfPoints * NUMBER_OF_VERTEX_COMPONENTS)) {
            PVector a = new PVector(theVertices[i + 0], theVertices[i + 1], theVertices[i + 2]);
            PVector b = new PVector(theVertices[i + 3], theVertices[i + 4], theVertices[i + 5]);
            PVector c = new PVector(theVertices[i + 6], theVertices[i + 7], theVertices[i + 8]);
            PVector myNormal = new PVector();
            calculateNormal(a, b, c, myNormal);

            theNormals[i + 0] = myNormal.x;
            theNormals[i + 1] = myNormal.y;
            theNormals[i + 2] = myNormal.z;

            theNormals[i + 3] = myNormal.x;
            theNormals[i + 4] = myNormal.y;
            theNormals[i + 5] = myNormal.z;

            theNormals[i + 6] = myNormal.x;
            theNormals[i + 7] = myNormal.y;
            theNormals[i + 8] = myNormal.z;
        }
    }

    public static void calculateNormal(final PVector pointA, final PVector pointB, final PVector pointC, final PVector theResultNormal) {
        PVector TMP_BA = PVector.sub(pointB, pointA);
        PVector TMP_BC = PVector.sub(pointC, pointB);

        theResultNormal.cross(TMP_BA, TMP_BC);
        theResultNormal.normalize();
    }

    public static int[] toArray(final ArrayList<Integer> theData) {
        int[] myArray = new int[theData.size()];
        for (int i = 0; i < myArray.length; i++) {
            if (theData.get(i) != null) {
                myArray[i] = theData.get(i);
            }
        }
        return myArray;
    }

    public static Mesh mesh(ArrayList<PVector> pTriangles) {
        return mesh(pTriangles, false);
    }

    public static Mesh mesh(ArrayList<PVector> pTriangles, final boolean pCreateNormals) {
        final float[] mVertices = toArray3f(pTriangles);
        final float[] mNormals;
        if (pCreateNormals) {
            mNormals = new float[mVertices.length];
            createNormals(mVertices, mNormals);
        } else {
            mNormals = null;
        }
        return new Mesh(mVertices, 3, null, 4, null, 2, mNormals, PGraphics.TRIANGLES);
    }

    /* convex hull 2D */

    public static boolean intersectRayTriangle(final PVector pRayOrigin,
                                               final PVector pRayDirection,
                                               final PVector v0,
                                               final PVector v1,
                                               final PVector v2,
                                               final IntersectionResult pIntersectionResult,
                                               final boolean pCullingFlag) {

        float det;
        float inv_det;
        final float M_EPSILON = 0.0000001f;

        PVector P_VEC = new PVector();
        PVector T_VEC = new PVector();
        PVector Q_VEC = new PVector();

        /* find vectors for two edges sharing vert0 */
        PVector TMP_EDGE_1 = PVector.sub(v1, v0);
        PVector TMP_EDGE_2 = PVector.sub(v2, v0);

        /* begin calculating determinant - also used to calculate U parameter */
        PVector.cross(pRayDirection, TMP_EDGE_2, P_VEC);

        /* if determinant is near zero, ray lies in plane of triangle */
        det = TMP_EDGE_1.dot(P_VEC);

        if (pCullingFlag) {
            /* define TEST_CULL if culling is desired */
            if (det < M_EPSILON) {
                return false;
            }
            /* calculate distance from vert0 to ray origin */
            PVector.sub(pRayOrigin, v0, T_VEC);

            /* calculate U parameter and test bounds */
            pIntersectionResult.u = T_VEC.dot(P_VEC);
            if (pIntersectionResult.u < 0.0f || pIntersectionResult.u > det) {
                return false;
            }

            /* prepare to test V parameter */
            PVector.cross(T_VEC, TMP_EDGE_1, Q_VEC);

            /* calculate V parameter and test bounds */
            pIntersectionResult.v = pRayDirection.dot(Q_VEC);
            if (pIntersectionResult.v < 0.0f || pIntersectionResult.u + pIntersectionResult.v > det) {
                return false;
            }

            /* calculate t, scale parameters, ray intersects triangle */
            pIntersectionResult.t = TMP_EDGE_2.dot(Q_VEC);
            inv_det = 1.0f / det;
            pIntersectionResult.t *= inv_det;
            pIntersectionResult.u *= inv_det;
            pIntersectionResult.v *= inv_det;
        } else {
            /* the non-culling branch */
            if (det > -M_EPSILON && det < M_EPSILON) {
                return false;
            }
            inv_det = 1.0f / det;

            /* calculate distance from vert0 to ray origin */
            PVector.sub(pRayOrigin, v0, T_VEC);

            /* calculate U parameter and test bounds */
            pIntersectionResult.u = T_VEC.dot(P_VEC) * inv_det;
            if (pIntersectionResult.u < 0.0f || pIntersectionResult.u > 1.0f) {
                return false;
            }

            /* prepare to test V parameter */
            PVector.cross(T_VEC, TMP_EDGE_1, Q_VEC);

            /* calculate V parameter and test bounds */
            pIntersectionResult.v = pRayDirection.dot(Q_VEC) * inv_det;
            if (pIntersectionResult.v < 0.0f || pIntersectionResult.u + pIntersectionResult.v > 1.0f) {
                return false;
            }

            /* calculate t, ray intersects triangle */
            pIntersectionResult.t = TMP_EDGE_2.dot(Q_VEC) * inv_det;
        }
        return true;
    }

    public static boolean findRayTriangleIntersectionPoint(PVector pRayOrigin,
                                                           PVector pRayDirection,
                                                           PVector v0,
                                                           PVector v1,
                                                           PVector v2,
                                                           PVector pIntersectionPoint,
                                                           boolean pCullingFlag) {
        IntersectionResult pIntersectionResult = new IntersectionResult();
        boolean mSuccess = intersectRayTriangle(pRayOrigin, pRayDirection, v0, v1, v2, pIntersectionResult, pCullingFlag);
        if (mSuccess) {
            if (pIntersectionResult.t <= 0) {
                pIntersectionPoint.set(pRayDirection);
                pIntersectionPoint.mult(pIntersectionResult.t);
                pIntersectionPoint.add(pRayOrigin);
            }
        }
        return mSuccess;
    }

    public static class IntersectionResult {

        public float t;

        public float u;

        public float v;

        public void clear() {
            v = 0;
            u = 0;
            t = 0;
        }
    }

    /* --- */

    public static ArrayList<PVector> giftWrap(ArrayList<PVector> points) {
        // initialize CH points output array.
        ArrayList<PVector> outputList = new ArrayList<>();

        int size = points.size();
        if (size < 3) {
            return points;
        }

        // find most bottom point, so find point with smallest y coordinate.
        int q1 = 0;
        for (int i = 1; i < size; i++) {
            if (points.get(i).y < points.get(q1).y) {
                q1 = i;
            }
        }
        int bottom = q1;
        int q2 = -1;
        outputList.add(points.get(q1));

        // now choose next point as q2 and keep finding next vertex via giftwrap.
        // Keep going until the next point is the bottom point, or the one we started with.
        while (q2 != bottom) {
            // q2 = next point in list, but if q1 is the last point, q2 == 1st point.
            q2 = (q1 + 1) % size;
            for (int i = 0; i < size; i++) {

                // if clock wise, keep moving, if not, that current point is a better next point.
                if (!ccw(points.get(q1), points.get(q2), points.get(i))) {
                    q2 = i;
                }
            }

            if (q2 != bottom) {
                // if q2 is not the bottom, add that point.
                outputList.add(points.get(q2));
            }
            q1 = q2;
        }
        return outputList;
    }

    // Orientation test: Returns true if all points are ccw or colinear
    public static boolean ccw(PVector a, PVector b, PVector c) {
        float sol = (b.y - a.y) * (c.x - b.x) - (b.x - a.x) * (c.y - b.y);
        return !(sol > 0);
    }

    // Orientation test: Returns true if all points are cw or colinear
    public static boolean cw(PVector a, PVector b, PVector c) {
        float sol = (b.y - a.y) * (c.x - b.x) - (b.x - a.x) * (c.y - b.y);
        return !(sol < 0);
    }
}
