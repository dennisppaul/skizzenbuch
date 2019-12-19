void setup() {
  int[] mArray = new int[4];
  mArray[0] = 10;
  mArray[1] = 20;
  mArray[2] = 30;
  mArray[3] = 40;
  printArray(mArray);

  int[]  mArrayRandomized = randomizeArray(mArray);
  printArray(mArrayRandomized);
}

int[] randomizeArray(int[] pArray) {
  ArrayList<Integer> a = new ArrayList<Integer>();
  int[] mArray = new int[pArray.length];
  for (int i=0; i< pArray.length; i++) {
    a.add(pArray[i]);
  }
  for (int i=0; i< mArray.length; i++) {
    int mRandomID = (int)random(a.size());
    mArray[i] = a.remove(mRandomID);
  }
  return mArray;
}
