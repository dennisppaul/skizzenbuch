package de.hfkbremen.mesh;

import processing.core.PGraphics;
import processing.core.PVector;

import java.util.ArrayList;

public class IndexedTriangleList {

    private static final int NOT_FOUND = -1;
    public final ArrayList<PVector> vertices;
    public final ArrayList<Integer> indices;

    public IndexedTriangleList() {
        vertices = new ArrayList<>();
        indices = new ArrayList<>();
    }

    public IndexedTriangleList(ArrayList<PVector> pVertexList, ArrayList<Integer> pIndexList) {
        vertices = pVertexList;
        indices = pIndexList;
    }

    private static int findVertexInIndexList(ArrayList<PVector> mOptimizedVertexList, PVector v, float pEpsilon) {
        for (int j = 0; j < mOptimizedVertexList.size(); j++) {
            final PVector vo = mOptimizedVertexList.get(j);
            boolean isNear = near(v, vo, pEpsilon);
            if (isNear) {
                return j;
            }
        }
        return NOT_FOUND;
    }

    private static boolean near(PVector v0, PVector v1, float pMinDistance) {
        if (pMinDistance == 0) {
            return v0.x == v1.x && v0.y == v1.y && v0.z == v1.z;
        } else {
            final float mDistance = PVector.dist(v0, v1);
            return mDistance < pMinDistance;
        }
    }

    public void draw(PGraphics g) {
        g.beginShape(PGraphics.TRIANGLES);
        for (Integer indice : indices) {
            int mIndex = indice;
            PVector p = vertices.get(mIndex);
            g.vertex(p.x, p.y, p.z);
        }
        g.endShape();
    }

    public static IndexedTriangleList optimize(float[] pMeshData) {
        return optimize(pMeshData, 0.0f);

    }

    public static IndexedTriangleList optimize(float[] pMeshData, float pMinDistance) {
        ArrayList<PVector> mRawVertexList = new ArrayList<>();
        for (int i = 0; i < pMeshData.length; i += 3) {
            PVector v = new PVector().set(pMeshData[i + 0], pMeshData[i + 1], pMeshData[i + 2]);
            mRawVertexList.add(v);
        }
        return optimize(mRawVertexList, pMinDistance);
    }

    public static IndexedTriangleList optimize(ArrayList<PVector> pVertexList, float pMinDistance) {
        ArrayList<PVector> mOptimizedVertexList = new ArrayList<>();
        ArrayList<Integer> mOptimizedIndexList = new ArrayList<>();
        int mIndexCounter = 0;
        for (final PVector v : pVertexList) {
            int mExistingIndex = findVertexInIndexList(mOptimizedVertexList, v, pMinDistance);
            if (mExistingIndex == NOT_FOUND) {
                mOptimizedVertexList.add(v);
                mOptimizedIndexList.add(mIndexCounter);
                mIndexCounter++;
            } else {
                mOptimizedIndexList.add(mExistingIndex);
            }
        }

        return new IndexedTriangleList(mOptimizedVertexList, mOptimizedIndexList);
    }
}
