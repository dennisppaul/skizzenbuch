package de.hfkbremen.mesh;

public class CGALBooleanOperations3 {

    public static int INTERSECTION = 0;
    public static int JOIN = 1;
    public static int DIFFERENCE = 2;

    static {
        System.out.print("### loading native lib `" + CGALBooleanOperations3.class.getName() + "` ...");
        System.loadLibrary(CGALBooleanOperations3.class.getSimpleName());
        System.out.println(" ok");
    }

    public native float[] boolean_operation(int classification_type, float[] pts_A_coord, float[] pts_B_coord);

    public Mesh boolean_operation_mesh(int classification_type, float[] pts_A_coord, float[] pts_B_coord) {
        return new Mesh(boolean_operation(classification_type, pts_A_coord, pts_B_coord));
    }
}
