package de.hfkbremen.mesh;

import processing.core.PApplet;
import processing.data.XML;
import processing.opengl.PGraphics3D;

import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.List;

import static de.hfkbremen.mesh.Location.exists;

public class RendererCycles extends PGraphics3D {

    private static final String EXEC_FILE_NAME = "cycles";
    private static final String XML_NODE_CYCLES = "cycles";
    private static final String XML_NODE_CAMERA = "camera";
    private static final String XML_NODE_BACKGROUND = "background";
    private static final String XML_NODE_MESH = "mesh";
    private static final String XML_NODE_OBJECT = "state";
    private static final String XML_NODE_CONNECT = "connect";
    private static final String XML_NODE_DIFFUSE = "diffuse_bsdf";
    private static final String XML_NODE_TRANSFORM = "transform";
    private static final String XML_ATTR_WIDTH = "width";
    private static final String XML_ATTR_HEIGHT = "height";
    private static final String XML_ATTR_TYPE = "type";
    private static final String XML_ATTR_MATRIX = "matrix";
    private static final String XML_ATTR_NAME = "name";
    private static final String XML_ATTR_POINTS = "P";
    private static final String XML_ATTR_NVERTS = "nverts";
    private static final String XML_ATTR_VERTS = "verts";
    private static final String XML_ATTR_COLOR = "color";
    private static final String XML_ATTR_FROM = "from";
    private static final String XML_ATTR_TO = "to";
    private static final String XML_UNI_SHADER = "shader";
    private static final String VALUE_FROM_DIFFUSE = "diffuse bsdf";
    private static final String VALUE_OUTPUT_SURFACE = "output surface";
    private static final String SHADER_TYPE_DIFFUSE = "diffuse";
    private static final char DELIMITER = ' ';
    private static final String SHADER_NAME = "s_";

    private final ArrayList<Float> mTriangleList = new ArrayList<>();
    private final ArrayList<Float> mLineList = new ArrayList<>();

    private boolean RENDERING_PROCESS_BLOCKING = false;
    private String mCameraType = "perspective";
    private File mFile;
    private XML mXML;
    private String mExecPath;
    private int mShaderNameID = 0;

    public RendererCycles() {
        this("/Users/dennisppaul/dev/tools/git/tools/mesh/lib/cycles");
        //        this(EXEC_FILE_NAME);
    }

    public RendererCycles(String path_to_executable) {
        mExecPath = Location.get(path_to_executable);
        if (!exists(mExecPath)) {
            /* try default location */
            error("couldn t find `cycles` at location `" + mExecPath + "` trying default location `" + Location.get(
                    EXEC_FILE_NAME) + "`");
            mExecPath = Location.get(EXEC_FILE_NAME);
            if (!exists(mExecPath)) {
                error("couldn t find `cycles` at default location.");
            }
        }
        if (exists(mExecPath)) {
            System.out.println("### found `cycles` at location " + mExecPath);
        }
    }

    private void error(String pErrorMessage) {
        System.err.println("### @" + getClass().getSimpleName() + " / " + pErrorMessage);
    }

    private void console(String pErrorMessage) {
        System.out.println("+++ @" + getClass().getSimpleName() + " / " + pErrorMessage);
    }

    public XML getXML() {
        return mXML;
    }

    private void buildCamera(XML pXML) {
        //        if (!(g instanceof PGraphics3D)) {
        //            error("camera requires a `PGraphics3D` context to function");
        //        }
        int mWidth = width;
        int mHeight = height;
        float[] mCameraMatrix = new float[16];
        getMatrix().get(mCameraMatrix);
        mCameraMatrix[14] = -height * 2;// TODO find out why this is necessary / still off 105%
        // TODO fix y-axis flip
        mCameraMatrix[0] *= 1;
        mCameraMatrix[5] *= 1;
        mCameraMatrix[10] *= 1;

        float[] mParentCameraMatrix = new float[16];
        parent.g.getMatrix().get(mParentCameraMatrix);
        for (int i = 0; i < mParentCameraMatrix.length; i++) {
            System.out.print(mParentCameraMatrix[i] + ", ");
            if (i % 4 == 3) {
                System.out.println();
            }
        }

        {
            XML mCamera = new XML(XML_NODE_CAMERA);
            mCamera.setInt(XML_ATTR_WIDTH, mWidth);
            mCamera.setInt(XML_ATTR_HEIGHT, mHeight);
            pXML.addChild(mCamera);
        }
        {
            XML mCameraTransform = new XML(XML_NODE_TRANSFORM);
            setMatrix4x4(mCameraTransform, mCameraMatrix);
            XML mCamera = new XML(XML_NODE_CAMERA);
            mCamera.setString(XML_ATTR_TYPE, mCameraType);
            mCameraTransform.addChild(mCamera);
            pXML.addChild(mCameraTransform);
        }
        //          <camera width="800" height="500" />
        //          <transform matrix="1 0 0 0
        //                             0 1 0 0
        //                             0 0 1 0
        //                             0 0 -4 1">
        //              <camera type="perspective" />
        //          </transform>
    }

