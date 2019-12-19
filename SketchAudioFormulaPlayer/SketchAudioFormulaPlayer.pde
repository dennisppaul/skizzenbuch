float mFreq = 220.0f;
AudioFormulaRenderer mAudioFormulaRenderer;

void settings() {
  size(640, 480);
}

void setup() {
  AudioFormula mAudioFormula = new AudioFormulaMouse();
  mAudioFormulaRenderer = new AudioFormulaRenderer(mAudioFormula);
  new AudioBufferPlayer(mAudioFormulaRenderer);
}

void draw() {
  background(random(240, 255));
  translate(10, height/2);
  mAudioFormulaRenderer.draw(g, width - 20, height/2);
}

class AudioFormulaKnisterKnister implements AudioFormula {
  public float render(int pCounter) {
    final float mSeconds = pCounter / AudioBufferPlayer.SAMPLE_RATE;
    float v;
    v = abs(sin(mSeconds * cos(mSeconds * 1.1f))) * 0.1f;
    v = (mFreq + (v % 0.037));
    v = sin(mSeconds * v + PI * 0.33f);
    v *= v;
    v *= 2 + sin(mSeconds * 21.9f);
    v = AudioBufferPlayer.clamp(v, -1.0f, 1.0f);
    return v;
  }
}

class MAudioFormulaAwayAndAway implements AudioFormula {
  public float render(int pCounter) {
    final float mSeconds = pCounter / AudioBufferPlayer.SAMPLE_RATE;
    final float mSecondsRad = 2.0f * PI * mSeconds;
    float v;
    v = sin(mSecondsRad * (mFreq + sin(mSecondsRad * 0.001) * 110.0f ));
    v -= sin(mSecondsRad * mFreq * 13) * 0.1;
    v *= 1.0 + abs(sin(mSecondsRad * 0.47)) * 2.0f;
    v = AudioBufferPlayer.flip(v);
    v *= pow(sin(mSecondsRad * 0.01), 8) * 0.9 + 0.1;
    return v;
  }
}

class AudioFormulaMouse implements AudioFormula {
  public float render(int pCounter) {
    return sin(2 * PI * mFreq * pCounter++ / AudioBufferPlayer.SAMPLE_RATE);
  }
}
