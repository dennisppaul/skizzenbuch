static int lo_byte_16i(int i) {
    return (i & 0xFF); // uint8_t
}

static int hi_byte_16i(int i) {
    return ((i >> 8) & 0xFF);
}

static String now() {
    return nf(year(), 4) + nf(month(), 2) + nf(day(), 2) + nf(hour(), 2) + nf(minute(), 2) + nf(second(), 2);
}

static String[] getFiles(final String pFolderPath, final String pFileExtension) {
    java.io.File folder = new java.io.File(pFolderPath);
    java.io.FilenameFilter mFileFilter = new java.io.FilenameFilter() {
        public boolean accept(File dir, String name) {
            return name.toLowerCase().endsWith("." + pFileExtension);
        }
    };
    String[] mFilenames = folder.list(mFileFilter);
    return mFilenames;
}

static float array_1D_to_2D(float[][] pArray, int i) {
    int x = i % pArray.length;
    int y = i / pArray.length;
    return pArray[x][y];
}

static float array_2D_to_1D(float[] pArray, int x, int y, int pWidth) {
    int i = x + y * pWidth;
    return pArray[i];
}

static double frequency(int pHalfToneOffset, double pBaseFreq) {
    // f(x) = 440Hz * 2^(x/12)
    return pBaseFreq * Math.pow(2.0, (pHalfToneOffset / 12.0));
}

PVector transformToGlobal(PVector pLocal) {
    PVector mWorld = new PVector();
    PMatrix m = getMatrix();
    m.mult(pLocal, mWorld);
    return mWorld;
}

void setup() {
    int a = -2;
    println(lo_byte_16i(a));
    println(hi_byte_16i(a));

    /* transform to global */
    rotate(PI/8);
    translate(123, 456);
    PVector mLocal = new PVector(10, 20);
    PVector mWorld = transformToGlobal(mLocal);
    println(mLocal, mWorld);
}
