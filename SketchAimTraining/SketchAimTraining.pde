static final int NUMBER_OF_COLLECTED_LINES = 1024;
PVector[] mLineCollector = new PVector[NUMBER_OF_COLLECTED_LINES];
int mLineCollectorCounter = 0;

float mAimInterval = 3.0f;
float mAimIntervalCounter = 0.0f;
Aim mAim;

ArrayList<HitMarker> mHits = new ArrayList<HitMarker>();
int mNumberOfShots = 0;
int mNumberOfAims = 0;

boolean mGameOver = false;

void settings() {
  size(1024, 768, P3D);
}

void setup() {
  frameRate(60);
  textFont(createFont("Helvetica", 164));
  randomSeed(1);

  reset();
}

void reset() {
  mAimInterval = 3.0f;
  mAimIntervalCounter = 0.0f;
  mNumberOfShots = 0;
  mNumberOfAims = 0;
  mHits.clear();
  mGameOver = false;
  mAim = null;
}

boolean isGameOver() {
  return mNumberOfAims >= 10 || mNumberOfShots >= 30;
}

void draw() {
  final float mDelta = 1.0 / frameRate;
  background(50);

  /* OSD */
  fill(mGameOver ? 127 : 255);
  noStroke();
  String mMsg = nf(getHits(), 3) + "/" + nf(mNumberOfShots, 3) + "("+nf(mNumberOfAims, 3)+")";
  text(mMsg, 28, 128);

  /* end game */
  if (isGameOver()) {
    mGameOver = true;
  }

  if (!mGameOver) {
    /* generate aim */
    mAimIntervalCounter += mDelta;
    if (mAimIntervalCounter > mAimInterval) {
      if (mAim == null) {
        setupAim();
        mAimIntervalCounter = 0.0f;
      }
    }
    handleAim(mDelta);

    /* draw lines */
    noFill();
    beginShape();
    for (int i=1; i<NUMBER_OF_COLLECTED_LINES; i++) {
      PVector p = mLineCollector[(i+mLineCollectorCounter) % NUMBER_OF_COLLECTED_LINES];
      float mRatio = (float)i/ (float)NUMBER_OF_COLLECTED_LINES;
      if (p != null) { 
        stroke(255, mRatio*255);
        vertex(p);
      }
    }
    endShape();

    /* draw hits */
    for (int i=0; i<mHits.size(); i++) {
      mHits.get(i).draw();
    }
  }
}

int getHits() {
  int mNumberOfHits = 0;
  for (int i=0; i<mHits.size(); i++) {
    if (mHits.get(i).hit) {
      mNumberOfHits++;
    }
  }
  return mNumberOfHits;
}

void setupAim() {
  mAim = new Aim(random(1, 3));
  final float mPadding = 100;
  mAim.position.set(random(mPadding, width-mPadding), random(mPadding, height-mPadding));
  final float mTargetSpeed = 100;
  mAim.velocity.set(random(-mTargetSpeed, mTargetSpeed), random(-mTargetSpeed, mTargetSpeed));
  mAim.radius = random(10, 20);

  mNumberOfAims++;
}

void handleAim(float pDelta) {
  if (mAim != null) {
    mAim.handle(pDelta);
    mAim.draw();
    if (mAim.dead()) {
      finishAim();
    }
  }
}

void finishAim() {
  if (mAim != null) {
    println("hit aim for " + mAim.on_aim + " sec.");
    mAim = null;
  }
}

void addLine() {
  mLineCollectorCounter++;
  mLineCollectorCounter%=NUMBER_OF_COLLECTED_LINES;
  mLineCollector[mLineCollectorCounter] = new PVector(mouseX, mouseY);
}

void keyPressed() {
  if (key == ' ') {
    reset();
  }
  if (key == 'r') {
    randomSeed(System.currentTimeMillis());
  }
}

void mouseMoved() {
  addLine();
}

void mouseDragged() {
  addLine();
}

void mousePressed() {
  if (!isGameOver()) {
    mNumberOfShots++;
  }
  if (!isGameOver()) {
    if (mAim != null) {
      markHit(mAim.hit());
    } else {
      markHit(false);
    }
  }
}

void markHit(boolean isHit) {
  HitMarker mHitMarker = new HitMarker(isHit);
  mHitMarker.position.set(mouseX, mouseY);
  mHits.add(mHitMarker);
}

void vertex(PVector p) {
  vertex(p.x, p.y);
}

class Aim {
  final float lifespan;
  float time = 0.0f;
  PVector position = new PVector();
  float radius = 0.0f;
  float on_aim = 0.0f;
  int hit_counter = 0;
  boolean MOVE_AIM = true;
  PVector velocity = new PVector();

  Aim(float pLifeSpan) {
    lifespan = pLifeSpan;
  }

  void draw() {
    noStroke();
    fill(0, 127, 255);
    ellipse(position.x, position.y, radius*2, radius*2);

    stroke(255, 127);
    noFill();
    final float mOnTargetRatio = on_aim / lifespan;
    final float mOnTargetSize = mOnTargetRatio * radius*2 + radius*2;
    ellipse(position.x, position.y, mOnTargetSize, mOnTargetSize);
  }

  void handle(float pDelta) {
    if (MOVE_AIM) {
      position.x += velocity.x * pDelta;
      position.y += velocity.y * pDelta;
    }
    if (hit()) {
      on_aim += pDelta;
    }
    time += pDelta;
  }

  boolean hit() {
    float mDistanceToMouse = dist(mouseX, mouseY, position.x, position.y);
    return mDistanceToMouse < radius;
  }

  boolean dead() {
    return time > lifespan;
  }
}

class HitMarker {
  PVector position = new PVector();
  float radius = 10;
  final boolean hit;

  HitMarker(boolean pHit) {
    hit = pHit;
  }

  void draw() {
    if (hit) {
      stroke(0, 255, 127, 91);
      noFill();
      ellipse(position.x, position.y, radius*2, radius*2);
    } else {
      stroke(255, 127, 0, 91);
      noFill();
      pushMatrix();
      translate(position.x, position.y);
      final float mRadius = radius * 0.75f;
      line(-mRadius, -mRadius, mRadius, mRadius);
      line(-mRadius, mRadius, mRadius, -mRadius);
      popMatrix();
    }
  }
}