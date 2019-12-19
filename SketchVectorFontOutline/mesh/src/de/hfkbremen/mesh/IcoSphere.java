package de.hfkbremen.mesh;

import processing.core.PApplet;
import processing.core.PGraphics;
import processing.core.PVector;

import java.util.ArrayList;
import java.util.Hashtable;

/**
 * from http://blog.andreaskahler.com/2009/06/creating-icosphere-mesh-in-code.html
 */

public class IcoSphere {

    private IndexedTriangleList mGeometry;
    private int mIndex;
    private Hashtable<Integer, Integer> mMiddlePointIndexCache;

    private IcoSphere() {
    }

    // add vertex to mesh, fix position to be on unit sphere, return mIndex
    private int addVertex(PVector p) {
        float length = PApplet.sqrt(p.x * p.x + p.y * p.y + p.z * p.z);
        mGeometry.vertices.add(new PVector(p.x / length, p.y / length, p.z / length));
        return mIndex++;
    }

    // return mIndex of point in the middle of p1 and p2
    private int getMiddlePoint(int p1, int p2) {

        // first check if we have it already
        boolean firstIsSmaller = p1 < p2;
        int smallerIndex = firstIsSmaller ? p1 : p2;
        int greaterIndex = firstIsSmaller ? p2 : p1;
        int key = (smallerIndex << 16) + greaterIndex;

        Integer ret = mMiddlePointIndexCache.get(key);
        if (ret != null) {
            return ret;
        }

        // not in cache, calculate it
        PVector point1 = mGeometry.vertices.get(p1);
        PVector point2 = mGeometry.vertices.get(p2);
        PVector middle = new PVector((point1.x + point2.x) / 2.0f,
                                     (point1.y + point2.y) / 2.0f,
                                     (point1.z + point2.z) / 2.0f);

        // add vertex makes sure point is on unit sphere
        int i = addVertex(middle);

        // store it, return mIndex
        mMiddlePointIndexCache.put(key, i);

        return i;
    }

    public IndexedTriangleList create(int pRecursionLevel) {
        mGeometry = new IndexedTriangleList();
        mMiddlePointIndexCache = new Hashtable<>();
        mIndex = 0;

        // create 12 vertices of a icosahedron
        float t = (1.0f + PApplet.sqrt(5.0f)) / 2.0f;

        addVertex(new PVector(-1, t, 0));
        addVertex(new PVector(1, t, 0));
        addVertex(new PVector(-1, -t, 0));
        addVertex(new PVector(1, -t, 0));

        addVertex(new PVector(0, -1, t));
        addVertex(new PVector(0, 1, t));
        addVertex(new PVector(0, -1, -t));
        addVertex(new PVector(0, 1, -t));

        addVertex(new PVector(t, 0, -1));
        addVertex(new PVector(t, 0, 1));
        addVertex(new PVector(-t, 0, -1));
        addVertex(new PVector(-t, 0, 1));

        // create 20 triangles of the icosahedron
        ArrayList<TriangleIndices> faces = new ArrayList<>();

        // 5 faces around point 0
        faces.add(new TriangleIndices(0, 11, 5));
        faces.add(new TriangleIndices(0, 5, 1));
        faces.add(new TriangleIndices(0, 1, 7));
        faces.add(new TriangleIndices(0, 7, 10));
        faces.add(new TriangleIndices(0, 10, 11));

        // 5 adjacent faces
        faces.add(new TriangleIndices(1, 5, 9));
        faces.add(new TriangleIndices(5, 11, 4));
        faces.add(new TriangleIndices(11, 10, 2));
        faces.add(new TriangleIndices(10, 7, 6));
        faces.add(new TriangleIndices(7, 1, 8));

        // 5 faces around point 3
        faces.add(new TriangleIndices(3, 9, 4));
        faces.add(new TriangleIndices(3, 4, 2));
        faces.add(new TriangleIndices(3, 2, 6));
        faces.add(new TriangleIndices(3, 6, 8));
        faces.add(new TriangleIndices(3, 8, 9));

        // 5 adjacent faces
        faces.add(new TriangleIndices(4, 9, 5));
        faces.add(new TriangleIndices(2, 4, 11));
        faces.add(new TriangleIndices(6, 2, 10));
        faces.add(new TriangleIndices(8, 6, 7));
        faces.add(new TriangleIndices(9, 8, 1));

        // refine triangles
        for (int i = 0; i < pRecursionLevel; i++) {
            ArrayList<TriangleIndices> faces2 = new ArrayList<>();
            for (TriangleIndices tri : faces) {
                // replace triangle by 4 triangles
                int a = getMiddlePoint(tri.v1, tri.v2);
                int b = getMiddlePoint(tri.v2, tri.v3);
                int c = getMiddlePoint(tri.v3, tri.v1);

                faces2.add(new TriangleIndices(tri.v1, a, c));
                faces2.add(new TriangleIndices(tri.v2, b, a));
                faces2.add(new TriangleIndices(tri.v3, c, b));
                faces2.add(new TriangleIndices(a, b, c));
            }
            faces = faces2;
        }

        // done, now add triangles to mesh
        for (TriangleIndices tri : faces) {
            mGeometry.indices.add(tri.v1);
            mGeometry.indices.add(tri.v2);
            mGeometry.indices.add(tri.v3);
        }

        return mGeometry;
    }

    public static Mesh mesh(int pRecursionLevel) {
        IcoSphere is = new IcoSphere();
        IndexedTriangleList m = is.create(pRecursionLevel);
        float[] mVertices = new float[m.indices.size() * 3];
        for (int i = 0; i < m.indices.size(); i++) {
            PVector v = m.vertices.get(m.indices.get(i));
            mVertices[i * 3 + 0] = v.x;
            mVertices[i * 3 + 1] = v.y;
            mVertices[i * 3 + 2] = v.z;
        }

        return new Mesh(mVertices, 3, null, 3, null, 2, null, PGraphics.TRIANGLES);
    }

    public static IndexedTriangleList indexed_triangle_list(int pRecursionLevel) {
        IcoSphere is = new IcoSphere();
        return is.create(pRecursionLevel);
    }

    private class TriangleIndices {

        public int v1;
        public int v2;
        public int v3;

        public TriangleIndices(int pV1, int pV2, int pV3) {
            v1 = pV1;
            v2 = pV2;
            v3 = pV3;
        }
    }
}
