import de.hfkbremen.mesh.*; 
import java.awt.*; 
import java.awt.geom.*; 


VectorFont mPathCreator;
void settings() {
    size(1024, 768, P3D);
}
void setup() {
    mPathCreator = new VectorFont("Helvetica", 72);
    mPathCreator.insideFlag(VectorFont.CLOCKWISE);
    mPathCreator.stretch_to_fit(true);
    mPathCreator.repeat(false);
}
void draw() {
    background(255);
    /* adjust flatness ( ie resolutions of curves ) */
    final float mOutlineFlatness = abs((float) mouseX / (float) width) * 5 + 0.1f;
    final float mPathFlatness = abs((float) mouseY / (float) height) * 5 + 0.1f;
    mPathCreator.outline_flatness(mOutlineFlatness);
    mPathCreator.path_flatness(mPathFlatness);
    /* create path */
    final ArrayList<PVector> mPath = new ArrayList();
    for (int x = 0; x < width; x += 20) {
        float y = sin(radians(x * 0.5f + frameCount * 5)) * 50 + height / 2;
        mPath.add(new PVector(x, y));
    }
    /* create outlines */
    String mString = "MOUSE: " + mouseX + ", " + mouseY +
            " | FPS: " + (int) frameRate +
            " | FLATNESS: " + round(mOutlineFlatness);
    final ArrayList<PVector> myTriangles = mPathCreator.vertices(mString, mPath);
    /* toggle fill and wireframe */
    if (mousePressed) {
        stroke(0, 0, 255, 127);
        noFill();
    } else {
        noStroke();
        fill(0);
    }
    /* create and draw trinangles */
    beginShape(TRIANGLES);
    for (PVector myCharacters : myTriangles) {
        vertex(myCharacters.x, myCharacters.y, myCharacters.z);
    }
    endShape();
}
