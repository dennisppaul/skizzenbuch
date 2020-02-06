import de.hfkbremen.mesh.*;

ModelData mModelDataA;
ModelData mModelDataB;
float mCounter = 0;
int mLenghtMax;

void settings() {
  size(1024, 768, P3D);
}

void setup() {
  mModelDataA = ModelLoaderOBJ.parseModelData(OBJStranger001.DATA);
  mModelDataB = ModelLoaderOBJ.parseModelData(OBJStranger002.DATA);

  mLenghtMax = max(mModelDataA.vertices().length, mModelDataB.vertices().length);

  println(mModelDataA);
  println(mModelDataB);
}

void draw() {
  background(50);

  translate(width / 2, height / 2, -200);
  rotateX(sin(frameCount * 0.001f) * TWO_PI);
  rotateY(cos(frameCount * 0.00037f) * TWO_PI);

  noFill();

  mCounter += 1.0 / frameRate;
  float mLerp = 1.0 - pow(abs(sin(mCounter * 0.25)), 5);

  stroke(255, 91);
  beginShape(POINTS);
  for (int i = 0; i < mLenghtMax; i += 3) {
    int j = i % mModelDataA.vertices().length;
    int k = i % mModelDataB.vertices().length;
    float x = lerp(mModelDataA.vertices()[j + 0], mModelDataB.vertices()[k + 0], mLerp);
    float y = lerp(mModelDataA.vertices()[j + 1], mModelDataB.vertices()[k + 1], mLerp);
    float z = lerp(mModelDataA.vertices()[j + 2], mModelDataB.vertices()[k + 2], mLerp);
    vertex(x, y, z);
  }
  endShape();
}
