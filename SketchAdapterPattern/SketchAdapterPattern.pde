TextProcessor mTextProcessor;

void settings() {
}

void setup() {
    mTextProcessor = new TextProcessor(TextProcessor.ELIZA);
}

void draw() {
}

void keyPressed() {
    if (key == '1') {
        mTextProcessor.changeProcessor(TextProcessor.RANDOM);
    } else if (key == '2') {
        mTextProcessor.changeProcessor(TextProcessor.ELIZA);
    }
    println(mTextProcessor.process("Hello!"));
    println("---");
}

/* --- */

interface ITextProcessor {

    String process(String pText);
}

class TextProcessor {

    final static int RANDOM = 0;
    final static int ELIZA = 1;

    ITextProcessor mProcessorImplementation;

    TextProcessor(int pProcessorType) {
        changeProcessor(pProcessorType);
    }

    String process(String pText) {
        return mProcessorImplementation != null ? mProcessorImplementation.process(pText) : "";
    }

    void changeProcessor(int pProcessorType) {
        if (pProcessorType == RANDOM) {
            mProcessorImplementation = new RandomTextProcessor();
        } else if (pProcessorType == ELIZA) {
            mProcessorImplementation = new ElizaTextProcessor();
        } else {
            mProcessorImplementation = null;
        }
    }
}

class RandomTextProcessor implements ITextProcessor {

    String process(String pText) {
        return (char)random(68, 120) + pText.substring(1, pText.length());
    }
}

class ElizaTextProcessor implements ITextProcessor {

    String process(String pText) {
        return pText + " What?";
    }
}
