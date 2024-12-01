import processing.video.*;

PShader fShader;
PGraphics pass1;

void setup() {
  size(1024, 768, P2D);
  noStroke();

  pass1 = createGraphics(width, height, P2D);
  pass1.noSmooth();

  fShader = loadShader("film_grain.glsl");
  fShader.set("time", 0.0f);
  fShader.set("strength", 16.0f);
  fShader.set("blend_mode", 0);
}

void draw() {
  background(255);

  pass1.beginDraw();
  pass1.background(50);
  pass1.noStroke();
  pass1.fill(255, 0, 0);
  pass1.circle(width / 2, height / 2, 256);
  pass1.fill(255);
  pass1.circle (mouseX, mouseY, 128);
  pass1.endDraw();

  float fStrength = map(mouseX, 0, width, 1, 36);
  fShader.set("strength", fStrength);
  float fTime = (float)frameCount / (float)frameRate;
  fShader.set("time", fTime);

  noStroke();
  shader(fShader);
  image(pass1, 0, 0, width, height);
}

void keyPressed() {
  switch (key) {
  case '1':
    fShader.set("blend_mode", 0);
    break;
  case '2':
    fShader.set("blend_mode", 1);
    break;
  case '3':
    fShader.set("blend_mode", 2);
    break;
  }
}
