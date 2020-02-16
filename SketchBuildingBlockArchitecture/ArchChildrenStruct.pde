static class ArchChildrenStruct {

  static final int UP = 0;
  static final int DOWN = 1;
  static final int LEFT = 2;
  static final int RIGHT = 3;
  static final int FRONT = 4;
  static final int BACK = 5;
  static final int NUM_SIDES = 6;

  private final ArchElement[] mChildren = new ArchElement[NUM_SIDES];

  ArchElement[] children() {
    return mChildren;
  }
}