MetaballManager mMManager;
Metaball mMetaball;
float mRotation;

void setup() {
  size(1024, 768, P3D);
  hint(DISABLE_DEPTH_TEST);
  mMManager = new MetaballManager();

  mMetaball = new Metaball(new PVector(0, 0, 0), 1, 50);
  mMManager.add(mMetaball);
  mMManager.add(new Metaball(new PVector(0, 0, 20), 0.75f, 60));
  mMManager.add(new Metaball(new PVector(50, -150, 0), 0.5f, 80));
  mMManager.add(new Metaball(new PVector(200, 50, -20), 0.5f, 80));
  mMManager.scale().set(width/2, height/2, 300);
  mMManager.gridsize().set(32, 32, 16);
  mMManager.translate().set(width/-4, height/-4, -150);
}

void draw() {

  mMetaball.position.x = mouseX - 320;
  mMetaball.position.y = mouseY - 240;

  /* calculate triangles */
  mMManager.update();
  ArrayList<PVector> myData = mMManager.triangles();

  /* draw */
  background(50);

  /* wiggle */
  translate(width / 2, height / 2);
  mRotation += 1.0f / frameRate;
  rotateX(abs(sin(mRotation * 0.25f)) * PI * 0.2f);
  rotateZ(cos(mRotation * 0.17f) * PI * 0.2f);

  /* draw grid */
  noFill();
  stroke(255, 127, 0, 255);
  drawGrid();

  /* draw triangles */
  stroke(0, 127, 255, 63);
  noFill();
  beginShape(TRIANGLES);
  for (int i = 0; i < myData.size(); i++) {
    PVector p = myData.get(i);
    vertex(p.x, p.y, p.z);
  }
  endShape();
}

void drawGrid() {
  //for (int z = 0; z < mMManager.gridsize().z; z+=2) {
  //  for (int x = 0; x < mMManager.gridsize().x; x+=2) {
  //    PVector p1 = new PVector(x, 0, z);
  //    transformGridPoint(p1);
  //    PVector p2 = new PVector(x, mMManager.gridsize().y - 1, z);
  //    transformGridPoint(p2);
  //    line(p1.x, p1.y, p1.z, p2.x, p2.y, p2.z);
  //  }
  //  for (int y = 0; y < mMManager.gridsize().y; y+=2) {
  //    PVector p1 = new PVector(0, y, z);
  //    transformGridPoint(p1);
  //    PVector p2 = new PVector(mMManager.gridsize().x - 1, y, z);
  //    transformGridPoint(p2);
  //    line(p1.x, p1.y, p1.z, p2.x, p2.y, p2.z);
  //  }
  //}
  for (int z = 0; z < mMManager.gridsize().z; z+=2) {
    for (int x = 0; x < mMManager.gridsize().x; x+=2) {
      for (int y = 0; y < mMManager.gridsize().y; y+=2) {
        PVector p1 = new PVector(x, y, z);
        transformGridPoint(p1);
        point(p1.x, p1.y, p1.z);
      }
    }
  }
}

void transformGridPoint(PVector p) {
  mult(p, mMManager.scale());
  div(p, mMManager.gridsize());
  p.add(mMManager.translate());
}

static void mult(PVector p, PVector s) {
  p.x *= s.x;
  p.y *= s.y;
  p.z *= s.z;
}

static void div(PVector p, PVector s) {
  p.x /= s.x;
  p.y /= s.y;
  p.z /= s.z;
}
