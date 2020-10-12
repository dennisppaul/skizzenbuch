byte[] mRawData;
PImage mImage;
int mCorruptBlockStart;
int mCorruptBlockSize;
int mCorruptOffset;
int mCorruptIterrationsPerFrame;
int mCorruptBlockStartStep;
int mFileLength;

//final String SOURCE_FILENAME = "Martin-Gore-Studio.jpg";
//final String SOURCE_FILENAME = "imgpsh_mobile_save.jpg";
final String SOURCE_FILENAME = "imgpsh_mobile_save_min.jpg";
//final String SOURCE_FILENAME = "imgpsh_mobile_save_noise.jpg";

void settings() {
    size(960, 540);
}

void setup() {
    mCorruptBlockStart = 1000;
    mCorruptBlockSize = 1;
    mCorruptOffset = 1024;
    mCorruptIterrationsPerFrame = 32;
    mCorruptBlockStartStep = 1024;

    mFileLength = loadBytes(SOURCE_FILENAME).length;
}

void draw() {
    background(255);

    //mCorruptBlockSize = (int)map(mouseX, 0, width, 0, 16);
    //mCorruptOffset = 256 * (int)map(mouseY, 0, height, 0, 16);

    mCorruptBlockStart+=mCorruptBlockStartStep;
    beginCorrupt();
    for (int i = 0; i < mCorruptIterrationsPerFrame; i++) {
        int mBlockStart = i * mCorruptOffset + mCorruptBlockStart;
        //int mBlockStart = (int)random(1000, mFileLength);
        final int mOmmitIDs = 900;
        mBlockStart %= mFileLength - mOmmitIDs;
        mBlockStart += mOmmitIDs;
        corruptBlock(mCorruptBlockSize, mBlockStart);
    }
    endCorrupt();

    if (mImage != null) {
        image(mImage, 0, 0, width, height);
        saveFrame("output-cleaned/seq-corrupted-####.jpg");
    }
}

void beginCorrupt() {
    mRawData = loadBytes(SOURCE_FILENAME);
}

void corruptBlock(int pCorruptBlockSize, int pCorruptBlockStart) {
    final int mStart = pCorruptBlockStart;
    final int mEnd = mStart + pCorruptBlockSize;
    mRawData = corruptRawJPEG(mRawData, mStart, mEnd);
}

void endCorrupt() {
    String mImageName = "output/seq-corrupted-"+nf(frameCount, 4)+".jpg";
    saveBytes(mImageName, mRawData);
    mImage = loadImage(mImageName);
}

byte[] corruptRawJPEG(byte[] pRawData, int pStart, int pEnd) {
    if ( pStart >= 0 && pEnd < pRawData.length) {
        for (int i = pStart; i < pEnd; i++) {
            pRawData[i] = 0;
        }
    }
    return pRawData;
}
