import ddf.minim.analysis.*;
import ddf.minim.*;
import de.hfkbremen.gewebe.*; 

Mesh mMesh;

Minim       minim;
AudioPlayer jingle;
FFT         fft;

void setup() {
    size(1024, 768, P3D);

    minim = new Minim(this);
    jingle = minim.loadFile("teilchen.mp3", 256);
    jingle.loop();
    fft = new FFT( jingle.bufferSize(), jingle.sampleRate() );

    mMesh = IcoSphere.mesh(3);
    mMesh.scale(height / 4);
}

void draw() {
    fft.forward( jingle.mix );

    background(255);
    translate(width/2, height/2);
    rotateX(sin(frameCount / 60.0f));
    rotateY(cos(frameCount / 43.0f));

    noFill();
    stroke(0);
    final float[] mVertices = mMesh.vertices();
    final int mNumberOfBands = fft.specSize();
    beginShape(TRIANGLES);
    for (int i=0; i < mVertices.length; i+=3) {
        PVector p = new PVector().set(mVertices[i+0], mVertices[i+1], mVertices[i+2]);
        float mScale = 1.0f + fft.getBand((i/9) % (mNumberOfBands/32) ) * 0.0125f;
        p.mult(mScale);
        vertex(p.x, p.y, p.z);
    }
    endShape();
}
