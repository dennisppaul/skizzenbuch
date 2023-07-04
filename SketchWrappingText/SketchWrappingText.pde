String fText = "A year is the orbital period of a planetary body, for example, the Earth, moving in its orbit around the Sun. Due to the Earth's axial tilt, the course of a year sees the passing of the seasons, marked by change in weather, the hours of daylight, and, consequently, vegetation and soil fertility.";
int fMaxCharPerLine = 23;
final float fCharWidth = 11;
final float fLineHeight = 20;
final int fMaxLines = 3;

PFont fProportionalFont;
PFont fMonospacedFont;

void setup() {
    size(1024, 768);
    stroke(0);
    fill(0);

    fMonospacedFont = createFont("Courier", 12);
    fProportionalFont = createFont("Times", 20);

    print_array_list(chop_after_word(fText, fMaxCharPerLine));
    print_array_list(chop_after_char(fText, fMaxCharPerLine));

    textFont(fProportionalFont);
    print_array_list(chop_after_word_proportional(fText, 200));
}

void print_array_list(ArrayList<String> text) {
    for (int i = 0; i < text.size(); i++) {
        println(nf(i, 3) + ": " + text.get(i));
    }
    println();
}

void draw() {
    background(255);

    float x;
    float y;
    fMaxCharPerLine = (int)map(mouseX, 0, width, 15, 30);

    textFont(fMonospacedFont);
    x = 100;
    y = 100;
    draw_wrapped_after_char(fText, fMaxCharPerLine, x, y);
    y = 100 - fLineHeight;
    line(x, y, x + fMaxCharPerLine * fCharWidth, y);

    x = fCharWidth * fMaxCharPerLine + 150;
    y = 100;
    draw_wrapped_after_word(fText, fMaxCharPerLine, x, y);
    y = 100 - fLineHeight;
    line(x, y, x + fMaxCharPerLine * fCharWidth, y);

    textFont(fProportionalFont);
    x = 100;
    y = 500;
    float mMaxLength = map(mouseX, 0, width, 100, 600);
    ArrayList<String>  text = chop_after_word_proportional(fText, mMaxLength);
    for (int i = 0; i < text.size(); i++) {
        text(text.get(i), x, y + i * fLineHeight);
    }
    y = 500 - fLineHeight;
    line(x, y, x + mMaxLength, y);
}

void draw_wrapped_after_word(String text, int max_length, float x, float y) {
    float mX = x;
    float mY = y;

    int mCharactersPerLine = 0;
    boolean mScheduleLineBreak = false;
    for (int i = 0; i < text.length(); i++) {
        char mChar = text.charAt(i);
        text(mChar, mX, mY);
        mX += fCharWidth;

        mScheduleLineBreak = mCharactersPerLine >= max_length;

        if (mScheduleLineBreak && mChar == ' ') {
            mY += fLineHeight;
            mX = x;
            mCharactersPerLine = 0;
        }
        mCharactersPerLine++;
    }
}

void draw_wrapped_after_char(String text, int max_length, float x, float y) {
    float mX = x;
    float mY = y;

    int mCharactersPerLine = 0;
    for (int i = 0; i < text.length(); i++) {
        char mChar = text.charAt(i);

        /* special case space character first in a line */
        if (!(mCharactersPerLine % max_length == 0 && mChar == ' ')) {
            text(mChar, mX, mY);
            mX += fCharWidth;
            mCharactersPerLine++;
        }

        if (mCharactersPerLine >= max_length) {
            mY += fLineHeight;
            mX = x;
            mCharactersPerLine = 0;
        }
    }
}

ArrayList<String> chop_after_word_proportional(String text, float max_length) {
    ArrayList<String> mChoppedText = new ArrayList<String>();
    String mText = "";
    boolean mScheduleLineBreak = false;
    float mLineWidth = 0;
    for (int i = 0; i < text.length(); i++) {
        char mChar = text.charAt(i);
        mLineWidth += textWidth(mChar);
        mScheduleLineBreak = mLineWidth >= max_length;
        if (mScheduleLineBreak && mChar == ' ') {
            mChoppedText.add(mText);
            mText = "";
            mLineWidth = 0;
        } else {
            mText += mChar;
        }
    }
    if (!mText.isEmpty()) {
        mChoppedText.add(mText);
    }
    return mChoppedText;
}

ArrayList<String> chop_after_word(String text, int max_length) {
    ArrayList<String> mChoppedText = new ArrayList<String>();
    String mText = "";
    boolean mScheduleLineBreak = false;
    for (int i = 0; i < text.length(); i++) {
        char mChar = text.charAt(i);
        mScheduleLineBreak = mText.length() >= max_length;
        if (mScheduleLineBreak && mChar == ' ') {
            mChoppedText.add(mText);
            mText = "";
        } else {
            mText += mChar;
        }
    }
    if (!mText.isEmpty()) {
        mChoppedText.add(mText);
    }
    return mChoppedText;
}

ArrayList<String> chop_after_char(String text, int max_length) {
    ArrayList<String> mChoppedText = new ArrayList<String>();
    String mText = "";
    for (int i = 0; i < text.length(); i++) {
        char mChar = text.charAt(i);

        /* special case space character */
        if (!(mText.length() % max_length == 0 && mChar == ' ')) {
            mText += mChar;
        }

        if (mText.length() >= max_length) {
            mChoppedText.add(mText);
            mText = "";
        }
    }
    if (!mText.isEmpty()) {
        mChoppedText.add(mText);
    }
    return mChoppedText;
}
