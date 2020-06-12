import teilchen.*; 
import processing.svg.*;

ArrayList<Particle> mParticles = new ArrayList<Particle>(); 
boolean mRecord;
PGraphics svg;


void setup() {
    size(640, 480);

    mRecord = false;
}

void draw() {
    background(255);
    if (mRecord) {
        svg = beginRecord(SVG, "particle-####.svg");
    }

    translate(width/2, height/2);
    stroke(0);
    noFill();
    for (Particle p : mParticles) {
        drawParticle2(mRecord ? svg : g, p);
    }

    if (mRecord) {
        endRecord();
        mRecord = false;
    }
}

void keyPressed() {
    mRecord = true;
}


void mousePressed() {
    spawnParticle(mouseX- width/2, mouseY - height/2);
}

void spawnParticle(float x, float y) {
    BasicParticle mParticle = new BasicParticle();
    mParticle.position().set(x, y);
    mParticle.velocity().set(random(-200, 200), random(-200, 200));
    mParticle.radius(random(10, 60));
    mParticles.add(mParticle);
}
void drawParticle2(PGraphics g, Particle p) {
    final float STROKE_WEIGHT_LITE = 1;
    final float STROKE_WEIGHT_BOLD = 4;
    final float CROSS_DIAMETER = 6;
    final float ARROW_TIP_DIAMETER = 6;
    g.pushMatrix();
    g.strokeCap(PROJECT);
    g.translate(p.position().x, p.position().y);
    g.strokeWeight(STROKE_WEIGHT_LITE);
    g.ellipse(0, 0, p.radius()*2, p.radius()*2);
    g.line(0, 0, p.velocity().x, p.velocity().y);
    g.strokeWeight(STROKE_WEIGHT_BOLD);
    g.line(-CROSS_DIAMETER, 0, CROSS_DIAMETER, 0);
    g.line(0, -CROSS_DIAMETER, 0, CROSS_DIAMETER);
    g.translate(p.velocity().x, p.velocity().y);
    final float mAngle = PApplet.atan2(p.velocity().y, p.velocity().x) + PI / 2;
    g.rotate(mAngle);
    g.beginShape();
    g.vertex(-ARROW_TIP_DIAMETER, ARROW_TIP_DIAMETER);
    g.vertex(0, 0);
    g.vertex(ARROW_TIP_DIAMETER, ARROW_TIP_DIAMETER);
    g.endShape();
    g.popMatrix();
}