    private void buildBackground(XML pXML) {
        final String BACKGROUND_NAME = "bg";
        XML mBackgroundNode = new XML(XML_NODE_BACKGROUND);
        {
            XML mBackgroundPropertyNode = new XML(XML_NODE_BACKGROUND);
            mBackgroundPropertyNode.setString(XML_ATTR_NAME, BACKGROUND_NAME);
            mBackgroundPropertyNode.setFloat("strength", 2.0f);
            mBackgroundPropertyNode.setString(XML_ATTR_COLOR, getColorAttr(0.5f, 0.5f, 0.5f));
            mBackgroundPropertyNode.setFloat("SurfaceMixWeight", 1.0f);
            mBackgroundNode.addChild(mBackgroundPropertyNode);

            XML mConnectNode = new XML(XML_NODE_CONNECT);
            mConnectNode.setString(XML_ATTR_FROM, BACKGROUND_NAME + DELIMITER + "background");
            mConnectNode.setString(XML_ATTR_TO, VALUE_OUTPUT_SURFACE);
            mBackgroundNode.addChild(mConnectNode);
        }
        pXML.addChild(mBackgroundNode);
        //      <background>
        //	        <background name="bg" strength="2.0" color="0.5, 0.5, 0.5" SurfaceMixWeight="1.0"/>
        //	        <connect from="bg background" to="output surface" />
        //      </background>
    }

    private void buildShader(XML pXML, String pShaderName, float r, float g, float b) {
        final float mRoughness = 0.0f;
        XML mShaderNode = new XML(XML_UNI_SHADER);
        mShaderNode.setString(XML_ATTR_NAME, pShaderName);
        {
            XML mDiffuseNode = new XML(XML_NODE_DIFFUSE);
            mDiffuseNode.setString(XML_ATTR_NAME, SHADER_TYPE_DIFFUSE);
            mDiffuseNode.setFloat("roughness", mRoughness);
            mDiffuseNode.setString(XML_ATTR_COLOR, getColorAttr(r, g, b));
            mShaderNode.addChild(mDiffuseNode);
        }
        {
            XML mConnectNode = new XML(XML_NODE_CONNECT);
            mConnectNode.setString(XML_ATTR_FROM, VALUE_FROM_DIFFUSE);
            mConnectNode.setString(XML_ATTR_TO, VALUE_OUTPUT_SURFACE);
            mShaderNode.addChild(mConnectNode);
        }
        pXML.addChild(mShaderNode);
        //      <shader name="floor">
        //	        <diffuse_bsdf name="diffuse" roughness="0.0" color="1.0, 0.5, 0.0" />
        //	        <connect from="diffuse bsdf" to="output surface" />
        //      </shader>
    }

    private void buildObject(XML pXML, String pShaderName, float[] pTriangleList) {
        XML mObjNode = new XML(XML_NODE_OBJECT);
        mObjNode.setString(XML_UNI_SHADER, pShaderName);
        XML mMeshNode = buildMesh(pTriangleList);
        mObjNode.addChild(mMeshNode);
        pXML.addChild(mObjNode);
        //      <state shader="floor">
        //	        <mesh P="-3 3 0  3 3 0  3 -3 0  -3 -3 0" nverts="4" verts="0 1 2 3" />
        //      </state>
    }

    private XML buildMesh(float[] pTriangleList) {
        StringBuilder mPoints = new StringBuilder();
        StringBuilder mNumberOfVertices = new StringBuilder();
        StringBuilder mVertexList = new StringBuilder();

        for (int i = 0; i < pTriangleList.length; i += 9) {
            for (int j = 0; j < 3; j++) {
                for (int k = 0; k < 3; k++) {
                    mPoints.append(pTriangleList[i + j * 3 + k]).append(DELIMITER);
                }
                mPoints.append(DELIMITER);
                mVertexList.append(i / 3 + j).append(DELIMITER);
            }
            mVertexList.append(DELIMITER);
            mNumberOfVertices.append(3).append(DELIMITER);
        }

        XML mMeshNode = new XML(XML_NODE_MESH);
        mMeshNode.setString(XML_ATTR_POINTS, mPoints.toString());
        mMeshNode.setString(XML_ATTR_NVERTS, mNumberOfVertices.toString());
        mMeshNode.setString(XML_ATTR_VERTS, mVertexList.toString());
        return mMeshNode;
        //	        <mesh P="-3 3 0  3 3 0  3 -3 0  -3 -3 0" nverts="4" verts="0 1 2 3" />
        //	        <mesh P="-3 3 0  3 3 0  3 -3 0" nverts="3" verts="0 1 2 " />
    }

