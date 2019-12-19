package de.hfkbremen.mesh;

import processing.core.PApplet;
import processing.core.PGraphics;
import processing.core.PVector;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.Vector;

public class ModelLoaderOBJ {

    /* normal */
    public static boolean VERBOSE = false;
    public static int GET_NORMALS_CCW = 0;
    public static int GET_NORMALS_CW = 1;
    public static int GET_NORMALS_DIRECTION = GET_NORMALS_CCW;
    public static int NUMBER_OF_VERTEX_COMPONENTS = 3;
    public static int PRIMITIVE = PGraphics.TRIANGLES;
    private static int GROUP_NAME_INDEX_COUNTER = 0;

    private static float[] distributeVertices(Vector<Float> theTempVertices,
                                              Vector<Integer> theTempVertexIndices,
                                              float[] theUnsortedVertices,
                                              int[] theFaces,
                                              int theIndexOffset) {
        float[] theVertices = new float[theTempVertices.size()];
        for (int i = 0; i < theTempVertices.size(); i++) {
            theVertices[i] = theTempVertices.get(i);
            theUnsortedVertices[i] = theTempVertices.get(i);
        }
        for (int i = 0; i < theTempVertexIndices.size(); i++) {
            theFaces[i] = ((Integer) (theTempVertexIndices.elementAt(i))).intValue() - 1 - theIndexOffset;
        }
        theVertices = rearrangeVertices(theVertices, theFaces, 3, new PVector(1, 1, 1), new PVector(0, 0, 0));

        return theVertices;
    }

    private static float[] distributeTexCoordinates(Vector<Float> theTempTexCoords,
                                                    Vector<Integer> theTempTexCoordsIndices,
                                                    int theIndexOffset) {
        float[] myTexCoordinates = new float[theTempTexCoords.size()];
        for (int i = 0; i < theTempTexCoords.size(); i++) {
            myTexCoordinates[i] = theTempTexCoords.get(i);
        }
        int[] myTexCoordsIndices = new int[theTempTexCoordsIndices.size()];
        for (int i = 0; i < theTempTexCoordsIndices.size(); i++) {
            myTexCoordsIndices[i] = (int) ((Integer) (theTempTexCoordsIndices.elementAt(i))).intValue() - 1 - theIndexOffset;
        }
        myTexCoordinates = rearrangeVertices(myTexCoordinates,
                                             myTexCoordsIndices,
                                             2,
                                             new PVector(1, 1, 1),
                                             new PVector(0, 0, 0));
        return myTexCoordinates;
    }

    private static float[] distributeNormals(Vector<Float> theTempNormals,
                                             Vector<Integer> theTempNormalIndices,
                                             int theIndexOffset,
                                             float[] theVertices) {
        float[] myNormals = null;
        if (theTempNormals.size() > 0) {
            myNormals = new float[theTempNormals.size()];
            for (int i = 0; i < theTempNormals.size(); i++) {
                myNormals[i] = ((Float) (theTempNormals.get(i))).floatValue();
            }
            int[] myNormalsIndices = new int[theTempNormalIndices.size()];

            for (int i = 0; i < theTempNormalIndices.size(); i++) {
                myNormalsIndices[i] = (int) ((Integer) (theTempNormalIndices.elementAt(i))).intValue() - 1 - theIndexOffset;
            }
            myNormals = rearrangeVertices(myNormals, myNormalsIndices, 3, new PVector(1, 1, 1), new PVector(0, 0, 0));
        } else {
            myNormals = new float[theVertices.length];
            if (PRIMITIVE == PGraphics.TRIANGLES) {
                createNormalsTRIANGLE(theVertices, myNormals);
            } else if (PRIMITIVE == PGraphics.QUADS) {
                createNormalsQUADS(theVertices, myNormals);
            } else {
                System.out.println(
                        "### WARNING @ ModelLoaderOBJ / normal autogenerator for this primitive isn t implemented yet");
            }
        }
        return myNormals;
    }

