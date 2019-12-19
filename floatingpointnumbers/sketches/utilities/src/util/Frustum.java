package util;


/** Frustum */

public class Frustum
{

    public float screenWidth;

    public float screenHeight;

    public float cameraHeight;

    /** constructor
     *
     */
    public Frustum(float screenWidth, float screenHeight, float cameraHeight) {
        this.screenWidth = screenWidth;
        this.screenHeight = screenHeight;
        this.cameraHeight = cameraHeight;
    }



    /** change a position value to a frustum value
     *
     * @param objectDepth
     * @param objectPosition
     * @param screenSize
     * @return
     */
    private float position2Frustum(float objectDepth, float objectPosition, float screenSize) {
        float difference = getPositionFrustumDifference(objectDepth, screenSize) - screenSize * 0.5f;
        return objectPosition - difference * (objectPosition / (difference + screenSize * 0.5f));
    }



    /**
     *
     * @param objectDepth
     * @param objectPosition
     * @return
     */
    public float position2FrustumZ(float objectDepth, float objectPosition) {
        return position2Frustum(objectDepth, objectPosition, screenHeight);
    }



    /**
     *
     * @param objectDepth
     * @param objectPosition
     * @return
     */
    public float position2FrustumX(float objectDepth, float objectPosition) {
        return position2Frustum(objectDepth, objectPosition, screenWidth);
    }



    /** change a frustum value to a position value
     *
     * @param objectDepth
     * @param objectPosition
     * @param screenSize
     * @return
     */
    private float frustum2Position(float objectDepth, float objectPosition, float screenSize) {
        float difference = getPositionFrustumDifference(objectDepth, screenSize) - screenSize * 0.5f;
        return objectPosition + difference * (objectPosition / (screenSize * 0.5f));
    }



    /**
     *
     * @param objectDepth
     * @param objectPosition
     * @return
     */
    public float frustum2PositionZ(float objectDepth, float objectPosition) {
        return frustum2Position(objectDepth, objectPosition, screenHeight);
    }



    /**
     *
     * @param objectDepth
     * @param objectPosition
     * @return
     */
    public float frustum2PositionX(float objectDepth, float objectPosition) {
        return frustum2Position(objectDepth, objectPosition, screenWidth);
    }



    /** calculate the difference between a numeric position and
     *   the percepted position due to perspektiv distortion
     *
     * @param objectDepth
     * @param screenSize
     * @return
     */
    public float getPositionFrustumDifference(float objectDepth, float screenSize) {
        return (cameraHeight - objectDepth) * (screenSize * 0.5f) / cameraHeight;
    }

}