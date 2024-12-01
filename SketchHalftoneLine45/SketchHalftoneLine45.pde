import processing.video.*;

Capture video;

PImage img;
PShader halftoneShader;

void setup() {
  size(720, 720, P2D);
  noStroke();
  
  img = loadImage("digital-media-studio.jpg");
  img.filter(GRAY);
  img.resize(width, height);

  video = new Capture(this, width/4, height/4);
  video.start();

  // Load the shader
  halftoneShader = loadShader("halftone.glsl");
}

void draw() {
  background(255);
  if (video.available()) {
    video.read();
    video.loadPixels();
  }

  // Map mouse position to control parameters
  float maxLineWidth = map(mouseX, 0, width, 1, 200);
  float frequency = map(mouseY, 0, height, 1, 200);

  // Pass parameters to the shader
  halftoneShader.set("resolution", float(width), float(height));
  //  halftoneShader.set("tex0", img);
  halftoneShader.set("tex0", video);
  halftoneShader.set("maxLineWidth", maxLineWidth);
  halftoneShader.set("frequency", frequency);

  // Apply the shader
  shader(halftoneShader);

  // Draw a rectangle to cover the entire canvas
  rect(10, 10, width-20, height-20);
}

void mouseMoved() {
  float maxLineWidth = map(mouseX, 0, width, 1, 200);
  float frequency = map(mouseY, 0, height, 1, 200);
  println("maxLineWidth: " + maxLineWidth);
  println("frequency   : " + frequency);
}

/* without shader */

//PImage img;

//void setup() {
//  size(800, 800);
//  img = loadImage("digital-media-studio.jpg");
//  img.filter(GRAY);
//  img.resize(width, height);
//  strokeCap(PROJECT);
//  strokeCap(SQUARE);
//}

//void draw() {
//  background(255);
//  float maxLineWidth = map(mouseX, 0, width, 1, 20);
//  float frequency = map(mouseY, 0, height, 1, 20);

//  for (int y = 0; y < img.height; y += frequency) { // Adjust step size for spacing
//    for (int x = 0; x < img.width; x += frequency) {
//      int pixelColor = img.pixels[y * img.width + x];
//      float brightnessValue = brightness(pixelColor);
//      float lineWidth = map(brightnessValue, 0, 255, maxLineWidth, 0); // Inverse mapping for line width

//      stroke(0);
//      strokeWeight(lineWidth);

//      // Calculate endpoints for 45° angled line
//      float offset = frequency / 2; // Half of step size (10) for centering the line
//      line(x - offset, y - offset, x + offset, y + offset); // 45° line
//    }
//  }
//}
