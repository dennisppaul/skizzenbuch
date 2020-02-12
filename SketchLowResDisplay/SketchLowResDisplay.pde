PGraphics display;
PVector p0 = new PVector();
PVector p1 = new PVector();

void settings() {
  size(1024, 768, P3D);
}

void setup() {
  display = createGraphics(1024/32, 768/32);
  texture_sampling_linear();
}

void draw() {

  p0.x += 0.0037;
  p0.y -= 0.01;
  p1.x -= 0.007;
  p1.y += 0.013;

  p0.x = p0.x > display.width ? p0.x - display.width : p0.x;
  p0.y = p0.y < 0 ? p0.y + display.height : p0.y;
  p1.x = p1.x < 0 ? p1.x + display.width : p1.x;
  p1.y = p1.y > display.height ? p1.y - display.height : p1.y;

  display.beginDraw();
  display.background(255);
  display.stroke(0);
  display.line(p0.x, p0.y, p1.x, p1.y);
  display.endDraw();

  background(50);
  translate(width/2, height/2);
  rotateX(((float)mouseY/(float)height - 0.5)*PI);
  rotateY(((float)mouseX/(float)width - 0.5)*PI);
  image(display, -width/4, -height/4, width/2, height/2);
}

void keyPressed() {
  switch(key) {
  case '1':
    texture_sampling_linear();
    break;
  case '2':
    texture_sampling_bilinear();    
    break;
  }
}

void texture_sampling_linear() {
  ((PGraphicsOpenGL)g).textureSampling(3); // LINEAR
}

void texture_sampling_bilinear() {
  ((PGraphicsOpenGL)g).textureSampling(4); // BILINEAR
}