    private String getColorAttr(float r, float g, float b) {
        final String D = ", ";
        return r + D + g + D + b;
    }

    private void setMatrix4x4(XML pNode, float[] pMatrix4x4) {
        StringBuilder s = new StringBuilder();
        for (float aPMatrix4x4 : pMatrix4x4) {
            s.append(aPMatrix4x4);
            s.append(' ');
        }
        pNode.setString(XML_ATTR_MATRIX, s.toString());
    }

    private void launchRenderer(String pXMLPath) {
        try {
            Process mProcess = Runtime.getRuntime().exec(new String[]{mExecPath, pXMLPath});

            console("executing command `" + mExecPath + " " + pXMLPath + "`");

            StreamConsumer mErrorStream = new StreamConsumer(mProcess.getErrorStream(), "ERR");
            StreamConsumer mOutputStream = new StreamConsumer(mProcess.getInputStream(), "OUT");
            mErrorStream.start();
            mOutputStream.start();

            if (RENDERING_PROCESS_BLOCKING) {
                try {
                    mProcess.waitFor();
                } catch (InterruptedException ex) {
                    ex.printStackTrace();
                }
            }

            console("done executing command");
        } catch (IOException ex) {
            ex.printStackTrace();
        }
    }

    /* --- PGraphics --- */

    public void setPath(String pPath) {
        path = pPath;
        if (pPath != null) {
            mFile = new File(pPath);
            if (!mFile.isAbsolute()) {
                mFile = null;
            }
        }
        if (mFile == null) {
            error("coulnd t create output file `" + pPath + "`");
        }
    }

    public boolean displayable() {
        return false;
    }

    // ..............................................................

    public void beginDraw() {
        if (mXML == null) {
            mXML = new XML(XML_NODE_CYCLES);
        }
    }

    public void endDraw() {
        buildCamera(mXML);
        buildBackground(mXML);

        if (mXML != null && mFile != null) {
            mXML.save(mFile);
//            mXML.print();
            launchRenderer(mFile.getPath());
            mXML = null;
        }
    }

    // ..............................................................

    public void beginShape(int kind) {
        System.out.println("beginShape"); // TODO `beginShape` only gets called once
        shape = kind;

        if ((shape != LINES) && (shape != TRIANGLES) && (shape != POLYGON)) {
            String err = "renderer can only be used with beginRaw(), " + "because it only supports lines and triangles_continuous";
            throw new RuntimeException(err);
        }

        if ((shape == POLYGON) && fill) {
            throw new RuntimeException("renderer only supports non-filled shapes.");
        }

        vertexCount = 0;
    }

    public void endShape(int mode) {
        System.out.println("endShape"); // TODO `endShape` only gets called once, this creates a problem with shaders
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

        final String mCurrentShaderName = SHADER_NAME + mShaderNameID;
        mShaderNameID++;

        buildShader(mXML, mCurrentShaderName, fillR, fillG, fillB); // TODO fillA?
        buildObject(mXML, mCurrentShaderName, toArray(mTriangleList));
        mTriangleList.clear();

        /* TODO handle line list, build object */
        mLineList.clear();
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
        }
    }

    public boolean is2D() {
        return false;
    }

    public boolean is3D() {
        return true;
    }

    protected void writeLine(int index1, int index2) {
        mTriangleList.add(vertices[index1][X]);
        mTriangleList.add(vertices[index1][Y]);
        mTriangleList.add(vertices[index1][Z]);

        mTriangleList.add(vertices[index2][X]);
        mTriangleList.add(vertices[index2][Y]);
        mTriangleList.add(vertices[index2][Z]);
    }

    protected void writeTriangle() {
        for (int i = 0; i < 3; i++) {
            mTriangleList.add(vertices[i][X]);
            mTriangleList.add(vertices[i][Y]);
            mTriangleList.add(vertices[i][Z]);
        }
        vertexCount = 0;
    }

    private static float[] toArray(List<Float> pFloatList) {
        float[] mArray = new float[pFloatList.size()];
        for (int i = 0; i < mArray.length; i++) {
            mArray[i] = pFloatList.get(i);
        }
        return mArray;
    }

    public static RendererCycles beginRaw(PApplet pParent, String pOutputPath) {
        return (RendererCycles) pParent.beginRaw(RendererCycles.class.getName(), pOutputPath);
    }

    /* --- console output--- */

    private class StreamConsumer extends Thread {

        private InputStream mStream;

        private String mStreamName;

        StreamConsumer(InputStream theStream, String theStreamName) {
            mStream = theStream;
            mStreamName = theStreamName;
        }

        public void run() {
            try {
                final InputStreamReader isr = new InputStreamReader(mStream);
                final BufferedReader br = new BufferedReader(isr);
                String line;
                while ((line = br.readLine()) != null) {
                    System.out.println(mStreamName + "> " + line);
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }
}
