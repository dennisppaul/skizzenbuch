/* Behavior */

package behavior;


import mathematik.Vector3f;
import mathematik.Vector4f;


public class Behavior {

    public Wander wander;

    public AvoidPoint avoidPoint;

    public GoToPoint goToPoint;

    public Rotation rotation;

    public static final int WANDER = 0;

    public static final int AVOIDPOINT = 1;

    private static final float PI = (float) Math.PI;

    public float velocityLength;

    public float velocityOrientation;

    public float mass;

    public Vector3f velocity;

    public Vector3f position;

    public Behavior() {
        reset();
        wander = new Wander();
        avoidPoint = new AvoidPoint();
        goToPoint = new GoToPoint();
        rotation = new Rotation();
    }


    public Behavior(int selectedBehavior) {
        reset();
        switch (selectedBehavior) {
            case WANDER:
                wander = new Wander();
            case AVOIDPOINT:
                avoidPoint = new AvoidPoint();
        }
    }


    /* applies physic to a vector */
    public Vector3f physic(Vector3f v) {
        // unimplemented
        return v;
    }


    /* resets values to default */
    public void reset() {
        velocityLength = 0.0f;
        velocityOrientation = 0.0f;
        mass = 1.0f;
        velocity = new Vector3f(0.0f, 0.0f, 1.0f);
        position = new Vector3f();
    }


    /* calculates a fresh velocity length */
    public void setVelocityLength() {
        velocityLength = velocity.length();
    }


    /* sets a new velocity */
    public void setVelocity(Vector3f velocity) {
        this.velocity.set(velocity);
    }


    public void setVelocity(float x, float y, float z) {
        this.velocity.x = x;
        this.velocity.y = y;
        this.velocity.z = z;
    }


    /** gets the velocity
     *    @param the new velocity vector
     */
    public Vector3f getVelocity() {
        return velocity;
    }


    /** sets a new position
     *    @param the new position vector
     */
    public void setPosition(Vector3f position) {
        this.position.set(position);
    }


    public void setPosition(float x, float y, float z) {
        this.position.x = x;
        this.position.y = y;
        this.position.z = z;
    }


    /** gets the position
     *    @param the new position vector
     */
    public Vector3f getPosition() {
        return position;
    }


    // ------------------------------------------------------------------------------------------------
    // ------------------------------------------------------------------------------------------------
    // ------------------------------------------------------------------------------------------------
    // BASIC BEHAVIOR
    // ------------------------------------------------------------------------------------------------
    // ------------------------------------------------------------------------------------------------
    // ------------------------------------------------------------------------------------------------

    // ------------------------------------------------------------------------------------------------
    /* Wander
     * generates random but natural movement
     */

    // TODO
    // 01   wandering; the random velocity offset is alittlebit strange stil ???

    public class Wander {

        public float steering_max_change;

        public float steering_offset;

        public float steering_limit;

        public Vector3f upVector;

        public boolean normalize;

        private Vector3f wanderDirection = new Vector3f();

        /** constructor */
        Wander() {
            reset();
        }


        /** reset
         */ public void reset() {
            steering_max_change = 0.1f;
            steering_offset = 0.0f;
            steering_limit = 0.1f;
            upVector = new Vector3f(0.0f, 1.0f, 0.0f);
            normalize = true;
        }


        /** calculate a wandering vector
         * @return the wandering vector
         */
        public Vector3f get() {
            // wandering
            wanderDirection.normalize(velocity);
            wanderDirection.cross(upVector, wanderDirection);
            steering_offset += (float) Math.random() * steering_max_change - steering_max_change * 0.5f;
            steering_offset = (float) Math.min(steering_limit, steering_offset);
            steering_offset = (float) Math.max( -steering_limit, steering_offset);
            wanderDirection.scale(steering_offset);
            // if(normalize)wanderDirection.normalize(); // <<< this hasn t been implemented but next project...
            return wanderDirection;
        }

    }


