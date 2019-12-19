package de.hfkbremen.mesh;

import processing.core.PApplet;
import processing.core.PVector;

/**
 * http://de.wikipedia.org/wiki/Rolling-Ball-Rotation
 */
public class ArcBall {

    private final PApplet mParent;
    private final PVector mCenter;
    private final PVector mDownPosition;
    private final PVector mDragPosition;
    public boolean pause = false;
    private float mRadius;
    private Quaternion mCurrentQuaternion;
    private Quaternion mDownQuaternion;
    private Quaternion mDragQuaternion;
    private boolean mLastActiveState = false;

    public ArcBall(PApplet pApplet, boolean pDONT_REGISTER) {
        this(pApplet.g.width / 2.0f,
             pApplet.g.height / 2.0f,
             -Math.min(pApplet.g.width / 2.0f, pApplet.g.height / 2.0f),
             Math.min(pApplet.g.width / 2.0f, pApplet.g.height / 2.0f),
             pApplet,
             pDONT_REGISTER);
    }

    public ArcBall(PApplet parent) {
        this(parent, false);
    }

    public ArcBall(float theCenterX,
                   float theCenterY,
                   float theCenterZ,
                   float theRadius,
                   PApplet pApplet,
                   boolean pDONT_REGISTER) {
        this(new PVector(theCenterX, theCenterY, theCenterZ), theRadius, pApplet, pDONT_REGISTER);
    }

    public ArcBall(final PVector theCenter, final float theRadius, final PApplet pApplet, boolean pDONT_REGISTER) {
        mParent = pApplet;

        if (!pDONT_REGISTER) {
            //            pApplet.registerPre(this);
            pApplet.registerMethod("pre", this); // new in processing 3.0 @test
        }

        mCenter = theCenter;
        mRadius = theRadius;

        mDownPosition = new PVector();
        mDragPosition = new PVector();

        mCurrentQuaternion = new Quaternion();
        mDownQuaternion = new Quaternion();
        mDragQuaternion = new Quaternion();
    }

    public void reset() {
        mDownPosition.set(0, 0, 0);
        mDragPosition.set(0, 0, 0);
        mCurrentQuaternion.reset();
        mDownQuaternion.reset();
        mDragQuaternion.reset();
    }

    public void mousePressed(float theX, float theY) {
        if (!pause) {
            mDownPosition.set(mouse_to_sphere(theX, theY));
            mDownQuaternion.set(mCurrentQuaternion);
            mDragQuaternion.reset();
        }
    }

    public void mouseDragged(float theX, float theY) {
        if (!pause) {
            mDragPosition.set(mouse_to_sphere(theX, theY));
            mDragQuaternion.set(mDownPosition.dot(mDragPosition), PVector.cross(mDownPosition, mDragPosition, null));
        }
    }

    public void update() {
        update(mParent.mousePressed, mParent.mouseX, mParent.mouseY);
    }

    public void update(boolean theActiveState, float theX, float theY) {
        if (mParent == null) {
            return;
        }

        if (theActiveState) {
            if (!mLastActiveState) {
                mousePressed(theX, theY);
            }
            mouseDragged(theX, theY);
        }
        mLastActiveState = theActiveState;

        /* apply transform */
        mParent.translate(mCenter.x, mCenter.y, mCenter.z);
        mCurrentQuaternion.multiply(mDragQuaternion, mDownQuaternion);
        final Vector4f myRotationAxisAngle = mCurrentQuaternion.getVectorAndAngle();
        if (!myRotationAxisAngle.isNaN()) {
            mParent.rotate(myRotationAxisAngle.w, myRotationAxisAngle.x, myRotationAxisAngle.y, myRotationAxisAngle.z);
        }
        mParent.translate(-mCenter.x, -mCenter.y, -mCenter.z);
    }

    public float radius() {
        return mRadius;
    }

    public void radius(float pRadius) {
        mRadius = pRadius;
    }

    public PVector center() {
        return mCenter;
    }

    private PVector mouse_to_sphere(float x, float y) {
        final PVector v = new PVector();
        v.x = (x - mCenter.x) / mRadius;
        v.y = (y - mCenter.y) / mRadius;

        float myLengthSquared = v.x * v.x + v.y * v.y;
        if (myLengthSquared > 1.0f) {
            v.normalize();
        } else {
            v.z = (float) Math.sqrt(1.0f - myLengthSquared);
        }
        return v;
    }

    /* processing callbacks */
    public void pre() {
        update();
    }

    public static ArcBall setupRotateAroundCenter(PApplet pApplet) {
        return new ArcBall(pApplet.width / 2,
                           pApplet.height / 2,
                           0,
                           Math.min(pApplet.g.width / 2.0f, pApplet.g.height / 2.0f),
                           pApplet,
                           false);
    }

    public static ArcBall setupRotateAroundCenter(PApplet pApplet, boolean pDONT_REGISTER) {
        return new ArcBall(pApplet.width / 2,
                           pApplet.height / 2,
                           0,
                           Math.min(pApplet.g.width / 2.0f, pApplet.g.height / 2.0f),
                           pApplet,
                           pDONT_REGISTER);
    }

    private class Quaternion {

        float w;

        float x;

        float y;

        float z;

        Quaternion() {
            reset();
        }

        //        public Quaternion(float theW, float theX, float theY, float theZ) {
        //            w = theW;
        //            x = theX;
        //            y = theY;
        //            z = theZ;
        //        }

        void reset() {
            w = 1.0f;
            x = 0.0f;
            y = 0.0f;
            z = 0.0f;
        }

        void set(float theW, PVector thePVector) {
            w = theW;
            x = thePVector.x;
            y = thePVector.y;
            z = thePVector.z;
        }

        void set(Quaternion theQuaternion) {
            w = theQuaternion.w;
            x = theQuaternion.x;
            y = theQuaternion.y;
            z = theQuaternion.z;
        }

        void multiply(Quaternion theA, Quaternion theB) {
            w = theA.w * theB.w - theA.x * theB.x - theA.y * theB.y - theA.z * theB.z;
            x = theA.w * theB.x + theA.x * theB.w + theA.y * theB.z - theA.z * theB.y;
            y = theA.w * theB.y + theA.y * theB.w + theA.z * theB.x - theA.x * theB.z;
            z = theA.w * theB.z + theA.z * theB.w + theA.x * theB.y - theA.y * theB.x;
        }

        Vector4f getVectorAndAngle() {
            final Vector4f theResult = new Vector4f();

            float s = (float) Math.sqrt(1.0f - w * w);
            if (s < PApplet.EPSILON) {
                s = 1.0f;
            }

            theResult.w = (float) Math.acos(w) * 2.0f;
            theResult.x = x / s;
            theResult.y = y / s;
            theResult.z = z / s;

            return theResult;
        }
    }

    private class Vector4f {

        float w;

        float x;

        float y;

        float z;

        final boolean isNaN() {
            return Float.isNaN(x) || Float.isNaN(y) || Float.isNaN(z) || Float.isNaN(w);
        }
    }
}