import wellen.*;

Wavetable mCarrier;
Wavetable mModulator;
float mDepth;
float mAmplitude;
final float mStableFrequency = (float) Wellen.DEFAULT_SAMPLING_RATE / Wellen.DEFAULT_AUDIOBLOCK_SIZE;

void settings() {
    size(640, 480);
}

void setup() {
    mDepth = 1.0f;
    mAmplitude = 0.33f;

    mCarrier = new Wavetable();
    Wavetable.fill(mCarrier.get_wavetable(), Wellen.OSC_SINE);
    mCarrier.set_frequency(2.0f * mStableFrequency);

    mModulator = new Wavetable();
    Wavetable.fill(mModulator.get_wavetable(), Wellen.OSC_TRIANGLE);
    mModulator.set_frequency(2.0f * mStableFrequency);

    DSP.start(this);
}

void draw() {
    background(255);
    DSP.draw_buffer(g, width, height);
}

void mouseMoved() {
    mDepth = map(mouseX, 0, width, 0, 5);
}

void mouseDragged() {
    mModulator.set_frequency(map(mouseX, 0, width, 0, 4.0f * mStableFrequency));
    mCarrier.set_frequency(map(mouseY, 0, height, 0, 4.0f * mStableFrequency));
}

void audioblock(float[] pOutputSignal) {
    // FM: f(t) = A sin(2πCt + D sin(2πMt))
    // C :: carrier
    // M :: modulator
    // A :: amplitude
    // D :: modulation depth

    for (int i = 0; i < pOutputSignal.length; i++) {
        final float mCarrierSignal = mCarrier.output();
        final float mModulatorSignal = mModulator.output();
        pOutputSignal[i] = mAmplitude * sin(TWO_PI * mCarrierSignal + mDepth * sin(TWO_PI * mModulatorSignal));
    }
}
