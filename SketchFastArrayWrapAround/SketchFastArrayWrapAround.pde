final int M_ITERATIONS = 9;
int[] mArray = {5, 2, 9, 3}; // array length must be *power of two*

for (int i=0; i<M_ITERATIONS; i++) {
  int mIndex = i & (mArray.length - 1); // wraps if array length is *power of two*
  println(mArray[mIndex]);
}