    // ------------------------------------------------------------------------------------------------
    /* AvoidPoint
     * a simple version of avoiding a point.
     * it just calculates the opposit direction of the point we want to avoid
     * a more sophisticted version would steer with an orthogonal vector away from the point
     * @param postion of the obstacle
     */
    public class AvoidPoint {

        public Vector3f avoidPointDirection;

        public Vector3f pointPosition;

        public boolean normalize;

        /** constructor */
        public AvoidPoint() {
            reset();
        }


        /** calculate an avoid point vector
         * @return the avoid point vector
         */
        public Vector3f get() {
            avoidPointDirection.sub(position, pointPosition);
            if (normalize) {
                avoidPointDirection.normalize();
                //? what is that? avoidPointDirection.scale(steering_limit);
            }
            return avoidPointDirection;
        }


        /** calculate a avoid point vector
         * @param sets a new point
         * @return the avoid point vector
         */
        public Vector3f get(Vector3f pointPosition) {
            this.pointPosition = pointPosition;
            return get();
        }


        /** reset values to default
         */
        public void reset() {
            avoidPointDirection = new Vector3f();
            pointPosition = new Vector3f();
            normalize = true;
        }

    }


    // ------------------------------------------------------------------------------------------------
    /* AvoidPointGroup
     * a simple version of avoiding a position defined by a group of points.
     * @param postions of points
     */
    public class AvoidPointGroup {}


    // ------------------------------------------------------------------------------------------------
    /* AvoidObstacle
     * is a more complex way of avoidPoint
     * it considers the distance and the position of the obstacle as well
     * if ie an obstacle is to the right of the object the object will steer to left
     * by applying an orthogonal vector to the current velocity
     * @param obstaclePosition
     */
    public class AvoidObstacle {}


    // ------------------------------------------------------------------------------------------------
    /* GoToPoint
     * go to a position defined by a point
     * @param pointPosition
     */
    public class GoToPoint {

        public Vector3f goToPointDirection;

        public Vector3f pointPosition;

        public boolean normalize;

        /** constructor */
        public GoToPoint() {
            reset();
        }


        /** calculate an go to point vector
         * @return the go to point vector
         */
        public Vector3f get() {
            goToPointDirection.sub(pointPosition, position);
            if (normalize) {
                goToPointDirection.normalize();
            }
            return goToPointDirection;
        }


        /** calculate a go to point vector
         * @param sets a new point
         * @return the go to point vector
         */
        public Vector3f get(Vector3f pointPosition) {
            this.pointPosition = pointPosition;
            return get();
        }


        /** reset values to default
         */
        public void reset() {
            goToPointDirection = new Vector3f();
            pointPosition = new Vector3f();
            normalize = true;
        }

    }


    // ------------------------------------------------------------------------------------------------
    /** GoToPointGroup
     * go to a position defined by a group of point
     * @param pointPosition
     */
    public class GoToPointGroup {}


    // ------------------------------------------------------------------------------------------------
    /* Pursue
     * is a more complex way of goToPoint
     * not only the position of a point is considered but also the future position
     * estimated by considering the velocity of a point
     * @param pointPosition
     * @param pointVelocity
     */
    public class Pursue {}


    // ------------------------------------------------------------------------------------------------
    /* Arrive
     * is a more complex way of goToPoint
     * it slows down when it comes closer to the point of arrival
     * @param pointPosition
     * @param radius
     * @param slow down coefficient?, 1 is a linear slowdown
     */
    public class Arrive {}


    // ------------------------------------------------------------------------------------------------
    /* FlowFieldFollow
     * returns a vector from a flowfield
     * with the scale parameter the position values can be stretched to fit a certain area
     * usually one unit equals one step in the flowfield array
     * @param scale
     * @param pointer to flowfield array
     */
    public class FlowFieldFollow {}


    // ------------------------------------------------------------------------------------------------
    // ------------------------------------------------------------------------------------------------
    // ------------------------------------------------------------------------------------------------
    // EXTENDED BEHAVIOR
    // ------------------------------------------------------------------------------------------------
    // ------------------------------------------------------------------------------------------------
    // ------------------------------------------------------------------------------------------------

