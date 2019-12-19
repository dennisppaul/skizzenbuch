package de.hfkbremen.mesh;

import processing.core.PGraphics;
import processing.core.PVector;

import java.util.ArrayList;

public class Mesh {

    private final int mNormalsComponentsCount;
    private int mTextureCoordComponentsCount;
    private int mNumberOfAtoms;
    private int mDrawStart;
    private int mDrawLength;
    private int mPrimitive;
    private float[] mVertices;
    private int mVertexComponentsCount;
    private float[] mColors;
    private int mColorComponentsCount;
    private float[] mNormals;
    private float[] mTexCoords;

    public Mesh(float[] pVertices) {
        this(pVertices, 3, null, 0, null, 0, null, PGraphics.TRIANGLES);
    }

    public Mesh(float[] pVertices,
                int pVertexComponents,
                float[] pColors,
                int pColorComponents,
                float[] pTexCoords,
                int pTextureCoordComponents,
                float[] pNormals,
                int pPrimitive) {

        mVertices = pVertices;
        mColors = pColors;
        mNormals = pNormals;
        mTexCoords = pTexCoords;

        mVertexComponentsCount = pVertexComponents;
        mColorComponentsCount = pColorComponents;
        mNormalsComponentsCount = 3;
        mTextureCoordComponentsCount = pTextureCoordComponents;

        mNumberOfAtoms = mVertices.length / mVertexComponentsCount;
        mDrawStart = 0;
        mDrawLength = mNumberOfAtoms;

        primitive(pPrimitive);

        /* check data integritiy */
        checkDataIntegrity();
    }

    public void primitive(int pPrimitive) {
        switch (pPrimitive) {
            case PGraphics.POINTS:
            case PGraphics.LINES:
            case PGraphics.TRIANGLES:
            case PGraphics.TRIANGLE_FAN:
            case PGraphics.TRIANGLE_STRIP:
            case PGraphics.QUADS:
            case PGraphics.QUAD_STRIP:
                checkDataIntegrity();
                mPrimitive = pPrimitive;
                return;
        }

        System.out.println("### WARNING @ `Mesh.primitive(int)` / primitive type might not be supported: " + pPrimitive);
        mPrimitive = pPrimitive;
        /*
         * POINTS,
         * LINES,
         * TRIANGLES,
         * TRIANGLE_FAN,
         * TRIANGLE_STRIP,
         * QUADS,
         * QUAD_STRIP
         */
    }

    private boolean checkDataIntegrity() {
        if (mVertices == null) {
            System.err.print("### WARNING @ Mesh / problems with data reference");
            System.err.println("/ vertex data is 'null'");
            return false;
        }
        if (mNumberOfAtoms * mVertexComponentsCount != mVertices.length) {
            System.err.print("### WARNING @ Mesh / problems with data integrity ");
            System.err.println("/ vertex");
            return false;
        }
        if ((mColors != null) && (mColors.length != 0) && (mColors.length / mColorComponentsCount != mNumberOfAtoms)) {
            System.err.print("### WARNING @ Mesh / problems with data integrity ");
            System.err.println("/ color");
            return false;
        }
        if ((mTexCoords != null) && (mTexCoords.length != 0) && (mTexCoords.length / mTextureCoordComponentsCount != mNumberOfAtoms)) {
            System.err.print("### WARNING @ Mesh / problems with data integrity ");
            System.err.println("/ texture coordinates");
            return false;
        }

        if ((mNormals != null) && (mNormals.length != 0) && (mNormals.length / mNormalsComponentsCount != mNumberOfAtoms)) {
            System.err.print("### WARNING @ Mesh / problems with data integrity ");
            System.err.println("/ vertex_normals");
            return false;
        }

        /** @todo also test primitive type VS number of components */
        return true;
    }

    public float[] vertices() {
        return mVertices;
    }

    public float[] colors() {
        return mColors;
    }

    public float[] normals() {
        return mNormals;
    }

    public float[] texcoords() {
        return mTexCoords;
    }

    public void drawstart(int theStart) {
        mDrawStart = theStart;
    }

    public void drawlength(int theLength) {
        mDrawLength = theLength;
    }

    public int drawstart() {
        return mDrawStart;
    }

    public int drawlength() {
        return mDrawLength;
    }

    public int atomcount() {
        return mNumberOfAtoms;
    }

    public int getColorComponentsCount() {
        return mColorComponentsCount;
    }

