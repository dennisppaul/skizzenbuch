import teilchen.*; 
import teilchen.constraint.*; 
import teilchen.force.*; 
import teilchen.integration.*; 
import teilchen.util.*; 

Physics mPhysics;
Particle mRoot;
StableSpringQuad mQuad;
PImage mTexture;

void settings() {
    size(640, 480, P3D);
}

void setup() {
    mTexture = loadImage("dpp.png");

    mPhysics = new Physics();
    mPhysics.setIntegratorRef(new RungeKutta());
    Gravity myGravity = new Gravity();
    myGravity.force().y = 98.1f;
    mPhysics.add(myGravity);
    mPhysics.add(new ViscousDrag(0.2f));

    Box myBox = new Box();
    myBox.min().set(0, 0, 0);
    myBox.max().set(width, height, 0);
    mPhysics.add(myBox);

    Particle a = mPhysics.makeParticle(0, 0);
    Particle b = mPhysics.makeParticle(100, 0);
    Particle c = mPhysics.makeParticle(100, 100);
    Particle d = mPhysics.makeParticle(0, 100);

    a.mass(0.5f);
    b.mass(0.5f);
    c.mass(0.5f);
    d.mass(0.5f);

    mRoot = a;
    mRoot.fixed(true);
    mRoot.radius(10);

    mQuad = new StableSpringQuad(mPhysics, a, b, c, d);
}

void draw() {
    /* handle particles */
    if (mousePressed) {
        mRoot.fixed(true);
        mRoot.position().set(mouseX, mouseY);
    } else {
        mRoot.fixed(false);
    }
    mPhysics.step(1.0f / frameRate);

    background(255);

    noStroke();
    fill(0);
    ellipse(mRoot.position().x, mRoot.position().y, 15, 15);

    beginShape();
    texture(mTexture);
    vertex(mQuad.a.position().x, mQuad.a.position().y, 0, 0);
    vertex(mQuad.b.position().x, mQuad.b.position().y, mTexture.width, 0);
    vertex(mQuad.c.position().x, mQuad.c.position().y, mTexture.width, mTexture.height);
    vertex(mQuad.d.position().x, mQuad.d.position().y, 0, mTexture.height);
    endShape();
}
