public static String now() {
  return nf(year(), 4) + nf(month(), 2) + nf(day(), 2) + nf(hour(), 2) + nf(minute(), 2) + nf(second(), 2);
}

public static String[] getFiles(final String pFolderPath, final String pFileExtension) {
  java.io.File folder = new java.io.File(pFolderPath);
  java.io.FilenameFilter mFileFilter = new java.io.FilenameFilter() {
    public boolean accept(File dir, String name) {
      return name.toLowerCase().endsWith("." + pFileExtension);
    }
  };
  String[] mFilenames = folder.list(mFileFilter);
  return mFilenames;
}


void convert_array() {

  int myWidth = 2;
  int myHeight = 3;

  /* 1D array to 2D array */
  boolean[] my1Darray = new boolean[myWidth*myHeight];
  boolean[][] my2Darray = new boolean[myWidth][myHeight];
  for (int i=0; i < my1Darray.length; ++i) {
    int x = i % myWidth;
    int y = i / myWidth;
    println(x+", "+y+": "+i);
    my2Darray[x][y] = true;
  }

  println();

  /* 2D array to 1D aray */
  for (int y=0; y < myHeight; ++y) {
    for (int x=0; x < myWidth; ++x) {
      int i = x + y * myWidth;
      println(x+", "+y+": "+i); 
      my1Darray[i] = false;
    }
  }
}

double frequency(int pHalfToneOffset, double pBaseFreq) {
  // f(x) = 440Hz * 2^(x/12)
  return pBaseFreq * Math.pow(2.0, (pHalfToneOffset / 12.0));
}