    private static float[] rearrangeVertices(float[] theVertices,
                                             int[] theIndices,
                                             int theNumberOfVertexComponents,
                                             PVector theScale,
                                             PVector thePosition) {
        float[] myRearrangedVertices = new float[theIndices.length * theNumberOfVertexComponents];
        int myVertexIndex = -1;
        for (int i = 0; i < theIndices.length; i++) {
            int myIndex = theIndices[i] * theNumberOfVertexComponents;
            if (theNumberOfVertexComponents == 3) {
                myRearrangedVertices[++myVertexIndex] = theVertices[myIndex] * theScale.x + thePosition.x;
                myRearrangedVertices[++myVertexIndex] = theVertices[myIndex + 1] * theScale.y + thePosition.y;
                myRearrangedVertices[++myVertexIndex] = theVertices[myIndex + 2] * theScale.z + thePosition.z;
            } else if (theNumberOfVertexComponents == 2) {
                myRearrangedVertices[++myVertexIndex] = theVertices[myIndex] * theScale.x + thePosition.x;
                myRearrangedVertices[++myVertexIndex] = theVertices[myIndex + 1] * theScale.y + thePosition.y;
            } else if (theNumberOfVertexComponents == 4) {
                myRearrangedVertices[++myVertexIndex] = theVertices[myIndex] * theScale.x + thePosition.x;
                myRearrangedVertices[++myVertexIndex] = theVertices[myIndex + 1] * theScale.y + thePosition.y;
                myRearrangedVertices[++myVertexIndex] = theVertices[myIndex + 2] * theScale.z + thePosition.z;
                myRearrangedVertices[++myVertexIndex] = theVertices[myIndex + 3] * 1 + 0;
            }
        }
        return myRearrangedVertices;
    }

    private static void createNormalsQUADS(float[] theVertices, float[] theNormals) {
        System.out.println("### WARNING @ ModelLoaderOBJ / normal autogenerator for QUADS isn t implemented yet");
    }

