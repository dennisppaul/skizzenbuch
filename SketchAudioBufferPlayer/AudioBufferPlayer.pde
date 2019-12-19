import javax.sound.sampled.*;

public interface AudioBufferRenderer {
  void render(float[] pSamples);
}

public class AudioBufferPlayer extends Thread {

  public static final int SAMPLE_RATE = 44100;
  public static final int BYTES_PER_SAMPLE = 2;       // 16-bit audio
  public static final int BITS_PER_SAMPLE = 16;       // 16-bit audio
  public static final double MAX_16_BIT = 32768;
  public static final int SAMPLE_BUFFER_SIZE = 4096;

  public static final int MONO   = 1;
  public static final int STEREO = 2;
  public static final boolean LITTLE_ENDIAN = false;
  public static final boolean BIG_ENDIAN    = true;
  public static final boolean SIGNED        = true;
  public static final boolean UNSIGNED      = false;

  private SourceDataLine line;
  private byte[] buffer;

  private boolean mRunBuffer = true;
  private final AudioBufferRenderer mSamplerRenderer;

  public AudioBufferPlayer(AudioBufferRenderer pSamplerRenderer) {
    mSamplerRenderer = pSamplerRenderer;

    try {
      // 44,100 Hz, 16-bit audio, mono, signed PCM, little endian
      AudioFormat format = new AudioFormat(SAMPLE_RATE, BITS_PER_SAMPLE, MONO, SIGNED, LITTLE_ENDIAN);
      DataLine.Info info = new DataLine.Info(SourceDataLine.class, format);

      line = (SourceDataLine) AudioSystem.getLine(info);
      line.open(format, SAMPLE_BUFFER_SIZE * BYTES_PER_SAMPLE);

      buffer = new byte[SAMPLE_BUFFER_SIZE * BYTES_PER_SAMPLE];
    }
    catch (LineUnavailableException e) {
      System.err.println(e.getMessage());
    }

    line.start();
  }

  public void run() {
    while (mRunBuffer) {
      final float[] mBuffer = new float[SAMPLE_BUFFER_SIZE];
      mSamplerRenderer.render(mBuffer);
      for (int i=0; i < mBuffer.length; i++) {
        writeSample(mBuffer[i], i);
      }
      line.write(buffer, 0, buffer.length);
    }
  }

  public void close() {
    mRunBuffer = false;
    line.drain();
    line.stop();
    line.close();
  }

  private final void writeSample(final float sample, final int i) {
    short s = (short) (MAX_16_BIT * sample);
    if (sample == 1.0) { 
      s = Short.MAX_VALUE; // special case since 32768 not a short
    }
    buffer[i*2+0] = (byte) s;
    buffer[i*2+1] = (byte) (s >> 8); // little endian
  }
}
