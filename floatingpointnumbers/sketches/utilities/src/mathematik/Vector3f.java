/*
 * Mathematik
 *
 * Copyright (C) 2005 Patrick Kochlik + Dennis Paul
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 * {@link http://www.gnu.org/licenses/lgpl.html}
 *
 */


package mathematik;


import java.io.Serializable;


public class Vector3f
    implements Serializable {

    private static final long serialVersionUID = -1021495605082676516L;

    public float x;

    public float y;

    public float z;

    private float[] _myArrayRepresentation = new float[3];

    private static final float ALMOST_THRESHOLD = 0.001f;

    public Vector3f() {
        x = 0.0f;
        y = 0.0f;
        z = 0.0f;
    }


    public Vector3f(float theX,
                    float theY,
                    float theZ) {
        set(theX,
            theY,
            theZ);
    }


    public Vector3f(double theX,
                    double theY,
                    double theZ) {
        set(theX,
            theY,
            theZ);
    }


    public Vector3f(float theX,
                    float theY) {
        set(theX,
            theY);
    }


    public Vector3f(double theX,
                    double theY) {
        set(theX,
            theY);
    }


    public Vector3f(float[] theVector) {
        set(theVector);
    }


    public Vector3f(double[] theVector) {
        set(theVector);
    }


    public Vector3f(int[] theVector) {
        set(theVector);
    }


    public Vector3f(Vector3f theVector) {
        set(theVector);
    }


    public Vector3f(Vector2f theVector) {
        set(theVector);
    }


    public Vector3f(Vector3i theVector) {
        set(theVector);
    }


    public Vector3f(Vector2i theVector) {
        set(theVector);
    }


    public final void set(float theX,
                          float theY,
                          float theZ) {
        x = theX;
        y = theY;
        z = theZ;
    }


    public final void set(double theX,
                          double theY,
                          double theZ) {
        x = (float) theX;
        y = (float) theY;
        z = (float) theZ;
    }


    public final void set(float theX,
                          float theY) {
        x = theX;
        y = theY;
    }


    public final void set(double theX,
                          double theY) {
        x = (float) theX;
        y = (float) theY;
    }


    public final void set(float[] theVector) {
        x = theVector[0];
        y = theVector[1];
        z = theVector[2];
    }


    public final void set(double[] theVector) {
        x = (float) theVector[0];
        y = (float) theVector[1];
        z = (float) theVector[2];
    }


    public final void set(int[] theVector) {
        x = theVector[0];
        y = theVector[1];
        z = theVector[2];
    }


    public final void set(Vector3f theVector) {
        x = theVector.x;
        y = theVector.y;
        z = theVector.z;
    }


    public final void set(Vector2f theVector) {
        x = theVector.x;
        y = theVector.y;
    }


    public final void set(Vector3i theVector) {
        x = theVector.x;
        y = theVector.y;
        z = theVector.z;
    }


    public final void set(Vector2i theVector) {
        x = theVector.x;
        y = theVector.y;
    }


    public final void add(Vector3f theVectorA,
                          Vector3f theVectorB) {
        x = theVectorA.x + theVectorB.x;
        y = theVectorA.y + theVectorB.y;
        z = theVectorA.z + theVectorB.z;
    }


    public final void add(Vector3f theVector) {
        x += theVector.x;
        y += theVector.y;
        z += theVector.z;
    }


    public final void add(float theX, float theY) {
        x += theX;
        y += theY;
    }


    public final void add(float theX, float theY, float theZ) {
        x += theX;
        y += theY;
        z += theZ;
    }


    public final void sub(Vector3f theVectorA,
                          Vector3f theVectorB) {
        x = theVectorA.x - theVectorB.x;
        y = theVectorA.y - theVectorB.y;
        z = theVectorA.z - theVectorB.z;
    }


    public final void sub(Vector3f theVector) {
        x -= theVector.x;
        y -= theVector.y;
        z -= theVector.z;
    }


    public final void scale(float theScalar,
                            Vector3f theVector) {
        x = theScalar * theVector.x;
        y = theScalar * theVector.y;
        z = theScalar * theVector.z;
    }


    public final void scale(float theScalar) {
        x *= theScalar;
        y *= theScalar;
        z *= theScalar;
    }


    public final void scale(Vector3f theVector) {
        x *= theVector.x;
        y *= theVector.y;
        z *= theVector.z;
    }


    public final void divide(Vector3f theVector) {
        x /= theVector.x;
        y /= theVector.y;
        z /= theVector.z;
    }


    public final float lengthSquared() {
        return x * x + y * y + z * z;
    }


    public final float length() {
        return (float) Math.sqrt(x * x + y * y + z * z);
    }


    public final void cross(Vector3f theVectorA,
                            Vector3f theVectorB) {
        float xx = theVectorA.y * theVectorB.z - theVectorA.z * theVectorB.y;
        float yy = theVectorB.x * theVectorA.z - theVectorB.z * theVectorA.x;
        z = theVectorA.x * theVectorB.y - theVectorA.y * theVectorB.x;
        x = xx;
        y = yy;
    }


    public final float dot(Vector3f theVector) {
        return x * theVector.x + y * theVector.y + z * theVector.z;
    }


    public final void normalize(Vector3f theVector) {
        float inverseMag = 1.0f / (float) Math.sqrt(theVector.x * theVector.x + theVector.y * theVector.y + theVector.z
                                                    * theVector.z);
        x = theVector.x * inverseMag;
        y = theVector.y * inverseMag;
        z = theVector.z * inverseMag;
    }


    public final void normalize() {
        float inverseMag = 1.0f / (float) Math.sqrt(x * x + y * y + z * z);
        x *= inverseMag;
        y *= inverseMag;
        z *= inverseMag;
    }


    public final float angle(Vector3f theVector) {
        float d = dot(theVector) / (length() * theVector.length());
        /** @todo check these lines. */
        if (d < -1.0f) {
            d = -1.0f;
        }
        if (d > 1.0f) {
            d = 1.0f;
        }
        return (float) Math.acos(d);
    }


    public final float distanceSquared(Vector3f thePoint) {
        float dx = x - thePoint.x;
        float dy = y - thePoint.y;
        float dz = z - thePoint.z;
        return dx * dx + dy * dy + dz * dz;
    }


    public final float distance(Vector3f thePoint) {
        float dx = x - thePoint.x;
        float dy = y - thePoint.y;
        float dz = z - thePoint.z;
        return (float) Math.sqrt(dx * dx + dy * dy + dz * dz);
    }


    public final float distanceL1(Vector3f thePoint) {
        return Math.abs(x - thePoint.x) + Math.abs(y - thePoint.y) + Math.abs(z - thePoint.z);
    }


    public final void min(Vector3f theMin) {
        if (x < theMin.x) {
            x = theMin.x;
        }
        if (y < theMin.y) {
            y = theMin.y;
        }
        if (z < theMin.z) {
            z = theMin.z;
        }
    }


    public final void min(float theX,
                          float theY,
                          float theZ) {
        if (x < theX) {
            x = theX;
        }
        if (y < theY) {
            y = theY;
        }
        if (z < theZ) {
            z = theZ;
        }
    }


    public final void max(Vector3f theMax) {
        if (x > theMax.x) {
            x = theMax.x;
        }
        if (y > theMax.y) {
            y = theMax.y;
        }
        if (z > theMax.z) {
            z = theMax.z;
        }
    }


    public final void max(float theX,
                          float theY,
                          float theZ) {
        if (x > theX) {
            x = theX;
        }
        if (y > theY) {
            y = theY;
        }
        if (z > theZ) {
            z = theZ;
        }
    }


    public final float[] toArray() {
        _myArrayRepresentation[0] = x;
        _myArrayRepresentation[1] = y;
        _myArrayRepresentation[2] = z;
        return _myArrayRepresentation;
    }


    public final boolean isNaN() {
        if (Float.isNaN(x) || Float.isNaN(y) || Float.isNaN(z)) {
            return true;
        } else {
            return false;
        }
    }


    public final boolean equals(Vector3f theVector) {
        if (x == theVector.x && y == theVector.y && z == theVector.z) {
            return true;
        } else {
            return false;
        }
    }


    public final boolean almost(Vector3f theVector) {
        if (Math.abs(x) - Math.abs(theVector.x) < ALMOST_THRESHOLD
            && Math.abs(y) - Math.abs(theVector.y) < ALMOST_THRESHOLD
            && Math.abs(z) - Math.abs(theVector.z) < ALMOST_THRESHOLD) {
            return true;
        } else {
            return false;
        }
    }


    public final String toString() {
        return "(" + x + ", " + y + ", " + z + ")";
    }
}
