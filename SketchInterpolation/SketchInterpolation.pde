float fDuration = 0;
float fDurationMillis = 0;
float fMillis = 0;
Interpolator fInterpolator = new Interpolator();

PGraphics interpolation_view;
float x = 0;

void setup() {
    size(1024, 768);
    noStroke();
    fill(0);
    fMillis = millis();

    reset_interpolator();

    interpolation_view = createGraphics(1024, 768);
    interpolation_view.beginDraw();
    interpolation_view.background(255);
    interpolation_view.noStroke();
    interpolation_view.fill(0);
    interpolation_view.endDraw();
}

void draw() {
    background(255);
    float mDelta = 1.0 / frameRate;
    fDuration += mDelta;

    float mDeltaMillis = millis() - fMillis;
    fDurationMillis += mDeltaMillis;
    fMillis = millis();

    if (fInterpolator != null) {
        fInterpolator.step(mDeltaMillis);
        if (fInterpolator.in_range()) {
            println(fInterpolator.current());
        }
    }

    draw_interpolation_view(mDeltaMillis);
    draw_interpolation_circle();
}

void draw_interpolation_circle() {
    circle(width * 0.5, height * 0.5, fInterpolator.in_range() ? fInterpolator.current() : fInterpolator.end);
}

void draw_interpolation_view(float delta_millis) {
    interpolation_view.beginDraw();
    x += delta_millis * 0.1;
    if ( x > width ) {
        x %= width;
        interpolation_view.background(255);
    }
    float y = fInterpolator.in_range() ? fInterpolator.current() : fInterpolator.end;
    interpolation_view.circle(x, y, 2);
    interpolation_view.endDraw();
    image(interpolation_view, 0, 0);
}

void reset_interpolator() {
    fInterpolator.start = fDurationMillis + 1000; // start 1000 milliseconds after current time to …
    fInterpolator.duration = 3000;                // … interpolate for 3000 milliseconds …
    fInterpolator.begin = 100;                    // … from value 100 …
    fInterpolator.end = 255;                      // … to value 255.
    fInterpolator.reset(fDurationMillis);
}

void keyPressed() {
    switch(key) {
    case '1':
        fInterpolator.interpolation_type = Interpolator.INTERPOLATE_LINEAR;
        break;
    case '2':
        fInterpolator.interpolation_type = Interpolator.INTERPOLATE_EXPONENTIAL;
        fInterpolator.interpolation_type_modifier = 2;
        break;
    case '3':
        fInterpolator.interpolation_type = Interpolator.INTERPOLATE_SINOID;
        break;
    case '4':
        fInterpolator.interpolation_type = Interpolator.INTERPOLATE_SMOOTHSTEP;
        break;
    }
    reset_interpolator();
}

class Interpolator {
    static final int INTERPOLATE_LINEAR = 0;
    static final int INTERPOLATE_EXPONENTIAL = 1;
    static final int INTERPOLATE_SINOID = 2;
    static final int INTERPOLATE_SMOOTHSTEP = 3;

    int interpolation_type;
    float interpolation_type_modifier;

    float start;
    float duration;
    float begin;
    float end;

    float fCurrentTime;
    float fCurrentValue;
    boolean fInRange;

    Interpolator() {
        interpolation_type = INTERPOLATE_LINEAR;
        interpolation_type_modifier = 1.0;
    }

    void step(float pDelta) {
        fCurrentTime += pDelta;
        float mRatio = (fCurrentTime - start) / duration;
        update_value(mRatio);
    }

    void step_absolute(float pAbsolute) {
        float mRatio = (pAbsolute - start) / duration;
        update_value(mRatio);
    }

    float ratio_linear(float pRatio) {
        return pRatio;
    }

    float ratio_exponential(float pRatio, float pExponent) {
        return pow(pRatio, pExponent);
    }


    float ratio_sinoid(float pRatio) {
        return sin(pRatio * PI * 0.5);
    }

    float ratio_smoothstep (float pRatio) {
        return pRatio * pRatio * (3.0f - 2.0f * pRatio);
    }

    void update_value(float pRatio) {
        float mRatio = 0;
        switch(interpolation_type) {
        case INTERPOLATE_LINEAR:
            mRatio = ratio_linear(pRatio);
            break;
        case INTERPOLATE_EXPONENTIAL:
            mRatio = ratio_exponential(pRatio, interpolation_type_modifier);
            break;
        case INTERPOLATE_SINOID:
            mRatio = ratio_sinoid(pRatio);
            break;
        case INTERPOLATE_SMOOTHSTEP:
            mRatio = ratio_smoothstep(pRatio);
            break;
        }
        fCurrentValue = (end - begin) * mRatio + begin;
        fInRange = (pRatio >=0.0 && pRatio <= 1.0);
    }

    void reset(float pCurrentTime) {
        fCurrentTime = pCurrentTime;
        fCurrentValue = begin;
        fInRange = false;
    }

    boolean in_range() {
        return fInRange;
    }

    float current() {
        return fCurrentValue;
    }
}
