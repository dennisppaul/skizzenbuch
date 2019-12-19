package de.hfkbremen.mesh;

import processing.core.PGraphics;
import processing.core.PVector;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;

/**
 * https://en.wikipedia.org/wiki/Wavefront_.obj_file
 * http://paulbourke.net/dataformats/obj/
 */
public class OBJWriter extends PGraphics {

    public static final int LINE_CONVERSION_MODE_PLANE = 0;
    public static final int LINE_CONVERSION_MODE_VIERKANTROHR = 2;
    public static final int LINE_CONVERSION_MODE_VIERKANTROHR_CLOSED = 3;
    private static final int LINE_CONVERSION_MODE_CYLINDER = 1;
    private static final String OBJ_GROUP_NAME = "GROUP";
    private static final String OBJ_GROUP = "g";
    private static final String OBJ_VERTEX = "v";
    private static final String OBJ_FACE = "f";
    private static final String OBJ_SPACE = " ";
    private static final float EPSILON = 0.01f;
    private final ArrayList<String> mOBJVertexList = new ArrayList<>();
    private final ArrayList<String> mOBJIndexList = new ArrayList<>();
    private File mFile;
    private PrintWriter mWriter;
    private int mOBJVertexCount = 0;
    private int mLineConversionMode = LINE_CONVERSION_MODE_VIERKANTROHR_CLOSED;
    // ..............................................................
    private PVector AXIS_Z = new PVector(0, 0, 1);
    private PVector AXIS_Y = new PVector(0, 1, 0);
    private PVector AXIS_X = new PVector(1, 0, 0);

    public void setPath(String path) {
        this.path = path;
        if (path != null) {
            mFile = new File(path);
            if (!mFile.isAbsolute()) {
                mFile = null;
            }
        }
        if (mFile == null) {
            throw new RuntimeException("DXF export requires an absolute path " + "for the location of the output mFile.");
        }
    }

    protected void allocate() {
    /*
    for (int i = 0; i < MAX_TRI_LAYERS; i++) {
      layerList[i] = NO_LAYER;
    }
    */
        group(0);
    }

    public void dispose() {
        writeFooter();

        mWriter.flush();
        mWriter.close();
        mWriter = null;
    }

    // ..............................................................

    public boolean displayable() {
        return false;  // just in case someone wants to use this on its own
    }

    public boolean is2D() {
        return false;
    }

    public boolean is3D() {
        return true;
    }

    public void beginDraw() {
        // have to create mFile object here, because the name isn't yet
        // available in allocate()
        if (mWriter == null) {
            try {
                mWriter = new PrintWriter(new FileWriter(mFile));
            } catch (IOException e) {
                throw new RuntimeException(e);  // java 1.4+
            }
            writeHeader();
        }

        group(0);
    }

    public void endDraw() {
        writeLists();
        mWriter.flush();
    }

    private void group(int layer) {
        writeLists();
        write(OBJ_GROUP + OBJ_SPACE + (OBJ_GROUP_NAME + layer));
        write();
    }

    private void writeLists() {
        mOBJVertexList.forEach(this::write);
        if (mOBJVertexList.size() > 0) {
            write();
        }
        mOBJVertexList.clear();

        mOBJIndexList.forEach(this::write);
        if (mOBJIndexList.size() > 0) {
            write();
        }
        mOBJIndexList.clear();
        write();
    }

    private void write() {
        write("");
    }

    private void write(String s) {
        mWriter.println(s);
    }

    private void writeHeader() {
        write("# WaveFront created: " + System.currentTimeMillis());
    }

    private void writeFooter() {
    }

    private PVector getBestUpVector(PVector mDiff) {
        PVector mBestUpVector = new PVector();
        mBestUpVector.set(AXIS_Z);
        if (Math.abs(PVector.angleBetween(mDiff, AXIS_Z)) < EPSILON) {
            mBestUpVector.set(AXIS_Y);
            if (Math.abs(PVector.angleBetween(mDiff, AXIS_Y)) < EPSILON) {
                mBestUpVector.set(AXIS_X);
            }
        }
        return mBestUpVector;
    }

