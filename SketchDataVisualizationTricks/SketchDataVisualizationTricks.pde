static final int NUM_CHARS = 8;
static final float CHAR_SIZE = 24;
char[][] fChars;
char fHighLight = '4';

void setup() {
    size(1024, 768);
    noStroke();
    textFont(createFont("Helvetica", CHAR_SIZE));
    textAlign(CENTER);

    fChars = new char[NUM_CHARS][NUM_CHARS];
    for (int y=0; y<NUM_CHARS; y++) {
        for (int x=0; x<NUM_CHARS; x++) {
            fChars[x][y] = (char)random('0', '9');
        }
    }
}

void draw() {
    background(255);
    final float mGridSize = 480;
    final float mScale = mGridSize / NUM_CHARS;
    translate(mScale * 0.5, mScale * 0.5);
    translate((width - mGridSize) * 0.5, (height - mGridSize) * 0.5);
    for (int y=0; y<NUM_CHARS; y++) {
        for (int x=0; x<NUM_CHARS; x++) {
            if (mousePressed) {
                if (fHighLight == fChars[x][y]) {
                    fill(255, 0, 0);
                } else {
                    fill(191);
                }
            } else {
                fill(0);
            }
            text(fChars[x][y], x * mScale, y * mScale);
        }
    }
}
