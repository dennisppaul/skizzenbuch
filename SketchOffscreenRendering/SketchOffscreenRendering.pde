PGraphics pg;

void settings() {
  size(1024, 768, P3D);
}

void setup() {
  imageMode(CENTER);
  pg = createGraphics(1024, 768, P3D);
}

void draw() {
  final float M_ALPHA = 7;
  pg.beginDraw();
  pg.background(255, 0);
  pg.stroke(255, M_ALPHA);
  pg.line(pg.width/2, pg.height/2, mouseX, mouseY);
  pg.noStroke();
  pg.fill(255, M_ALPHA);
  pg.ellipse(mouseX, mouseY, 40, 40);
  pg.ellipse(pg.width/2, pg.height/2, 2, 2);
  pg.stroke(255, 127);
  for (int i=0; i<2048; i++) {
    pg.pushMatrix();
    pg.translate(random(width), random(height));
    pg.point(0, 0);
    pg.popMatrix();
  }
  pg.endDraw();

  background(50);
  for (int i=0; i<255; i++) {
    pushMatrix();
    final float M_OFFSET = 10;
    translate(width/2, height/2);
    rotate(random(-PI/9, PI/9));
    translate(random(-M_OFFSET, M_OFFSET), random(-M_OFFSET, M_OFFSET));
    scale(random(0.95, 1.05));
    image(pg, 0, 0);
    popMatrix();
  }
}

void keyPressed() {
  saveFrame();
}