    public static ModelData[] getModelDataGroups(String[] pLines) {
        int myNumberOfObjects = 0;
        Vector<Float> myTempVertices = new Vector<Float>();
        Vector<Float> myTempTexCoords = new Vector<Float>();
        Vector<Float> myTempNormals = new Vector<Float>();
        Vector<Integer> myTempVertexIndices = new Vector<Integer>();
        Vector<Integer> myTempTexCoordsIndices = new Vector<Integer>();
        Vector<Integer> myTempNormalIndices = new Vector<Integer>();
        Vector<Integer> myGroupChangeIndices = new Vector<Integer>();
        Vector<String> myNames = new Vector<String>();
        Vector<ModelData> myModelDatas = new Vector<ModelData>();

        float[] myVertices;
        float[] myTexCoordinates;
        float[] myNormals;
        float[] myUnsortedVertices;
        int[] myFaces;
        int myIndexOffset = 0;
        int myTexIndexOffset = 0;
        int myNormalIndexOffset = 0;

        for (String myLine : pLines) {
            String myLineElements[] = myLine.split("\\s+");
            if (myLineElements.length > 0) {
                    /* get groups */
                if (myLineElements[0].equals("g") || myLineElements[0].equals("o")) {
                    if (VERBOSE) {
                        System.out.println("### INFO @ ModelLoaderOBJ.parseFile() / start loading group: " + myLine);
                    }

                    if (myNumberOfObjects > 0) {
                            /* convert and rearrange vertices depending on indices described in 'f' */
                        myUnsortedVertices = new float[myTempVertices.size()];
                        myFaces = new int[myTempVertexIndices.size()];
                        myVertices = distributeVertices(myTempVertices,
                                                        myTempVertexIndices,
                                                        myUnsortedVertices,
                                                        myFaces,
                                                        myIndexOffset);

                            /* convert and rearrange texcoordinates depending on indices described in 'f' */
                        myTexCoordinates = distributeTexCoordinates(myTempTexCoords,
                                                                    myTempTexCoordsIndices,
                                                                    myTexIndexOffset);

                            /* convert and rearrange vertex_normals depending on indices described in 'f'
                             * if there are no vertex_normals specified in the file then we
                             * create vertex_normals on our own.
                             */
                        if (myTempNormals.size() > 0) {
                            myNormals = distributeNormals(myTempNormals,
                                                          myTempNormalIndices,
                                                          myNormalIndexOffset,
                                                          myVertices);
                        } else {
                            myNormals = new float[myVertices.length];
                            if (PRIMITIVE == PGraphics.TRIANGLES) {
                                createNormalsTRIANGLE(myVertices, myNormals);
                            } else if (PRIMITIVE == PGraphics.QUADS) {
                                createNormalsQUADS(myVertices, myNormals);
                            } else {
                                System.out.println(
                                        "### WARNING @ ModelLoaderOBJ / normal autogenerator for this primitive isn t implemented yet");
                            }
                        }

                        float[] myVertexColors = null; // the obj format doesn t store vertex colors :(
                        ModelData myModelData = new ModelData(myVertices,
                                                              myTexCoordinates,
                                                              myNormals,
                                                              myVertexColors,
                                                              myFaces,
                                                              PRIMITIVE,
                                                              NUMBER_OF_VERTEX_COMPONENTS,
                                                              1,
                                                              myNames.get(0));
                        myModelDatas.add(myModelData);

                            /* print info */
                        if (VERBOSE) {
                            System.out.println(myModelData);
                        }

                            /* reset collections */
                        myIndexOffset += myTempVertices.size() / NUMBER_OF_VERTEX_COMPONENTS;
                        myTexIndexOffset += myTempTexCoords.size() / 2;
                        myNormalIndexOffset += myTempNormals.size() / 3;
                        myTempVertices = new Vector<Float>();
                        myTempTexCoords = new Vector<Float>();
                        myTempNormals = new Vector<Float>();
                        myTempVertexIndices = new Vector<Integer>();
                        myTempTexCoordsIndices = new Vector<Integer>();
                        myTempNormalIndices = new Vector<Integer>();
                        myNames = new Vector<String>();
                    }

                    myNumberOfObjects++;

                    if (myLineElements.length == 1) {
                        myNames.add("(default)");
                    } else if (myLineElements.length == 2) {
                        myNames.add(myLineElements[1]);
                    } else if (myLineElements.length > 2) {
                        StringBuilder myNameSegments = new StringBuilder();
                        myNameSegments.append(myLineElements[1]);
                        for (int i = 2; i < myLineElements.length; i++) {
                            myNameSegments.append("/");
                            myNameSegments.append(myLineElements[i]);
                        }
                        myNames.add(myNameSegments.toString());
                    }
                    myGroupChangeIndices.add(myTempVertices.size());
                }

                    /* get vertices */
                if (myLineElements[0].equals("v")) {
                    myTempVertices.add(Float.valueOf(myLineElements[1]));
                    myTempVertices.add(Float.valueOf(myLineElements[2]));
                    myTempVertices.add(Float.valueOf(myLineElements[3]));
                }

                    /* get texturecoordinates */
                if (myLineElements[0].equals("vt")) {
                    myTempTexCoords.add(Float.valueOf(myLineElements[1]));
                    myTempTexCoords.add(Float.valueOf(myLineElements[2]));
                }

                    /* get vertex_normals */
                if (myLineElements[0].equals("vn")) {
                    myTempNormals.add(Float.valueOf(myLineElements[1]));
                    myTempNormals.add(Float.valueOf(myLineElements[2]));
                    myTempNormals.add(Float.valueOf(myLineElements[3]));
                }

                    /* get indices for vertices and texture coordinates */
                if (myLineElements[0].equals("f")) {
                    for (int i = 1; i < myLineElements.length; i++) {
                        String myFaceElement = myLineElements[i];
                        String[] myFaceElements = myFaceElement.split("/");
                        if (myFaceElements.length == 1) {
                            myTempVertexIndices.add(Integer.valueOf(myFaceElements[0]));
                        } else if (myFaceElements.length == 2) {
                            myTempVertexIndices.add(Integer.valueOf(myFaceElements[0]));
                            myTempTexCoordsIndices.add(Integer.valueOf(myFaceElements[1]));
                        } else if (myFaceElements.length == 3) {
                            myTempVertexIndices.add(Integer.valueOf(myFaceElements[0]));
                            myTempTexCoordsIndices.add(Integer.valueOf(myFaceElements[1]));
                            myTempNormalIndices.add(Integer.valueOf(myFaceElements[2]));
                        }
                    }
                }
            }
        }

        /* convert and rearrange vertices depending on indices described in 'f' */
        myUnsortedVertices = new float[myTempVertices.size()];
        myFaces = new int[myTempVertexIndices.size()];
        myVertices = distributeVertices(myTempVertices,
                                        myTempVertexIndices,
                                        myUnsortedVertices,
                                        myFaces,
                                        myIndexOffset);

        /* convert and rearrange texcoordinates depending on indices described in 'f' */
        myTexCoordinates = distributeTexCoordinates(myTempTexCoords, myTempTexCoordsIndices, myTexIndexOffset);

        /* convert and rearrange vertex_normals depending on indices described in 'f'
         * if there are no vertex_normals specified in the file then we
         * create vertex_normals on our own.
         */
        if (myTempNormals.size() > 0) {
            myNormals = distributeNormals(myTempNormals, myTempNormalIndices, myNormalIndexOffset, myVertices);
        } else {
            myNormals = new float[myVertices.length];
            if (PRIMITIVE == PGraphics.TRIANGLES) {
                createNormalsTRIANGLE(myVertices, myNormals);
            } else if (PRIMITIVE == PGraphics.QUADS) {
                createNormalsQUADS(myVertices, myNormals);
            } else {
                System.out.println(
                        "### WARNING @ ModelLoaderOBJ / normal autogenerator for this primitive isn t implemented yet");
            }
        }

        ModelData myModelData = new ModelData(myVertices,
                                              myTexCoordinates,
                                              myNormals,
                                              null,
                                              myFaces,
                                              PRIMITIVE,
                                              NUMBER_OF_VERTEX_COMPONENTS,
                                              1,
                                              myNames.get(0));
        myModelDatas.add(myModelData);

        /* print info */
        if (VERBOSE) {
            System.out.println(myModelData);
        }

        ModelData[] myDatas = new ModelData[myModelDatas.size()];
        for (int i = 0; i < myModelDatas.size(); i++) {
            myDatas[i] = myModelDatas.get(i);
        }
        return myDatas;
    }

