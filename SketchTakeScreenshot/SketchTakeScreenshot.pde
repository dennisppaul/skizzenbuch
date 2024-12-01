PImage screenshot = takeScreenshot();

void setup() {
  fullScreen();
  noStroke();
  fill(0);
}

static PImage takeScreenshot() {
  try {
    java.awt.Robot robot = new java.awt.Robot();
    java.awt.Rectangle screenRect = new java.awt.Rectangle(java.awt.Toolkit.getDefaultToolkit().getScreenSize());
    java.awt.image.BufferedImage screenCapture = robot.createScreenCapture(screenRect);
    PImage screenshot = new PImage(screenCapture.getWidth(), screenCapture.getHeight(), ARGB);
    screenCapture.getRGB(0, 0, screenCapture.getWidth(), screenCapture.getHeight(), screenshot.pixels, 0, screenCapture.getWidth());
    screenshot.updatePixels();
    return screenshot;
  }
  catch (Exception e) {
    e.printStackTrace();
    return null;
  }
}

void draw() {
  background(255);
  if (screenshot != null) {
    image(screenshot, 0, 0, width, height); // Display the screenshot in the Processing window
  } else {
    println("Failed to capture the screenshot.");
  }

  circle(mouseX, mouseY, 100);
}
