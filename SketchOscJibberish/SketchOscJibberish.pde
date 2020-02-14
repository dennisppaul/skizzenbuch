import com.softsynth.jsyn.LineOut;
import com.softsynth.jsyn.SawtoothOscillator;
import com.softsynth.jsyn.Synth;
import com.softsynth.jsyn.SynthOscillator;

SoundSource mSoundSource;

void setup() {
  size(640, 480);
  frameRate(60);
  noFill();
  rectMode(CENTER);
  ellipseMode(CENTER);
  smooth();

  /* start jsyn */
  Synth.startEngine(Synth.FLAG_ENABLE_INPUT, Synth.DEFAULT_FRAME_RATE);

  mSoundSource = new SoundSource();
  mSoundSource.triggerposition().set(width / 2, height / 2, 0);
  mSoundSource.position().set(random(width), random(height), 0);
}

void draw() {
  /* compute */
  if (mousePressed) {
    if (mouseX > mSoundSource.position().x - 30
      && mouseX < mSoundSource.position().x + 30
      && mouseY > mSoundSource.position().y - 30
      && mouseY < mSoundSource.position().y + 30) {
      mSoundSource.position().set(mouseX, mouseY, 0);
    }
  }

  mSoundSource.update();

  /* draw */
  background(255);
  stroke(0, 32);
  line(mSoundSource.triggerposition().x, mSoundSource.triggerposition().y, 
  mSoundSource.position().x, mSoundSource.position().y);
  stroke(255, 127, 0, 127);
  ellipse(mSoundSource.position().x, mSoundSource.position().y, 20, 20);
  stroke(0, 127);
  ellipse(mSoundSource.triggerposition().x, mSoundSource.triggerposition().y, 
  mSoundSource.mMaxDistance * 2, mSoundSource.mMaxDistance * 2);
}

void stop() {
  Synth.stopEngine();
}

class SoundSource {

  SynthOscillator mOsc;

  LineOut mOut;

  PVector myPosition;

  PVector mTriggerPosition;

  float mMaxDistance = 100;

  float mFreqPointer;

  float mAmpPointer;

  SoundSource() {
    myPosition = new PVector();
    mTriggerPosition = new PVector();

    /* create oscillators */
    mOsc = new SawtoothOscillator();
    mOut = new LineOut();

    mOsc.output.connect(0, mOut.input, 0);
    mOsc.output.connect(0, mOut.input, 1);

    mOut.start();
    mOsc.start();

    /* default values */
    mOsc.amplitude.set(0.0f);
    mOsc.frequency.set(200.0f);
  }

  PVector position() {
    return myPosition;
  }

  PVector triggerposition() {
    return mTriggerPosition;
  }

  void update() {
    float myDistanceRatio = (1 - min(1, myPosition.dist(mTriggerPosition) / mMaxDistance));

    mAmpPointer += 0.65f;
    float mAmp = noise(mAmpPointer) * noise(mAmpPointer * 1.3f);
    if (noise(mAmpPointer * 0.45f) > 0.5f) {
      mOsc.amplitude.set(myDistanceRatio * mAmp);
    } 
    else {
      mOsc.amplitude.set(0);
    }

    /* get frequency from perlin noise */
    mFreqPointer += 0.03f;
    float mFreq = noise(mFreqPointer);
    mOsc.frequency.set(400 * mFreq + 75);
  }
}
