// lightning
// @REF(https://www.youtube.com/watch?v=RLWIBrweSU8)

LightningSegment mRoot;
final int MAX_ITERATION_LEVELS = 32;

void settings() {
  size(1024, 768);
}

void setup() {
}

void draw() {
  background(50);

  if (mRoot != null) {
    mRoot.update();
    drawOrigin(g);
    mRoot.draw(g);
  }
}

void drawOrigin(PGraphics pg) {
  pg.noStroke();
  pg.fill(255, 31);
  pg.ellipse(mRoot.position.x, mRoot.position.y, 20, 20);
  pg.fill(255, 64);
  pg.ellipse(mRoot.position.x, mRoot.position.y, 10, 10);
  pg.noFill();
}

void mousePressed() {
  spawnLightning();
}

void spawnLightning() {
  mRoot = new LightningSegment(MAX_ITERATION_LEVELS);
  mRoot.position.set(mouseX, mouseY);
  lightning_hit_ground = false;
}

static boolean lightning_hit_ground = false;

class LightningSegment {
  final int MAX_NUMBER_OF_CHILDREN = 2;
  final float X_OFFSET = 10;
  final float Y_OFFSET_MIN = 10;
  final float Y_OFFSET_MAX = 20;
  final int MAX_ITERATIONS = 10;
  final float SPAWN_PROBABILITY = 0.7;


  PVector position = new PVector();
  ArrayList<LightningSegment> children = new ArrayList<LightningSegment>();
  int mIterations = 0;
  boolean mSpawned = false;
  int mLevel = 0;

  LightningSegment(int pLevel) {
    mLevel = pLevel;
  }

  void draw(PGraphics pg) {
    for (LightningSegment ls : children) {
      final float mGlowScale = 4;
      pg.strokeWeight(mGlowScale * (0.2 + 1.0));
      pg.stroke(255, 15);
      pg.line(position.x, position.y, ls.position.x, ls.position.y);

      pg.strokeWeight(0.2 + 2 * mLevel / (float)MAX_ITERATION_LEVELS);
      pg.stroke(255, 63);
      pg.line(position.x, position.y, ls.position.x, ls.position.y);

      ls.draw(pg);
    }
  }

  void update() {
    mIterations++;

    //spawn_max_children();
    spawn_once();

    if (position.y > height) {
      lightning_hit_ground = true;
    }

    for (LightningSegment ls : children) {
      ls.update();
    }
  }

  void spawn_once() {
    if (
      mLevel > 0 
      && !mSpawned 
      && children.size() == 0 
      && mIterations < MAX_ITERATIONS 
      && random(1.0) < SPAWN_PROBABILITY
      ) {
      mSpawned = true;
      int[] mNumberOfChildrenProbabilities = {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2};
      int mNumberOfChildren = mNumberOfChildrenProbabilities[(int)random(0, mNumberOfChildrenProbabilities.length)];
      int mChildrenLevel = mLevel - 1;
      for (int i=0; i < mNumberOfChildren; i++) {
        LightningSegment mChild = new LightningSegment(mChildrenLevel);
        mChild.position.set(getNewPosition());
        children.add(mChild);
      }
    }
  }

  void spawn_max_children() {
    if (children.size() < MAX_NUMBER_OF_CHILDREN && mIterations < MAX_ITERATIONS) {
      if (random(1.0) < SPAWN_PROBABILITY) {
        LightningSegment mChild = new LightningSegment(mLevel--);
        mChild.position.set(getNewPosition());
        children.add(mChild);
      }
    }
  }

  PVector getNewPosition() {
    PVector mPosition = new PVector();
    mPosition.set(position);
    mPosition.x += random(-X_OFFSET, X_OFFSET);
    mPosition.y += random(Y_OFFSET_MIN, Y_OFFSET_MAX);
    return mPosition;
  }
}