    public int getVertexComponentsCount() {
        return mVertexComponentsCount;
    }

    public int getTexCoordComponentsCount() {
        return mTextureCoordComponentsCount;
    }

    public void draw(PGraphics g) {
        /* geometrie */
        g.pushMatrix();

        /* model */
        int myNormalIndex = mDrawStart * mNormalsComponentsCount;
        int myTexCoordIndex = mDrawStart * mTextureCoordComponentsCount;
        int myColorIndex = mDrawStart * mColorComponentsCount;
        int myVertexIndex = mDrawStart * mVertexComponentsCount;

        g.beginShape(mPrimitive);

        boolean mHasTexture = false;
        if (mTexCoords != null && mTexCoords.length != 0) {
            if (mTextureCoordComponentsCount == 2) {
                mHasTexture = true;
            } else {
                System.out.println("### WARNING @ `Mesh.draw(PGraphics)` / only 2D textures (u ,v) are supported.");
            }
        }

        for (int i = 0; i < mDrawLength; i++) {
            /* vertex_normals */
            if (mNormals != null && mNormals.length != 0) {
                g.normal(mNormals[myNormalIndex], mNormals[myNormalIndex + 1], mNormals[myNormalIndex + 2]); // 3f
                myNormalIndex += mNormalsComponentsCount;
            }
            /* texcoords */
            float u = 0;
            float v = 0;
            if (mHasTexture) {
                u = mTexCoords[myTexCoordIndex];
                v = mTexCoords[myTexCoordIndex + 1];
                myTexCoordIndex += mTextureCoordComponentsCount;
            }
            /* color */
            if (mColors != null && mColors.length != 0) {
                if (mColorComponentsCount == 3) {
                    g.color(mColors[myColorIndex], mColors[myColorIndex + 1], mColors[myColorIndex + 2]); // 3f
                } else if (mColorComponentsCount == 4) {
                    g.color(mColors[myColorIndex],
                            mColors[myColorIndex + 1],
                            mColors[myColorIndex + 2],
                            mColors[myColorIndex + 3]); // 4f
                }
                myColorIndex += mColorComponentsCount;
            }
            /* vertex */
            if (mVertexComponentsCount == 3) {
                if (mHasTexture) {
                    g.vertex(mVertices[myVertexIndex],
                             mVertices[myVertexIndex + 1],
                             mVertices[myVertexIndex + 2],
                             u,
                             v); // 3f + texture
                } else {
                    g.vertex(mVertices[myVertexIndex],
                             mVertices[myVertexIndex + 1],
                             mVertices[myVertexIndex + 2]); // 3f
                }
            } else if (mVertexComponentsCount == 2) {
                if (mHasTexture) {
                    g.vertex(mVertices[myVertexIndex], mVertices[myVertexIndex + 1], u, v); // 2f + texture
                } else {
                    g.vertex(mVertices[myVertexIndex], mVertices[myVertexIndex + 1]); // 2f
                }
            }
            myVertexIndex += mVertexComponentsCount;
        }
        g.endShape();

        /* finish drawing */
        g.popMatrix();
    }

    public ArrayList<Triangle> triangles() {
        final ArrayList<Triangle> mTriangles = new ArrayList<>();
        int myVertexIndex = mDrawStart * mVertexComponentsCount;

        for (int i = 0; i < mDrawLength; i += 3) {
            Triangle t = new Triangle();
            t.a.set(mVertices[myVertexIndex], mVertices[myVertexIndex + 1], mVertices[myVertexIndex + 2]);
            myVertexIndex += mVertexComponentsCount;
            t.b.set(mVertices[myVertexIndex], mVertices[myVertexIndex + 1], mVertices[myVertexIndex + 2]);
            myVertexIndex += mVertexComponentsCount;
            t.c.set(mVertices[myVertexIndex], mVertices[myVertexIndex + 1], mVertices[myVertexIndex + 2]);
            myVertexIndex += mVertexComponentsCount;
            mTriangles.add(t);
        }
        return mTriangles;
    }

    public void translate(float x, float y, float z) {
        for (int i = 0; i < mVertices.length; i += 3) {
            mVertices[i + 0] = mVertices[i + 0] + x;
            mVertices[i + 1] = mVertices[i + 1] + y;
            mVertices[i + 2] = mVertices[i + 2] + z;
        }
    }

    public void translate(PVector p) {
        translate(p.x, p.y, p.z);
    }
}