    protected void writeLine(int index0, int index1) {
        if (mLineConversionMode == LINE_CONVERSION_MODE_PLANE) {
            PVector l0 = new PVector(vertices[index0][X], vertices[index0][Y], vertices[index0][Z]);
            PVector l1 = new PVector(vertices[index1][X], vertices[index1][Y], vertices[index1][Z]);
            PVector mDiff = PVector.sub(l1, l0);
            PVector mBestUpVector = getBestUpVector(mDiff);

            PVector mCross = mDiff.cross(mBestUpVector);
            mCross.normalize();

            mCross.mult(strokeWeight);

            writeOBJTriangle(PVector.add(l0, mCross), l1, l0);
            writeOBJTriangle(PVector.add(l0, mCross), PVector.add(l1, mCross), l1);
        } else if (mLineConversionMode == LINE_CONVERSION_MODE_VIERKANTROHR || mLineConversionMode == LINE_CONVERSION_MODE_VIERKANTROHR_CLOSED) {
            PVector l0 = new PVector(vertices[index0][X], vertices[index0][Y], vertices[index0][Z]);
            PVector l1 = new PVector(vertices[index1][X], vertices[index1][Y], vertices[index1][Z]);
            PVector mDiff = PVector.sub(l1, l0);
            PVector mBestUpVector = getBestUpVector(mDiff);

            final float mWidth = strokeWeight * 0.5f;
            PVector p00 = mDiff.cross(mBestUpVector).normalize().mult(mWidth);
            PVector p01 = mDiff.cross(p00).normalize().mult(mWidth);
            PVector p02 = mDiff.cross(p01).normalize().mult(mWidth);
            PVector p03 = mDiff.cross(p02).normalize().mult(mWidth);

            // p00-p01
            writeOBJTriangle(PVector.add(l0, p00), PVector.add(l0, p01), PVector.add(l1, p00));
            writeOBJTriangle(PVector.add(l0, p01), PVector.add(l1, p01), PVector.add(l1, p00));
            // p01-p02
            writeOBJTriangle(PVector.add(l0, p01), PVector.add(l0, p02), PVector.add(l1, p01));
            writeOBJTriangle(PVector.add(l0, p02), PVector.add(l1, p02), PVector.add(l1, p01));
            // p02-p03
            writeOBJTriangle(PVector.add(l0, p02), PVector.add(l0, p03), PVector.add(l1, p02));
            writeOBJTriangle(PVector.add(l0, p03), PVector.add(l1, p03), PVector.add(l1, p02));
            // p03-p00
            writeOBJTriangle(PVector.add(l0, p03), PVector.add(l0, p00), PVector.add(l1, p03));
            writeOBJTriangle(PVector.add(l0, p00), PVector.add(l1, p00), PVector.add(l1, p03));

            if (mLineConversionMode == LINE_CONVERSION_MODE_VIERKANTROHR_CLOSED) {
                writeOBJTriangle(PVector.add(l0, p00), PVector.add(l0, p03), PVector.add(l0, p01));
                writeOBJTriangle(PVector.add(l0, p02), PVector.add(l0, p01), PVector.add(l0, p03));
                writeOBJTriangle(PVector.add(l1, p00), PVector.add(l1, p01), PVector.add(l1, p03));
                writeOBJTriangle(PVector.add(l1, p02), PVector.add(l1, p03), PVector.add(l1, p01));
            }

        } else if (mLineConversionMode == LINE_CONVERSION_MODE_CYLINDER) {
        }
    }

    private void writeOBJTriangle(PVector p0, PVector p1, PVector p2) {
        writeOBJTriangle(p0.x, p0.y, p0.z, p1.x, p1.y, p1.z, p2.x, p2.y, p2.z);
    }

