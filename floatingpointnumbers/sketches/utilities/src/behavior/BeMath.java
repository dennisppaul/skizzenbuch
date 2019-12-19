package behavior;


/** bMath  */

public class BeMath
{

    public static final float PI = (float)Math.PI;

    /**
     * contrain a radiant value to -Pi to PI
     * @param myValue
     * @return
     */
    public static float constrainRadiant(float myValue) {
        myValue %= 2 * PI;
        if (myValue > PI) {
            myValue -= 2 * PI;
        }
        if (myValue < -PI) {
            myValue += 2 * PI;
        }
        return myValue;
    }



    /** return a value modified by exponent-function
     * @param value of to be modified
     * @param the maximum value
     * @param degree of modification
     */
    public static float ease(float position, float length, float exponent) {
        float ration = position / length;
        ration = (float)Math.pow(ration, exponent);
        return ration;
    }



    /* smoothstep function
     * @param a minimum
     * @param b maximum
     * @param x position
     */
    public static float smoothstep(float a, float b, float x) {
        if (x < a) {
            return 0.0f;
        }
        if (x >= b) {
            return 1.0f;
        }
        x = (x - a) / (b - a);
        return (x * x) * (3.0f - 2.0f * x);
    }

    /*
     * @param punktArray Array mit 4 n-dimensionalen Punkten startpunkt, Anfasser-Startpunkt, Endpunkt, Anfasser-endpunkt
     * @param aufloesung Anzahl der Schritte zwischen den Start und Endpunkten
     */
    /*
        public static float bCurve (float[] punktArray, float aufloesung) {
        // anzahl der Dimensionen
        int anzahlDimensionen = punktArray[0].length;
        // punkte umsortieren
        var myP0 = new Array(); // punkt 1
        var myP1 = new Array(); // anfasser 1
        var myP2 = new Array(); // punkt 2
        var myP3 = new Array(); // anfasser 2
        for (var j = 0; j < anzahlDimensionen; j++) {
            myP0[j] = punktArray[0][j];
            myP1[j] = punktArray[1][j];
            myP3[j] = punktArray[2][j];
            myP2[j] = punktArray[3][j];
        }
        // b-Funktion
        var a = new Array();
        var b = new Array();
        var c = new Array();
        var punktArray = new Array();
        for (var j = 0; j < anzahlDimensionen; j++) {
            c[j] = 3 * (myP1[j] - myP0[j]);
            b[j] = 3 * (myP2[j] - myP1[j]) - c[j];
            a[j] = myP3[j] - myP0[j] - c[j] - b[j];
        }
        for (var i = 0; i < aufloesung + 1; i++) {
            // ease
            var t;
            t = i / aufloesung;
            // b-Funk
            var myPunkte = new Array();
            for (var j = 0; j < anzahlDimensionen; j++) {
                myPunkte[j] = a[j] * t * t * t + b[j] * t * t + c[j] * t
                              + myP0[j];
            }
            punktArray[i] = myPunkte;
        }
        return (punktArray);
         }
     */

}