import wellen.*;

static final int NUM_OF_INTERPOLATIONS = 32;
FMSynthesis mFMSynthesis;
final float mVisuallyStableFrequency = (float) Wellen.DEFAULT_SAMPLING_RATE / Wellen.DEFAULT_AUDIOBLOCK_SIZE;
final float[][] mWaveSynthFMTerrain = new float[NUM_OF_INTERPOLATIONS][Wellen.DEFAULT_AUDIOBLOCK_SIZE];

void settings() {
    size(640, 480, P3D);
    pixelDensity(2);
}

void setup() {
    Wavetable mCarrier = new Wavetable(2048);
    mCarrier.interpolate_samples(true);
    Wavetable.fill(mCarrier.get_wavetable(), Wellen.OSC_SINE);
    mCarrier.set_frequency(2.0f * mVisuallyStableFrequency);

    Wavetable mModulator = new Wavetable(2048);
    mModulator.interpolate_samples(true);
    Wavetable.fill(mModulator.get_wavetable(), Wellen.OSC_SINE);
    mModulator.set_frequency(2.0f * mVisuallyStableFrequency);

    mFMSynthesis = new FMSynthesis(mCarrier, mModulator);
    mFMSynthesis.set_amplitude(0.33f);

    for (int i = 0; i < NUM_OF_INTERPOLATIONS; i++) {
        mWaveSynthFMTerrain[i] = new float[Wellen.DEFAULT_AUDIOBLOCK_SIZE];
        final float mModularDepths = map(i, 0, NUM_OF_INTERPOLATIONS, 0, 5);
        mFMSynthesis.get_modulator().reset();
        mFMSynthesis.get_carrier().reset();
        mFMSynthesis.set_modulation_depth(mModularDepths);
        for (int j = 0; j < mWaveSynthFMTerrain[i].length; j++) {
            mWaveSynthFMTerrain[i][j] = mFMSynthesis.output();
        }
    }
}

void draw() {
    background(255);
    stroke(0);
    strokeWeight(0.25f);
    translate(width * 0.5f, height * 0.5f, -200);
    rotateY(map(mouseX, 0, width, -PI, PI));
    rotateX(map(mouseY, 0, height, PI, -PI));
    beginShape(LINE_STRIP);
    for (int i = 0; i < mWaveSynthFMTerrain.length; i++) {
        for (int j = 0; j < mWaveSynthFMTerrain[i].length; j++) {
            float x = map(i, 0, mWaveSynthFMTerrain.length, -width * 0.5f, width * 0.5f);
            float y = map(j, 0, mWaveSynthFMTerrain[i].length, -height * 0.5f, height * 0.5f);
            float z = mWaveSynthFMTerrain[i][j] * 100;
            vertex(x, y, z);
        }
    }
    endShape();
}