    public static ModelData parseModelData(InputStream theModelFile) {
        InputStreamReader myInputStreamReader = new InputStreamReader(theModelFile);
        BufferedReader myBufferedReader = new BufferedReader(myInputStreamReader);
        ArrayList<String> mLines = new ArrayList<>();
        try {
            String myLine;
            while ((myLine = myBufferedReader.readLine()) != null) {
                mLines.add(myLine);
            }
        } catch (IOException ex) {
            System.err.println("### ERROR @ ModelLoaderOBJ / problem parsing file: " + ex);
        }

        String[] mLinesArray = new String[mLines.size()];
        mLines.toArray(mLinesArray);
        return parseModelData(mLinesArray);
    }

    public static String[] convertMeshToOBJ(Mesh pMesh) {
        if (pMesh.getVertexComponentsCount() != 3) {
            System.out.println("+++ WARNING can only parse 3D meshes.");
        }

        return convertVertexDataToOBJ(pMesh.vertices());
    }

    public static String[] convertVertexDataToOBJ(float[] pVertexData) {
        final String LINE_TERMINATOR = ""; // @todo apparently processing automatically adds an empty line at the end of each string
        final String GROUP_NAME = "g object" + PApplet.nf(GROUP_NAME_INDEX_COUNTER++,
                                                          5) + LINE_TERMINATOR; // @todo could be set external

        ArrayList<String> s = new ArrayList<>();
        ArrayList<String> mVertices = new ArrayList<>();
        ArrayList<String> mFaces = new ArrayList<>();

        for (int i = 0; i < pVertexData.length; i += 3) { // @todo assumes three components
            StringBuilder mLine = new StringBuilder();
            mLine.append("v ");
            mLine.append(pVertexData[i + 0]);
            mLine.append(" ");
            mLine.append(pVertexData[i + 1]);
            mLine.append(" ");
            mLine.append(pVertexData[i + 2]);
            mLine.append(LINE_TERMINATOR);
            mVertices.add(mLine.toString());

            final int FACE_OFFSET = 1;
            StringBuilder mFace = new StringBuilder();
            mFace.append("f ");
            mFace.append((i + 0 + FACE_OFFSET));
            mFace.append(" ");
            mFace.append((i + 1 + FACE_OFFSET));
            mFace.append(" ");
            mFace.append((i + 2 + FACE_OFFSET));
            mFace.append(LINE_TERMINATOR);
            mFaces.add(mFace.toString());
        }

        s.add(GROUP_NAME);
        s.add(LINE_TERMINATOR);
        s.addAll(mVertices);
        s.add(LINE_TERMINATOR);
        s.addAll(mFaces);

        String[] mStringArray = new String[s.size()];
        return s.toArray(mStringArray);
    }

    public static ModelData parseModelData(String pString) {
        return ModelLoaderOBJ.parseModelData(PApplet.split(pString, "\n"));
    }

