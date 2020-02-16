ArchElement mRoot;

void settings() {
  size(1024, 768, P3D);
}

void setup() {
  mRoot = new ArchElement();
  ArchElement.addNode(mRoot);
  textFont(createFont("Courier", 9));
}

void draw() {
  mRoot.update();

  background(255);
  directionalLight(126, 126, 126, 0, 0, 1);
  ambientLight(102, 102, 102);

  text("NODES: " + ArchElement.nodes().size(), 20, 20);
  text("FPS  : " + frameRate, 20, 35);

  translate(width / 2, height / 2);
  scale(1, -1, 1);
  rotateX((float) mouseY / (float) height * 2.0f - PI / 3);
  rotateY(frameCount * 0.003f);
  
  final float mScale = 20;
  scale(mScale);
  strokeWeight(1.0f / mScale);
  
  mRoot.draw(g);

  if (keyPressed && ArchElement.nodes().size() < 15000) {
    mRoot.spawn(this);
  }
}