public class AudioFormulaRenderer implements AudioBufferRenderer {

  private final AudioFormula mAudioFormula;
  private int mCounter = 0;
  private float[] mSamples = null;

  AudioFormulaRenderer(AudioFormula pAudioFormula) {
    mAudioFormula = pAudioFormula;
  }

  public void render(float[] pSamples) {
    for (int i=0; i < pSamples.length; i++) {
      pSamples[i] = mAudioFormula.render(mCounter++);
    }
    mSamples = pSamples;
  }

  public float[] buffer() {
    return mSamples;
  }

  public void draw(PGraphics p, float pWidth, float pHeight) {
    if (mSamples != null) {
      for (int i = 0; i < buffer().length; i++) {
        float x = PApplet.map(i, 0, buffer().length, 0, pWidth);
        float y = buffer()[i];
        p.line(x, y * pHeight / 2, x, y * -pHeight / 2);
      }
    }
  }
}