    private void writeOBJTriangle(float v0,
                                  float v1,
                                  float v2,
                                  float v3,
                                  float v4,
                                  float v5,
                                  float v6,
                                  float v7,
                                  float v8) {
        writeOBJFace(writeOBJVertex(v0, v1, v2), writeOBJVertex(v3, v4, v5), writeOBJVertex(v6, v7, v8));
    }

    private void writeOBJFace(int i0, int i1, int i2) {
        String s = OBJ_FACE +
                OBJ_SPACE +
                i0 +
                OBJ_SPACE +
                i1 +
                OBJ_SPACE +
                i2;
        mOBJIndexList.add(s);
    }

    private int writeOBJVertex(float v0, float v1, float v2) {
        String s = OBJ_VERTEX +
                OBJ_SPACE +
                v0 +
                OBJ_SPACE +
                v1 +
                OBJ_SPACE +
                v2;
        mOBJVertexList.add(s);
        mOBJVertexCount++;
        return mOBJVertexCount;
    }

    protected void writeTriangle() {
    /*
    if (i < MAX_TRI_LAYERS) {
      if (layerList[i] >= 0) {
        currentLayer = layerList[i];
      }
    }
    */

        writeOBJTriangle(vertices[0][X],
                         vertices[0][Y],
                         vertices[0][Z],
                         vertices[1][X],
                         vertices[1][Y],
                         vertices[1][Z],
                         vertices[2][X],
                         vertices[2][Y],
                         vertices[2][Z]);

        vertexCount = 0;
    }

    // ..............................................................

    public void beginShape(int kind) {
        shape = kind;

        if ((shape != LINES) &&
                (shape != TRIANGLES) &&
                (shape != POLYGON)) {
            String err = "RawDXF can only be used with beginRaw(), " + "because it only supports lines and triangles";
            throw new RuntimeException(err);
        }

        if ((shape == POLYGON) && fill) {
            throw new RuntimeException("DXF Export only supports non-filled shapes.");
        }

        vertexCount = 0;
    }

    public void vertex(float x, float y) {
        vertex(x, y, 0);
    }

    public void vertex(float x, float y, float z) {
        float vertex[] = vertices[vertexCount];

        vertex[X] = x;  // note: not mx, my, mz like PGraphics3
        vertex[Y] = y;
        vertex[Z] = z;

        if (fill) {
            vertex[R] = fillR;
            vertex[G] = fillG;
            vertex[B] = fillB;
            vertex[A] = fillA;
        }

        if (stroke) {
            vertex[SR] = strokeR;
            vertex[SG] = strokeG;
            vertex[SB] = strokeB;
            vertex[SA] = strokeA;
            vertex[SW] = strokeWeight;
        }

        if (textureImage != null) {  // for the future?
            vertex[U] = textureU;
            vertex[V] = textureV;
        }
        vertexCount++;

        if ((shape == LINES) && (vertexCount == 2)) {
            writeLine(0, 1);
            vertexCount = 0;

/*
    } else if ((shape == LINE_STRIP) && (vertexCount == 2)) {
      writeLineStrip();
*/

        } else if ((shape == TRIANGLES) && (vertexCount == 3)) {
            writeTriangle();
        } else if (shape == POINTS) {
            // @todo write points as spheres
        }
    }

    public void endShape(int mode) {
        if (shape == POLYGON) {
            for (int i = 0; i < vertexCount - 1; i++) {
                writeLine(i, i + 1);
            }
            if (mode == CLOSE) {
                writeLine(vertexCount - 1, 0);
            }
        }
    /*
    if ((vertexCount != 0) &&
        ((shape != LINE_STRIP) && (vertexCount != 1))) {
      System.err.println("Extra vertex boogers found.");
    }
    */
    }

    public static String name() {
        return OBJWriter.class.getName();
    }
}
