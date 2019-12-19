/*
 * Grid
 */

package util;


import java.util.Vector;
import mathematik.Vector3i;
import mathematik.Vector3f;


/** <b>EXPLANATION</b><br/>
 * this class offers a way of rasterizing object positions into grid of boxes.
 * this can be useful for optimized distance measuring since an object can check in its 'own' box
 * if there are other objects present and then only measure distance to these objects instead of
 * having to look at the whole 'world'. it is also useful for deviding a space into different regions
 * which than can be located very easily by moving objects.<br/>
 * This class also offers a way of dealing with view frustum distortion(?). looking at the bottom of a box,
 * the bottom always seem to be smaller than the top due to perpective distortion. knowing the distance
 * of the camera to the world box this distortion can be taken into account, to distort the worldbox as well.<br/>
 * <br/>NOTE that this a very specific thing and not intendet for general use, since the camera always looks down
 * the negative y axis. the top of the box is defined by a plane parallel to the xz plane.
 * <br/>
 * <br/>
 * <b>USAGE</b><br/>
 * the grid class can be used in two different ways. the first way is to use it as a toolkit for converting positions
 * to grid values. the second way is to use the grid class a map of the world box. objects can store their current postion
 * in a 3 dimensional array as well as accessing this array to 'look around' in the world box<br/>
 * <br/>
 * if there is no need to store the position in an array just set it to null. some methods won t work then of course.
 * to write an vehicleObject to the array call <code>writeVehicleObjectToArray</code> if the vehicleObject isn t in that cube already
 * it will then be written to the array. when the vehicleObject is destroyed take care to destroy the reference in array as well
 * by calling <code>removeVehicleObjectFromArray</code>.
 * or calling <code>removeVehicleObjectFromBox</code>.
 * <br/>
 * <br/>
 * <br/>
 * <b>WORDDEFINITIONS</b><br/>
 * <i>grid</i> is an integer with positiv or negative value representing an approximated position in the grid<br/>
 * <i>array</i> is a transformed 'grid' that represents a position in an array<br/>
 * <i>position</i> is an actual spatial position<br/>
 * <i>frustum</i> is a transformed position value that corrects perspectiv distortion.
 * from camera view all positons with the same x and z value appear to be on top of each other<br/>
 */

public class Grid {

    public Vector3f worldBox = new Vector3f();

    // grid

    public Vector3f translateOrigin = new Vector3f();

    private float gridCellSize;

    private int worldBoxArraySizeX;

    private int worldBoxArraySizeY;

    private int worldBoxArraySizeZ;

    private Vector[][][] worldBoxArray;

    private Vector3i myOldPosition;

    private boolean storedInArray;

    // frustum

    /////////////////////////////////////////////////////////////////////////////
    //
    // common stuff
    //
    /////////////////////////////////////////////////////////////////////////////

    /** setup grid object
     * @param worldBox dimensions
     * @param translateOrigin translate the origin of the world box.
     * if all values are zero the origin is in the center of the box
     * @param gridCellSize specifies the number of boxes for each dimension
     * <i>for future version this should be independent for all dimensions</i>
     * @param cameraHeight describes the hight of the camera for frustum correction
     * @param pWorldBoxArray pointer to world box array to store object positions
     */
    public Grid(Vector3f worldBox,
                Vector3f translateOrigin,
                float gridCellSize,
                Vector[][][] pWorldBoxArray) {
        this.worldBox.set(worldBox);
        this.translateOrigin.set(translateOrigin);
        this.gridCellSize = gridCellSize;
        setPrivateVariables();
        if (pWorldBoxArray != null) {
            setWorldArray(pWorldBoxArray);
        }
    }


    /**
     *
     * @param pWorldBoxArray
     */
    private void setWorldArray(Vector[][][] pWorldBoxArray) {
        // setup the object to store old object position
        myOldPosition = new Vector3i();
        storedInArray = false;
        // set pointer to array
        worldBoxArray = pWorldBoxArray;
        // check if array is compatible with pointer
        if (worldBoxArray.length != worldBoxArraySizeX
            || worldBoxArray[0].length != worldBoxArraySizeY
            || worldBoxArray[0][0].length != worldBoxArraySizeZ) {
            System.out.println("### ERROR problem with dimensions of assigned array");
            System.out.println("###       required " + worldBoxArraySizeX + " " + worldBoxArraySizeY + " " +
                               worldBoxArraySizeZ);
            System.out.println("###       got " + worldBoxArray.length + " " + worldBoxArray[0].length + " " +
                               worldBoxArray[0][0].length);
        }
    }


    /** set private member variables
     */
    private void setPrivateVariables() {
        storedInArray = false;
        worldBoxArraySizeX = (int) (worldBox.x / gridCellSize);
        worldBoxArraySizeY = (int) (worldBox.y / gridCellSize);
        worldBoxArraySizeZ = (int) (worldBox.z / gridCellSize);
    }


    /** resets grid to some phoney default values i made up
     */
    public void reset() {
        // default worldBox 400.0 400.0 600.0
        // default translateOrigin 0.0 -300.0 0.0
        // default gridCellSize = 20.0;
        worldBox.set(400.0f, 400.0f, 600.0f);
        translateOrigin.set(0.0f, -300.0f, 0.0f);
        gridCellSize = gridCellSize;
        setPrivateVariables();
    }


