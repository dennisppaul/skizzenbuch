public interface AudioBufferRenderer {
  void render(float[] pSamples);
}

public interface AudioFormula {
  float render(int pCounter);
}