    public static ModelData parseModelData(String[] pLines) {
        int myNumberOfObjects = 0;
        Vector<Float> myTempVertices = new Vector<Float>();
        Vector<Float> myTempTexCoords = new Vector<Float>();
        Vector<Float> myTempNormals = new Vector<Float>();
        Vector<Integer> myTempVertexIndices = new Vector<Integer>();
        Vector<Integer> myTempTexCoordsIndices = new Vector<Integer>();
        Vector<Integer> myTempNormalIndices = new Vector<Integer>();
        Vector<Integer> myGroupChangeIndices = new Vector<Integer>();
        Vector<String> myNames = new Vector<String>();

        for (String myLine : pLines) {
            String myLineElements[] = myLine.split("\\s+");
            if (myLineElements.length > 0) {
                    /* get groups */
                if (myLineElements[0].equals("g") || myLineElements[0].equals("o")) {
                    if (VERBOSE) {
                        System.out.println("### INFO @ ModelLoaderOBJ.parseFile() / start loading group: " + myLine);
                    }
                    myNumberOfObjects++;
                    myNames.add(myLineElements[1]);
                    myGroupChangeIndices.add(myTempVertices.size());
                }

                    /* get vertices */
                if (myLineElements[0].equals("v")) {
                    myTempVertices.add(Float.valueOf(myLineElements[1]));
                    myTempVertices.add(Float.valueOf(myLineElements[2]));
                    myTempVertices.add(Float.valueOf(myLineElements[3]));
                }

                    /* get texturecoordinates */
                if (myLineElements[0].equals("vt")) {
                    myTempTexCoords.add(Float.valueOf(myLineElements[1]));
                    myTempTexCoords.add(Float.valueOf(myLineElements[2]));
                }

                    /* get vertex_normals */
                if (myLineElements[0].equals("vn")) {
                    myTempNormals.add(Float.valueOf(myLineElements[1]));
                    myTempNormals.add(Float.valueOf(myLineElements[2]));
                    myTempNormals.add(Float.valueOf(myLineElements[3]));
                }

                    /* get indices for vertices and texture coordinates */
                if (myLineElements[0].equals("f")) {
                    for (int i = 1; i < myLineElements.length; i++) {
                        String myFaceElement = myLineElements[i];
                        String[] myFaceElements = myFaceElement.split("/");
                        if (myFaceElements.length == 1) {
                            try {
                                int v;
                                v = Math.abs(Integer.valueOf(myFaceElements[0]));
                                myTempVertexIndices.add(v);
                            } catch (NumberFormatException e) {
                            }
                        } else if (myFaceElements.length == 2) {
                            try {
                                int v;
                                v = Math.abs(Integer.valueOf(myFaceElements[0]));
                                myTempVertexIndices.add(v);
                            } catch (NumberFormatException e) {
                            }
                            try {
                                int t;
                                t = Math.abs(Integer.valueOf(myFaceElements[1]));
                                myTempTexCoordsIndices.add(t);
                            } catch (NumberFormatException e) {
                            }
                        } else if (myFaceElements.length == 3) {
                            try {
                                int v;
                                v = Math.abs(Integer.valueOf(myFaceElements[0]));
                                myTempVertexIndices.add(v);
                            } catch (NumberFormatException e) {
                            }
                            try {
                                int t;
                                t = Math.abs(Integer.valueOf(myFaceElements[1]));
                                myTempTexCoordsIndices.add(t);
                            } catch (NumberFormatException e) {
                            }
                            try {
                                int n;
                                n = Math.abs(Integer.valueOf(myFaceElements[2]));
                                myTempNormalIndices.add(n);
                            } catch (NumberFormatException e) {
                            }
                        }
                    }
                }
            }
        }

        /* convert and rearrange vertices depending on indices described in 'f' */
        float[] myVertices = new float[myTempVertices.size()];
        float[] myUnsortedVertices = new float[myTempVertices.size()];
        for (int i = 0; i < myTempVertices.size(); i++) {
            myVertices[i] = ((Float) (myTempVertices.get(i))).floatValue();
            myUnsortedVertices[i] = ((Float) (myTempVertices.get(i))).floatValue();
        }
        int[] myFaces = new int[myTempVertexIndices.size()];
        for (int i = 0; i < myTempVertexIndices.size(); i++) {
            myFaces[i] = ((Integer) (myTempVertexIndices.elementAt(i))).intValue() - 1;
        }
        myVertices = rearrangeVertices(myVertices, myFaces, 3, new PVector(1, 1, 1), new PVector(0, 0, 0));

        /* convert and rearrange texture coordinates depending on indices described in 'f' */
        float[] myTexCoordinates = new float[myTempTexCoords.size()];
        for (int i = 0; i < myTempTexCoords.size(); i++) {
            myTexCoordinates[i] = ((Float) (myTempTexCoords.get(i))).floatValue();
        }
        int[] myTexCoordsIndices = new int[myTempTexCoordsIndices.size()];
        for (int i = 0; i < myTempTexCoordsIndices.size(); i++) {
            myTexCoordsIndices[i] = (int) ((Integer) (myTempTexCoordsIndices.elementAt(i))).intValue() - 1;
        }
        myTexCoordinates = rearrangeVertices(myTexCoordinates,
                                             myTexCoordsIndices,
                                             2,
                                             new PVector(1, 1, 1),
                                             new PVector(0, 0, 0));

        /* convert and rearrange vertex_normals depending on indices described in 'f'
         * if there are no vertex_normals specified in the file then we
         * create vertex_normals on our own.
         */
        float[] myNormals = null;
        if (myTempNormals.size() > 0) {
            myNormals = new float[myTempNormals.size()];
            for (int i = 0; i < myTempNormals.size(); i++) {
                myNormals[i] = ((Float) (myTempNormals.get(i))).floatValue();
            }
            int[] myNormalsIndices = new int[myTempNormalIndices.size()];
            for (int i = 0; i < myTempNormalIndices.size(); i++) {
                myNormalsIndices[i] = (int) ((Integer) (myTempNormalIndices.elementAt(i))).intValue() - 1;
            }
            myNormals = rearrangeVertices(myNormals, myNormalsIndices, 3, new PVector(1, 1, 1), new PVector(0, 0, 0));
        } else {
            myNormals = new float[myVertices.length];
            if (PRIMITIVE == PGraphics.TRIANGLES) {
                createNormalsTRIANGLE(myVertices, myNormals);
            } else if (PRIMITIVE == PGraphics.QUADS) {
                createNormalsQUADS(myVertices, myNormals);
            } else {
                System.out.println(
                        "### WARNING @ ModelLoaderOBJ / normal autogenerator for this primitive isn t implemented yet");
            }
        }

        /* create modeldata */
        if (myNumberOfObjects == 0) {
            myNumberOfObjects = 1;
        }

        float[] myVertexColors = null; // the obj format doesn t store vertex colors :(
        ModelData myModelData = new ModelData(myVertices,
                                              myTexCoordinates,
                                              myNormals,
                                              myVertexColors,
                                              myFaces,
                                              PRIMITIVE,
                                              NUMBER_OF_VERTEX_COMPONENTS,
                                              myNumberOfObjects,
                                              myNames.isEmpty() ? "" : myNames.get(0));

        /* print info */
        if (VERBOSE) {
            System.out.println(myModelData);
        }
        return myModelData;
    }