    /** returns the required size of the world grid
     * @return the required size for a world array
     */
    public static int[] getRequiredArraySize(Vector3f worldBox, float gridCellSize) {
        return new int[] { (int) (worldBox.x / gridCellSize), (int) (worldBox.y / gridCellSize),
            (int) (worldBox.z / gridCellSize)};
    }


    /** creates and initalizes a grid of the required size
     *
     * @param worldBox size of the world the grid is supposed to cover
     * @param gridCellSize specifies the number of boxes for each dimension
     * @return pointer to the grid
     */
    public static Vector[][][] createGrid(Vector3f worldBox, float gridCellSize) {
        int[] arraySize = getRequiredArraySize(worldBox, gridCellSize);
        Vector[][][] myGrid = new Vector[arraySize[0]][arraySize[1]][arraySize[2]];
        initArray(myGrid);
        return myGrid;
    }


    /** initializes any worldarray
     *
     * @param worldBoxArray
     */
    public static void initArray(Vector[][][] worldBoxArray) {
        for (int x = 0; x < worldBoxArray.length; x++) {
            for (int y = 0; y < worldBoxArray[0].length; y++) {
                for (int z = 0; z < worldBoxArray[0][0].length; z++) {
                    worldBoxArray[x][y][z] = new Vector();
                }
            }
        }
    }


    /////////////////////////////////////////////////////////////////////////////
    //
    // Grid stuff
    //
    /////////////////////////////////////////////////////////////////////////////

    /** convert a grid value to an array value
     * @param g integer grid value converted to an array index
     * @return array index. not save use as array index could cause exception
     */
    int grid2Array(int g) {
        if (g >= 0) {
            // even value are postiv postions
            g *= 2;
        } else {
            // odd values are negativ positions
            g *= -2;
            g -= 1;
        }
        return (int) g;
    }


    /** convert an array value to a grid value
     */
    int array2Grid(int a) {
        if (Math.ceil( (double) a / 2) != (double) a / 2) {
            a += 1;
            a /= -2;
        } else {
            a /= 2;
        }
        return (int) a;
    }


    /** convert a grid value to a postion
     * @return note that the returned value is the bottom-left
     * (?depends from where you look:)) corner of the gridCell.
     */
    public float grid2Position(int g) {
        return (float) g * gridCellSize;
    }


    /** convert grid values to postion
     *
     * @param myGridPosition
     * @return
     */
    public Vector3f grid2Position(int[] myGridPosition) {
        return new Vector3f(grid2Position(myGridPosition[0]) + translateOrigin.x,
                            grid2Position(myGridPosition[1]) + translateOrigin.y,
                            grid2Position(myGridPosition[2]) + translateOrigin.z);
    }


    /** convert grid values to postion
     *
     * @param x
     * @param y
     * @param z
     * @return
     */
    public Vector3f grid2Position(int x, int y, int z) {
        return new Vector3f(grid2Position(x) + translateOrigin.x,
                            grid2Position(y) + translateOrigin.y,
                            grid2Position(z) + translateOrigin.z);
    }


    /** convert a postion to a grid value
     */
    public int position2Grid(float position) {
        return (int) Math.floor(position / gridCellSize);
    }


    /** convert a postion vector to an array of grid values
     */
    public int[] position2Grid(Vector3f position) {
        return new int[] {
            (int) Math.floor( (position.x - translateOrigin.x) / gridCellSize),
            (int) Math.floor( (position.y - translateOrigin.y) / gridCellSize),
            (int) Math.floor( (position.z - translateOrigin.z) / gridCellSize)
        };
    }


    /** convert a postion vector to an array of grid values
     */
    public int[] position2Grid(float x, float y, float z) {
        return new int[] {
            (int) Math.floor( (x - translateOrigin.x) / gridCellSize),
            (int) Math.floor( (y - translateOrigin.y) / gridCellSize),
            (int) Math.floor( (z - translateOrigin.z) / gridCellSize)
        };
    }


    /** convert a postion vector to an array of grid values
     * @return returns 'null' if the value is out of bound
     */
    public int[] position2GridSave(Vector3f position) {
        int x = (int) Math.floor( (position.x - translateOrigin.x) / gridCellSize);
        int y = (int) Math.floor( (position.y - translateOrigin.y) / gridCellSize);
        int z = (int) Math.floor( (position.z - translateOrigin.z) / gridCellSize);
        if (grid2Array(x) > worldBoxArraySizeX
            || grid2Array(y) > worldBoxArraySizeY
            || grid2Array(z) > worldBoxArraySizeZ) {
            return null;
        } else {
            return new int[] {x, y, z};
        }
    }


    /** convert a postion to an array value
     */
    private int postion2Array(float position) {
        return grid2Array(position2Grid(position));
    }


    /** convert a postion vector to an array value
     */
    public int[] position2Array(Vector3f v) {
        return new int[] {
            (int) (postion2Array(v.x - translateOrigin.x)),
            (int) (postion2Array(v.y - translateOrigin.y)),
            (int) (postion2Array(v.z - translateOrigin.z))
        };
    }


