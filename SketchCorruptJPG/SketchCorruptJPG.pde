byte[] mRawData;
PImage mImage;
int mCorruptBlockStart;
final int CORRUPT_STRATEGY_ZERO = 0;
final int CORRUPT_STRATEGY_RANDOM = 1;
int mCorrputStrategy = CORRUPT_STRATEGY_ZERO;

void settings() {
    size(1024, 768);
}

void setup() {
    mCorruptBlockStart = 900;
}

void draw() {
    background(255);

    mCorruptBlockStart++;
    sequentiallyCorruptImage(64, mCorruptBlockStart);

    if (mImage != null) {
        image(mImage, 0, 0, width, height);
        saveFrame("output-cleaned/seq-corrupted-####.jpg");
    }
}

void keyPressed() {
    randomCorruptImage(2, 2560, 0, 20000);
}

void randomCorruptImage(int pNumOfCorruptions, int pCorruptBlockSize, int pRandomStart, int pRandomEnd) {
    String mImageName = "output/rnd-corrputed-"+System.currentTimeMillis()+".jpg";
    mRawData = loadBytes("Martin-Gore-Studio.jpg");

    for (int i = 0; i < pNumOfCorruptions; i++) {
        final int mStart = (int)random(pRandomStart, pRandomEnd);
        final int mEnd = mStart + pCorruptBlockSize;
        mRawData = corruptRawJPEG(mRawData, mStart, mEnd);
    }
    saveBytes(mImageName, mRawData);

    mImage = loadImage(mImageName);
}

void sequentiallyCorruptImage(int pCorruptBlockSize, int pCorruptBlockStart) {
    String mImageName = "output/seq-corrupted-"+nf(frameCount, 4)+".jpg";
    mRawData = loadBytes("Martin-Gore-Studio.jpg");

    final int mStart = pCorruptBlockStart;
    final int mEnd = mStart + pCorruptBlockSize;
    mRawData = corruptRawJPEG(mRawData, mStart, mEnd);
    saveBytes(mImageName, mRawData);

    mImage = loadImage(mImageName);
}

byte[] corruptRawJPEG(byte[] pRawData, int pStart, int pEnd) {
    if ( pStart >= 0 && pEnd < pRawData.length) {
        for (int i = pStart; i < pEnd; i++) {
            switch(mCorrputStrategy) {
            case CORRUPT_STRATEGY_ZERO:
                pRawData[i] = 0;
                break;
            case CORRUPT_STRATEGY_RANDOM: 
                pRawData[i] = (byte)random(-127, 127);
                break;
            }
        }
    }
    return pRawData;
}
