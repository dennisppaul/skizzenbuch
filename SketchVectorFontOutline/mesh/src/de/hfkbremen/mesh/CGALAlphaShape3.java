package de.hfkbremen.mesh;

import processing.core.PVector;

/**
 * http://doc.cgal.org/latest/Alpha_shapes_3/
 * <p>
 * http://www.loria.fr/~pougetma/software/alpha_shape/alpha_shape.html
 */

public class CGALAlphaShape3 {

    static {
        System.out.print("### loading native lib `" + CGALAlphaShape3.class.getName() + "` ...");
        System.loadLibrary(CGALAlphaShape3.class.getSimpleName());
        System.out.println(" ok");
    }

    private long ptr2cgalAlphaShape;

    /**
     * print version of library.
     *
     * @return
     */
    native int version();

    /**
     * Initialize the alpha_shape from the array of points coordinates
     * (coord), return a pointer to the c++ alpha_shape object for
     * subsequent native method calls.
     *
     * @param pts_coord
     * @return
     */
    private native long init_alpha_shape(float[] pts_coord);

    /**
     * For a given value of alpha and a given class_type for the facets,
     * sets the alpha value of the alpha_shape to alpha. Returns the array
     * of facet indices from the alpha_shape.
     *
     * @param classification_type
     * @param alpha
     * @param ptr
     * @return
     */
    private native int[] get_alpha_shape_facets(String classification_type, float alpha, long ptr);

    /**
     * For a given number of create components and a given class_type for
     * the facets, sets the alpha value of the alpha_shape A such that A
     * satisfies the following two properties: (1) all data points are
     * either on the boundary or in the interior of the regularized
     * version of A; (2) the number of create component of A is equal to or
     * smaller than nb_components. Returns the array of facet indices from
     * the alpha_shape.
     *
     * @param classification_type
     * @param nb_sc
     * @param ptr
     * @return
     */
    private native int[] get_alpha_shape_facets_optimal(String classification_type, int nb_sc, long ptr);

    /**
     * gives the alpha value of the current alpha_shape
     *
     * @param ptr
     * @return
     */
    private native float get_alpha(long ptr);

    /**
     * Returns the number of create components of the current alpha_shape,
     * that is, the number of components of its regularized version.
     *
     * @param ptr
     * @return
     */
    private native int number_of_solid_components(long ptr);

    /**
     * @param classification_type
     * @param alpha
     * @param ptr
     * @return
     */
    private native float[] get_alpha_shape_mesh(String classification_type, float alpha, long ptr);

    /**
     * @param nb_sc
     * @param ptr
     * @return
     */
    private native float get_optimal_alpha(int nb_sc, long ptr);


    /* --- */

    public void compute_cgal_alpha_shape(float[] pts_coord) {
        ptr2cgalAlphaShape = init_alpha_shape(pts_coord);
    }

    public void compute_cgal_alpha_shape(PVector[] vertices) {
        float[] pts_coord = new float[vertices.length * 3];
        for (int i = 0; i < vertices.length; i++) {
            pts_coord[3 * i + 0] = vertices[i].x;
            pts_coord[3 * i + 1] = vertices[i].y;
            pts_coord[3 * i + 2] = vertices[i].z;
        }

        ptr2cgalAlphaShape = init_alpha_shape(pts_coord);
    }

    public Mesh mesh(float m_alpha) {
        return new Mesh(get_alpha_shape_mesh("REGULAR", m_alpha, ptr2cgalAlphaShape));
    }

    public float[] compute_regular_mesh(float m_alpha) {
        return get_alpha_shape_mesh("REGULAR", m_alpha, ptr2cgalAlphaShape);
    }

    public float[] compute_singular_mesh(float m_alpha) {
        return get_alpha_shape_mesh("SINGULAR", m_alpha, ptr2cgalAlphaShape);
    }

    public float[] compute_regular_mesh_optimal(int number_of_solid_components) {
        return get_alpha_shape_mesh("REGULAR",
                                    get_optimal_alpha(number_of_solid_components, ptr2cgalAlphaShape),
                                    ptr2cgalAlphaShape);
    }

    public float[] compute_singular_mesh_optimal(int number_of_solid_components) {
        return get_alpha_shape_mesh("SINGULAR",
                                    get_optimal_alpha(number_of_solid_components, ptr2cgalAlphaShape),
                                    ptr2cgalAlphaShape);
    }

    public float alpha() {
        return get_alpha(ptr2cgalAlphaShape);
    }

    public int number_of_solid_components() {
        return number_of_solid_components(ptr2cgalAlphaShape);
    }

    public float get_optimal_alpha(int nb_sc) {
        return get_optimal_alpha(nb_sc, ptr2cgalAlphaShape);
    }
}