    // ------------------------------------------------------------------------------------------------
    // ------------------------------------------------------------------------------------------------
    // ------------------------------------------------------------------------------------------------
    // PHYSIC and OTHERS
    // ------------------------------------------------------------------------------------------------
    // ------------------------------------------------------------------------------------------------
    // ------------------------------------------------------------------------------------------------

    // ------------------------------------------------------------------------------------------------
    /* Rotation
     * NOTE the rotation is stored as a 2D vector. this may not be correct or accurate
     * but is the way i usually need it. that s why it s done that way.
     * a method that converts the vector to radians or degrees is availabe as well.
     */
    public class Rotation {

        public int rotationType;

        public static final int NORMAL = 0;

        public static final int SMOOTH = 1;

        public boolean calculateAngle = true;

        public Vector4f rotation;

        //private Vector2f orientation;

        public float rotationAngle;

        /** contructor */
        public Rotation() {
            reset();
        }


        /** calculates the rotation
         */
        public void calculateRotation() {
            switch (rotationType) {
                case NORMAL:
                    rotation.w = getVelocityRotation();
                    break;
                case SMOOTH:
                    rotation.w = getSmoothVelocityRotation();
                    break;
            }
        }


        /** return the angle of the velocity vector
         */
        public float getVelocityRotation() {
            rotationAngle = (float) Math.atan2(velocity.x, velocity.z);
            return rotationAngle;
        }


        /** calculate and a smooth rotation
         */
        public float rotationMaxVelocityLength = 3.0f;

        private float constrainValue(float myValue) {
            myValue %= 2 * PI;
            if (myValue > PI) {
                myValue -= 2 * PI;
            }
            if (myValue < -PI) {
                myValue += 2 * PI;
            }
            return myValue;
        }


        public float getSmoothVelocityRotation() {
            // get new rotation from velocity
            float newRotation = (float) Math.atan2(velocity.x, velocity.z);
            // get old rotation
            float oldRotation = rotationAngle;
            // length of the velocity vector
            float velocityLength = (float) Math.min(rotationMaxVelocityLength,
                                                    Math.sqrt(velocity.x * velocity.x + velocity.z * velocity.z));
            // get delta and contrain it to -PI and PI
            float delta = constrainValue(newRotation - oldRotation);
            // add delta to oldRotation and constrain to -PI and PI
            rotationAngle = constrainValue(oldRotation + delta * (velocityLength / rotationMaxVelocityLength));
            return rotationAngle;
        }


        /**
         *
         * @return
         */
        public Vector4f getRotation() {
            return rotation;
        }


        /** get the rotation as radians
         * @return rotation as radians
         */
        public float getRotationAngle() {
            return rotation.w;
        }


        /**
         * set the rotation angle in radians
         * @param angle
         */
        public void setRotationAngle(float angle) {
            rotation.w = angle;
        }


        /** get the rotation as degrees
         * @return rotation as degrees
         */
        public float getRotationAngleDegrees() {
            return (float) Math.toDegrees(rotation.w);
        }


        /** set the rotation
         * @todo need to set the orientation too! IMPORTANT
         *
         * @param rotation
         */
        public void setRotation(Vector4f rotation) {
            this.rotation.x = rotation.x;
            this.rotation.y = rotation.y;
            this.rotation.z = rotation.z;
            this.rotation.w = rotation.w;
        }


        /** reset to default values
         */
        public void reset() {
            rotationType = NORMAL;
            //orientation = new Vector2f();
            rotationAngle = 0.0f;
            rotation = new Vector4f();
            rotation.y = 1.0f;
            calculateAngle = true;
        }

    }


    public static void main(String[] args) {
        Behavior behavior = new Behavior();
        behavior.setVelocity(new Vector3f(1.0f, 2.0f, 3.0f));
        // wandering
        behavior.wander.reset();
        // avoidPoint
    }

}
