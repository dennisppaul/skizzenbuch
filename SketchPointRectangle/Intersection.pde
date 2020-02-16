static class Intersection {
  static ArrayList<PVector> intersectionLineSegmentRectangle(Line pLine, Rectangle pRect) {
    ArrayList<PVector> mPoints = new ArrayList<PVector>();
    PVector p;
    // top
    p = intersectionLineSegments(pLine, 
      new Line(pRect.position.x, 
      pRect.position.y, 
      pRect.position.x + pRect.dimension.x, 
      pRect.position.y));
    add(p, mPoints);
    // bottom
    p = intersectionLineSegments(pLine, 
      new Line(pRect.position.x, 
      pRect.position.y + pRect.dimension.y, 
      pRect.position.x + pRect.dimension.x, 
      pRect.position.y + pRect.dimension.y));
    add(p, mPoints);
    // left
    p = intersectionLineSegments(pLine, 
      new Line(pRect.position.x, 
      pRect.position.y, 
      pRect.position.x, 
      pRect.position.y + pRect.dimension.y));
    add(p, mPoints);
    // right
    p = intersectionLineSegments(pLine, 
      new Line(pRect.position.x + pRect.dimension.x, 
      pRect.position.y, 
      pRect.position.x + pRect.dimension.x, 
      pRect.position.y + pRect.dimension.y));
    add(p, mPoints);
    return mPoints;
  }

  static void add(PVector p, ArrayList<PVector> mPoints) {
    if (p != null) {
      mPoints.add(p);
    }
  }

  static PVector intersectionLineSegments(Line pLineA, Line pLineB) {
    float p0_x = pLineA.p1.x;
    float p0_y = pLineA.p1.y;
    float p1_x = pLineA.p2.x;
    float p1_y = pLineA.p2.y;
    float p2_x = pLineB.p1.x;
    float p2_y = pLineB.p1.y;
    float p3_x = pLineB.p2.x;
    float p3_y = pLineB.p2.y;

    float s1_x, s1_y, s2_x, s2_y;
    s1_x = p1_x - p0_x;
    s1_y = p1_y - p0_y;
    s2_x = p3_x - p2_x;
    s2_y = p3_y - p2_y;

    float s, t;
    s = (-s1_y * (p0_x - p2_x) + s1_x * (p0_y - p2_y)) / (-s2_x * s1_y + s1_x * s2_y);
    t = (s2_x * (p0_y - p2_y) - s2_y * (p0_x - p2_x)) / (-s2_x * s1_y + s1_x * s2_y);

    if (s >= 0 && s <= 1 && t >= 0 && t <= 1) {
      PVector p = new PVector();
      // Collision detected
      p.x = p0_x + (t * s1_x);
      p.y = p0_y + (t * s1_y);
      return p;
    }

    return null; // No collision
  }

  static boolean pointInRectangle(PVector pPoint, Rectangle pRect) {
    final PVector mMin = new PVector(pRect.position.x, pRect.position.y);
    final PVector mMax = new PVector(pRect.position.x + pRect.dimension.x, pRect.position.y + pRect.dimension.y);
    return (pPoint.x >= mMin.x
      && pPoint.x <= mMax.x
      && pPoint.y >= mMin.y
      && pPoint.y <= mMax.y);
  }

  static boolean almost(float a, float b, float pEpsilon) {
    return Math.abs(a - b) < pEpsilon;
  }
}

static class Rectangle {
  PVector position; // upper left corner
  PVector dimension;

  Rectangle() {
    position = new PVector();
    dimension = new PVector();
  }

  Rectangle(float x, float y, float mWidth, float mHeight) {
    this();
    position.x = x;
    position.y = y;
    dimension.x = mWidth;
    dimension.y = mHeight;
  }
}

static class Line {
  PVector p1;
  PVector p2;

  Line() {
    p1 = new PVector();
    p2 = new PVector();
  }

  Line(float x1, float y1, float x2, float y2) {
    this();
    p1.x = x1;
    p1.y = y1;
    p2.x = x2;
    p2.y = y2;
  }
}