    /** convert an array value to a postion
     * @return see grid2Position
     */
    private float array2Postion(int a) {
        return grid2Position(array2Grid(a));
    }


    /** convert three array values to a postion
     * @return see grid2Position
     */
    public Vector3f array2Position(int x, int y, int z) {
        return new Vector3f(array2Postion(x) + translateOrigin.x,
                            array2Postion(y) + translateOrigin.y,
                            array2Postion(z) + translateOrigin.z);
    }


    /**
     * write to the array and manage the objects occurence in the array
     * @param v
     * @param vehicleObject
     * @return
     */
    public boolean writeVehicleObjectToArray(Vector3f v, Object vehicleObject) {
        return writeVehicleObjectToArray(v.x, v.y, v.z, vehicleObject);
    }


    /**
     * write to the array and manage the objects occurence in the array
     * @param x
     * @param y
     * @param z
     * @param vehicleObject
     * @return
     */
    public boolean writeVehicleObjectToArray(float x, float y, float z, Object vehicleObject) {
        int[] a = position2Array(new Vector3f(x, y, z));
        int xA = a[0];
        int yA = a[1];
        int zA = a[2];
        // is value out of bound
        boolean outOfBound = true;
        if (xA > worldBoxArraySizeX - 1) {
            xA = worldBoxArraySizeX - 1;
        } else if (yA > worldBoxArraySizeY - 1) {
            yA = worldBoxArraySizeY - 1;
        } else if (zA > worldBoxArraySizeZ - 1) {
            zA = worldBoxArraySizeZ - 1;
        } else if (xA < 0) {
            xA = 0;
        } else if (yA < 0) {
            yA = 0;
        } else if (zA < 0) {
            zA = 0;
        } else {
            outOfBound = false;
        }
        if (outOfBound) {
            // if we left the world box we need to be removed
            if (storedInArray && !removeVehicleObjectFromBox(vehicleObject)) {
                System.out.println("### WARNING couldn t remove VehicleObject from Array *oob");
            }
        } else {
            Vector myVector;
            // did we leave current cube
            if (myOldPosition.x != xA || myOldPosition.y != yA || myOldPosition.z != zA) {
                // remove object from old cube and check if it worked
                if (storedInArray && !removeVehicleObjectFromBox(vehicleObject)) {
                    System.out.println("### WARNING couldn t remove VehicleObject from Array");
                }
                // and write object to new cube
                myVector = worldBoxArray[xA][yA][zA];
                myVector.add(vehicleObject);
                // remember that we stored something in the array
                storedInArray = true;
                // store current position to check the leaving of a cube
                myOldPosition.set(xA, yA, zA);
            }
        }
        return outOfBound;
    }


    /** returns a pointer to the vector surround the specified position
     *
     * @param myPosition
     * @return
     */
    public Vector getBoxPointer(float x, float y, float z) {
        int[] a = position2Array(new Vector3f(x, y, z));
        int xA = a[0];
        int yA = a[1];
        int zA = a[2];
        // is value out of bound
        boolean outOfBound = true;
        if (xA > worldBoxArraySizeX - 1) {
            xA = worldBoxArraySizeX - 1;
        } else if (yA > worldBoxArraySizeY - 1) {
            yA = worldBoxArraySizeY - 1;
        } else if (zA > worldBoxArraySizeZ - 1) {
            zA = worldBoxArraySizeZ - 1;
        } else if (xA < 0) {
            xA = 0;
        } else if (yA < 0) {
            yA = 0;
        } else if (zA < 0) {
            zA = 0;
        } else {
            outOfBound = false;
        }
        if (outOfBound) {
            // if we left the world box we need to be removed
            System.out.println("### WARNING position not in world box");
            return null;
        } else {
            // get pointer
            return worldBoxArray[xA][yA][zA];
        }
    }


    /** returns a pointer to the vector surround the specified position
     *
     * @param myPosition
     * @return
     */
    public Vector getBoxPointer(Vector3f v) {
        return getBoxPointer(v.x, v.y, v.z);
    }


    /** removes the object from the array by look through the whole thing
     *
     * @return if false is returned the object could not be removed
     */
    public boolean removeVehicleObjectFromArray(Object vehicleObject) {
        // go through the whole array to delete object
        // VERY COSTLY!
        Vector myVector = worldBoxArray[myOldPosition.x][myOldPosition.y][myOldPosition.z];
        if (myVector.remove(vehicleObject)) {
            storedInArray = false;
            return true;
        } else {
            return false;
        }
    }


    /** removes the object from the array looking in the current box
     *
     * @param vehicleObject
     * @return if false is returned the object could not be removed
     */
    public boolean removeVehicleObjectFromBox(Object vehicleObject) {
        Vector myVector = worldBoxArray[myOldPosition.x][myOldPosition.y][myOldPosition.z];
        // remove object from old cube
        if (myVector.remove(vehicleObject)) {
            storedInArray = false;
            return true;
        } else {
            return false;
        }
    }
}
