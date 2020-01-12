PGraphics pg;
final int M_SCALE = 32;

void settings() {
  size(1024, 768, P3D);
}

void setup() {
  imageMode(CENTER);
  pg = createGraphics(1024/M_SCALE, 768/M_SCALE, P3D);
}

void draw() {
  pg.beginDraw();
  pg.background(50);
  pg.fill(255);
  pg.noStroke();
  pg.ellipse(mouseX/M_SCALE, mouseY/M_SCALE, 9, 9);
  pg.endDraw();

  background(50);
  image(pg, width/2, height/2, width, height);
}

void keyPressed() {
  saveFrame();
}
