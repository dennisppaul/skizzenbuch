import processing.core.PApplet;
import processing.core.PVector;
import teilchen.Particle;
import teilchen.Physics;
import teilchen.force.Gravity;
import teilchen.force.ViscousDrag;
import teilchen.util.Overlap;

static final float    PARTICLE_RADIUS = 13;
Physics  mPhysics;

void settings() {
  size(640, 480);
}

PSurface initSurface() {
  super.initSurface();
  javax.swing.JFrame frame = (javax.swing.JFrame) ((processing.awt.PSurfaceAWT.SmoothCanvas) getSurface().getNative()).getFrame();
  frame.setUndecorated(true);
  java.awt.Window window = (java.awt.Window) frame;
  window.setOpacity(0.5f);
  java.awt.geom.Ellipse2D.Float circle = new java.awt.geom.Ellipse2D.Float(0, 0, 400, 400);
  window.setShape(circle);
  return surface;
}

void setup() {
  mPhysics = new Physics();
  mPhysics.add(new ViscousDrag());
  mPhysics.add(new Gravity(new PVector(0, 100f, 0)));
  noStroke();
}

void draw() {
  if (mousePressed) {
    Particle mParticle = mPhysics.makeParticle(mouseX, mouseY, 0);

    /* define a radius for the particle so it has dimensions */
    mParticle.radius(random(PARTICLE_RADIUS / 2) + PARTICLE_RADIUS);
  }


  /* move overlapping particles away from each other */
  for (int i = 0; i < 10; i++) {
    Overlap.resolveOverlap(mPhysics.particles());
  }

  /* update the particle system */
  mPhysics.step(1.0f / frameRate);

  /* constraint particles */
  for (int i = 0; i < mPhysics.particles().size(); i++) {
    if (mPhysics.particles(i).position().y > height - 10) {
      mPhysics.particles(i).position().y = height - 10;
    }
    if (mPhysics.particles(i).position().x > width) {
      mPhysics.particles(i).position().x = width;
    }
    if (mPhysics.particles(i).position().x < 0) {
      mPhysics.particles(i).position().x = 0;
    }
  }

  /* draw particles and connecting line */
  background(255, 255, 255, 20);

  /* draw particles */
  fill(255);
  for (int i = 0; i < mPhysics.particles().size(); i++) {
    Particle p = mPhysics.particles().get(i);
    fill(0);
    circle(p.position().x, p.position().y, p.radius() * 3);
  }
}
