float mDividend = 0.5;
float mDivisor = -5;

void setup() {
    size(1024, 768);
    noStroke();
    fill(0);
    frameRate(5);
}

void draw() {
    float i = mDividend % mDivisor;
    float j = fmod(mDividend, mDivisor);
    mDividend++;

    background(255);
    circle(width / 2 + 100, height / 2, i * 20 + 20);
    circle(width / 2 - 100, height / 2, j * 20 + 20);
}

float fmod(float pDividend, float pDivisor) {
    float j = (int)( pDividend / pDivisor ) * pDivisor;
    j = pDividend - j;
    return j;
}
