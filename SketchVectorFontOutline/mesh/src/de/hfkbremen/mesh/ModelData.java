package de.hfkbremen.mesh;

import processing.core.PVector;

import java.io.Serializable;
import java.util.ArrayList;

public class ModelData implements Serializable {

    private static final int DEFAULT_VERTEX_COLOR_COMPONENT_COUNT = 4;
    private static final int DEFAULT_TEXTURE_COORDINATES_COMPONENT_COUNT = 2;
    public final float[] vertices;
    public final float[] texture_coordinates;
    public final float[] vertex_normals;
    public final float[] vertex_colors;
    public final int[] faces;
    public final int primitive;
    public final int object_count;
    public final int vertex_component_count;
    public final String name;

    public ModelData(float[] pVertices,
                     float[] pTextureCoordinates,
                     float[] pNormals,
                     float[] pVertexColors,
                     int[] pFaces,
                     int pPrimitive,
                     int pVertexComponentCount,
                     int pNumberOfObjects,
                     String pName) {
        vertices = pVertices;
        texture_coordinates = pTextureCoordinates;
        vertex_normals = pNormals;
        vertex_colors = pVertexColors;
        primitive = pPrimitive;
        faces = pFaces;
        object_count = pNumberOfObjects;
        vertex_component_count = pVertexComponentCount;
        name = pName;
    }

    public float[] vertices() {
        return vertices;
    }

    public float[] colors() {
        return vertex_colors;
    }

    public float[] normals() {
        return vertex_normals;
    }

    public float[] texcoords() {
        return texture_coordinates;
    }

    public Mesh mesh() {
        return new Mesh(vertices,
                        vertex_component_count,
                        vertex_colors,
                        DEFAULT_VERTEX_COLOR_COMPONENT_COUNT,
                        texture_coordinates,
                        DEFAULT_TEXTURE_COORDINATES_COMPONENT_COUNT,
                        vertex_normals,
                        primitive);
    }

    /*
     * this method calculates the vertex_normals in a way that vertices that share the
     * same position will have the same normal.
     *
     * the algorithm is very inefficient, so that really big models will take
     * minutes to be calculated. ideas to increase the speed are very welcome!
     */
    public void averageNormals() {
        System.out.println(
                "### INFO @ ModelData.averageNormals() / this algorithm is not very efficient yet. Takes quite long!");
        for (int i = 0; i < vertices.length; i += vertex_component_count) {
            PVector myVertex = new PVector(vertices[i + 0], vertices[i + 1], vertices[i + 2]);
            ArrayList<PVector> myNormals = new ArrayList<>();

            ArrayList<Integer> myNormalIndices = new ArrayList<>();
            for (int j = 0; j < vertices.length; j += vertex_component_count) {
                PVector mySecondVertex = new PVector(vertices[j + 0], vertices[j + 1], vertices[j + 2]);
                PVector mySecondNormal = new PVector(vertex_normals[j + 0],
                                                     vertex_normals[j + 1],
                                                     vertex_normals[j + 2]);
                if (myVertex.equals(mySecondVertex)) {
                    myNormals.add(mySecondNormal);
                    myNormalIndices.add(j);
                }
            }

            /* get average normal */
            PVector myAverageNormal = new PVector();
            for (PVector myNormal : myNormals) {
                myAverageNormal.add(myNormal);
            }
            myAverageNormal.normalize();

            for (Integer myNormalIndice : myNormalIndices) {
                vertex_normals[myNormalIndice + 0] = myAverageNormal.x;
                vertex_normals[myNormalIndice + 1] = myAverageNormal.y;
                vertex_normals[myNormalIndice + 2] = myAverageNormal.z;
            }
        }
    }

    public void translate(final PVector theTranslation) {
        final float[] myTranslation = theTranslation.array();
        for (int i = 0; i < vertices.length; i += vertex_component_count) {
            for (int j = 0; j < vertex_component_count; j++) {
                vertices[i + j] += myTranslation[j];
            }
        }
    }

    public void scale(final PVector theScale) {
        final float[] myScale = theScale.array();
        for (int i = 0; i < vertices.length; i += vertex_component_count) {
            for (int j = 0; j < vertex_component_count; j++) {
                vertices[i + j] *= myScale[j];
            }
        }
    }

    public String toString() {
        return "ModelData:" + "\n" + "----------" + "\n" + "objects:        " + object_count + "\n" + "vertices:       " + vertices.length + "\n" + "vertex_normals:        " + vertex_normals.length + "\n" + "texture_coordinates: " + texture_coordinates.length + "\n";
    }
}