    public static void createNormalsTRIANGLE(float[] theVertices, float[] theNormals) {
        int myNumberOfPoints = 3;
        for (int i = 0; i < theVertices.length; i += (myNumberOfPoints * NUMBER_OF_VERTEX_COMPONENTS)) {
            PVector a = new PVector(theVertices[i], theVertices[i + 1], theVertices[i + 2]);
            PVector b = new PVector(theVertices[i + 3], theVertices[i + 4], theVertices[i + 5]);
            PVector c = new PVector(theVertices[i + 6], theVertices[i + 7], theVertices[i + 8]);
            PVector myNormal = new PVector();
            if (GET_NORMALS_DIRECTION == GET_NORMALS_CCW) {
                calculateNormal(a, b, c, myNormal);
            } else if (GET_NORMALS_DIRECTION == GET_NORMALS_CW) {
                calculateNormal(b, a, c, myNormal);
            }

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

    public static void calculateNormal(final PVector pointA,
                                       final PVector pointB,
                                       final PVector pointC,
                                       final PVector theResultNormal) {
        final PVector mBA = PVector.sub(pointB, pointA);
        final PVector mBC = PVector.sub(pointC, pointB);

        PVector.cross(mBA, mBC, theResultNormal);
        theResultNormal.normalize();
    }

    public static PVector createNormal(final PVector pointA, final PVector pointB, final PVector pointC) {
        final PVector myResultNormal = new PVector();
        calculateNormal(pointA, pointB, pointC, myResultNormal);
        return myResultNormal;
    }

    public static PVector createNormal(final PVector theVectorAB, final PVector theVectorBC) {
        final PVector myResultNormal = new PVector();
        calculateNormal(theVectorAB, theVectorBC, myResultNormal);
        return myResultNormal;
    }

    public static void calculateNormal(final PVector theVectorAB,
                                       final PVector theVectorBC,
                                       final PVector theResultNormal) {
        PVector.cross(theVectorAB, theVectorBC, theResultNormal);
        theResultNormal.normalize();
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
}
