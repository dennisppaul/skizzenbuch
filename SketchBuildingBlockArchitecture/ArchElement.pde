static class ArchElement {

  private static final ArrayList<ArchElement> oNodes = new ArrayList();
  private final Vector3i v;
  private ArchChildrenStruct mChildren = new ArchChildrenStruct();

  ArchElement() {
    this(new Vector3i(0, 0, 0));
  }

  ArchElement(Vector3i pV) {
    v = new Vector3i(pV);
  }

  ArchChildrenStruct children() {
    return mChildren;
  }

  void update() {
    for (final ArchElement mChild : mChildren.children()) {
      if (mChild != null) {
        mChild.update();
      }
    }
  }

  void draw(PGraphics g) {
    g.noStroke();
    g.fill(255);
    //    g.noFill();
    //    g.stroke(0);
    g.pushMatrix();
    g.translate(v.x, v.y, v.z);
    g.box(1);
    g.popMatrix();

    for (int i = 0; i < mChildren.children().length; i++) {
      ArchElement mChild = mChildren.children()[i];
      if (mChild != null) {
        mChild.draw(g);
      }
    }
  }

  private Vector3i translate(int pDirection) {
    switch (pDirection) {
    case ArchChildrenStruct.UP:
      return new Vector3i(0, 1, 0);
    case ArchChildrenStruct.DOWN:
      return new Vector3i(0, -1, 0);
    case ArchChildrenStruct.LEFT:
      return new Vector3i(-1, 0, 0);
    case ArchChildrenStruct.RIGHT:
      return new Vector3i(1, 0, 0);
    case ArchChildrenStruct.FRONT:
      return new Vector3i(0, 0, -1);
    case ArchChildrenStruct.BACK:
      return new Vector3i(0, 0, 1);
    }
    return new Vector3i(0, 0, 0);
  }

  boolean isLocationAvailableRecursive(Vector3i pV) {
    for (final ArchElement mChild : mChildren.children()) {
      if (mChild != null) {
        boolean mChildIsOccupied = !mChild.isLocationAvailableRecursive(pV);
        if (mChildIsOccupied) {
          return false;
        }
      }
    }
    return !((v.x == pV.x) && (v.y == pV.y) && (v.z == pV.z));
  }

  boolean isLocationAvailableLinear(Vector3i pV) {
    if (pV.y < 0) {
      // early reject negative Y
      return false;
    }

    for (ArchElement a : nodes()) {
      boolean mFoundLocation = isSameLocation(a.v, pV);
      if (mFoundLocation) {
        return false;
      }
    }
    return true;
  }

  void spawnChildren(PApplet p) {
    boolean mShouldSpawn = p.random(1.0f) > 0.5f;
    if (mShouldSpawn) {
      for (int i = 0; i < mChildren.children().length; i++) {
        ArchElement mChild = mChildren.children()[i];
        if (mChild == null) {
          final Vector3i cv = Vector3i.add(v, translate(i));
          boolean isSpaceAvailable = isLocationAvailableLinear(cv);
          if (isSpaceAvailable) {
            final float mChildShouldSpawn = p.random(1.0f);
            if (mChildShouldSpawn > 0.0f && mChildShouldSpawn < 0.4f) {
              mChildren.children()[i] = addNode(new ArchElement(cv));
            } else if (mChildShouldSpawn > 0.4f && mChildShouldSpawn < 0.9f) {
              mChildren.children()[i] = addNode(new ArchElementNull(cv));
            }
          }
        }
      }
    }
  }

  void spawn(PApplet p) {
    for (final ArchElement mChild : mChildren.children()) {
      if (mChild != null) {
        mChild.spawn(p);
      }
    }
    spawnChildren(p);
  }

  private static boolean isSameLocation(ArchElement a, ArchElement b) {
    return isSameLocation(a.v, b.v);
  }

  private static boolean isSameLocation(Vector3i a, Vector3i b) {
    return (a.x == b.x) && (a.y == b.y) && (a.z == b.z);
  }

  static void searchDuplicates() {
    for (ArchElement a : nodes()) {
      for (ArchElement b : nodes()) {
        if (a != b && isSameLocation(a, b)) {
          System.out.println("found dup: " + a.v + " == " + b.v);
        }
      }
    }
  }

  static ArchElement addNode(ArchElement pNode) {
    oNodes.add(pNode);
    return pNode;
  }

  static ArrayList<ArchElement> nodes() {
    return oNodes;
  }
}