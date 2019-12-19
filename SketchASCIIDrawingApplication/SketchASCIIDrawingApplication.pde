ArrayList<PVector> mLineSegments = new ArrayList();
PVector mSegmentElementA = new PVector();

final float mScaleX = 10;
final float mScaleY = 10;
ASCIICanvas mASCIICanvas;
boolean mSaveASCIICanvas = false;

void settings() {
  size(1024, 768);
}

void setup() {
  textFont(createFont("Courier", 9));
  textAlign(CENTER);
  rectMode(CENTER);

  final int mWidth  = (int)(width / (float)mScaleX);
  final int mHeight = (int)(height / (float)mScaleY);
  mASCIICanvas = new ASCIICanvas(mWidth, mHeight);

  mLineSegments.add(mSegmentElementA);
}

void draw() {
  mSegmentElementA.set(transformMouse());

  mASCIICanvas.clear();
  fill(0);
  for (int i=1; i < mLineSegments.size(); i++) {
    PVector a = mLineSegments.get(i-1);
    PVector b = mLineSegments.get(i);
    mASCIICanvas.line(a.x, a.y, b.x, b.y);
  }

  background(255);
  noStroke();
//  scale(mScaleX, mScaleY);
  for (int y=0; y<mASCIICanvas.height; y++) {
    for (int x=0; x<mASCIICanvas.width; x++) {
      drawChar(x, y, mASCIICanvas.data[x][y]);
    }
  }

  if (mSaveASCIICanvas) {
    saveASCIICanvas("ASCIICanvas_" + frameCount + ".txt");
    mSaveASCIICanvas = false;
  }
}

void drawChar(int x, int y, char c) {
  pushMatrix();
  translate(x * mScaleX, y * mScaleY);
  scale(10 * mScaleY / 100, 10 * mScaleY / 100);
  //scale(1.0/mScaleX, 1.0/mScaleY);
  //scale(10 * mScaleX / 100, 10 * mScaleY / 100);
  translate(-1, 0.265 * (textAscent()+textDescent()));
  text(c, 0, 0);
  popMatrix();
}

PVector transformMouse() {
  float mX = mouseX / (float)mScaleX;
  float mY = mouseY / (float)mScaleY;
  return new PVector(mX, mY);
}

void mousePressed() {
  mSegmentElementA = new PVector();
  mLineSegments.add(mSegmentElementA);
}

void keyPressed() {
  if (key == ' ') {
    mSaveASCIICanvas = true;
  }
}

void saveASCIICanvas(String pFileName) {
  println("### saving ASCII CANVAS\n");

  mASCIICanvas.updateStringView();
  printArray(mASCIICanvas.string_view);
  saveStrings(pFileName, mASCIICanvas.string_view);
}

class ASCIICanvas {
  static final char M_EMPTY_TOKEN = ' ';
  static final char M_INTERSECTION_TOKEN = '+';

  final int width;
  final int height;
  final char[][] data;
  final String[] string_view;

  ASCIICanvas(int pWidth, int pHeight) {
    height = pHeight;
    width = pWidth;
    data = new char[width][height];
    string_view = new String[height];
    clear();
  }

  String[] updateStringView() {
    for (int y=0; y<height; y++) {
      StringBuilder s = new StringBuilder();
      for (int x=0; x<width; x++) {
        s.append(data[x][y]);
      }
      string_view[y] = s.toString();
    }
    return string_view;
  }

  void write(int x, int y, char c) {
    if (x > 0 && x < width) {
      if (y > 0 && y < height) {
        if (data[x][y] == c) {
          return;
        } else if (data[x][y] == M_EMPTY_TOKEN) {
          data[x][y] = c;
        } else {
          data[x][y] = M_INTERSECTION_TOKEN;
        }
      }
    }
  }

  void clear() {
    for (int x=0; x<width; x++) {
      for (int y=0; y<height; y++) {
        data[x][y] = M_EMPTY_TOKEN;
      }
    }
  }

  char getCharFromAngle(PVector a, PVector b) {
    // TODO if x- and y-scale is not uniform the angle needs to be adapted
    PVector p = PVector.sub(a, b);
    float r = limitRadiant(atan2(p.y * mScaleY, p.x * mScaleX));

    char[] mChars = {'-', '\\', '|', '/', '-', '\\', '|', '/'};
    for (int i=0; i<mChars.length+1; i++) {
      final float mOffset = PI * 0.125;
      final float mRadiant = r + mOffset;
      final float mRangeStart = TWO_PI * (float)i/(float)mChars.length;
      final float mRangeEnd = TWO_PI * (float)(i+1)/(float)mChars.length;
      if (mRadiant >= mRangeStart && mRadiant < mRangeEnd) {
        return mChars[i % mChars.length];
      }
    }

    return M_EMPTY_TOKEN;
  }

  float limitRadiant(float r) {
    while (r<0.0) {
      r+=TWO_PI;
    }
    while (r>TWO_PI) {
      r-=TWO_PI;
    }
    return r;
  }

  // from https://rosettacode.org/wiki/Bitmap/Bresenham%27s_line_algorithm#Java

  void line(float x1, float y1, float x2, float y2) {
    bresenham((int)x1, (int)y1, (int) x2, (int)y2);
  }

  void bresenham(int x1, int y1, int x2, int y2) {
    // delta of exact value and rounded value of the dependent variable
    int d = 0;

    int dx = Math.abs(x2 - x1);
    int dy = Math.abs(y2 - y1);

    int dx2 = 2 * dx; // slope scaling factors to
    int dy2 = 2 * dy; // avoid floating point

    int ix = x1 < x2 ? 1 : -1; // increment direction
    int iy = y1 < y2 ? 1 : -1;

    int x = x1;
    int y = y1;

    char c = getCharFromAngle(new PVector(x1, y1), new PVector(x2, y2));

    if (dx >= dy) {
      while (true) {
        write(x, y, c);
        if (x == x2)
          break;
        x += ix;
        d += dy2;
        if (d > dx) {
          y += iy;
          d -= dx2;
        }
      }
    } else {
      while (true) {
        write(x, y, c);
        if (y == y2)
          break;
        y += iy;
        d += dx2;
        if (d > dy) {
          x += ix;
          d -= dy2;
        }
      }
    }
  }
}
